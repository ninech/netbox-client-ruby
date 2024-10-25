# frozen_string_literal: true

module NetboxClientRuby
  module Entities
    include NetboxClientRuby::Communication
    include Enumerable

    def self.included(other_klass)
      other_klass.extend ClassMethods
    end

    module ClassMethods
      def self.extended(other_klass)
        @other_klass = other_klass
      end

      def data_key(key = 'data')
        @data_key ||= key
      end

      def count_key(key = 'count')
        @count_key ||= key
      end

      def limit(limit = nil)
        return @limit if @limit

        @limit = limit || NetboxClientRuby.config.netbox.pagination.default_limit

        if @limit.nil?
          raise ArgumentError,
                "Whether 'limit' nor 'default_limit' are defined."
        end

        check_limit @limit

        @limit
      end

      def check_limit(limit)
        max_limit = NetboxClientRuby.config.netbox.pagination.max_limit
        if limit.nil?
          raise ArgumentError,
                "'limit' can not be nil."
        elsif !limit.is_a?(Numeric)
          raise ArgumentError,
                "The limit '#{limit}' is not numeric but it has to be."
        elsif !limit.integer?
          raise ArgumentError,
                "The limit '#{limit}' is not integer but it has to be."
        elsif limit.negative?
          raise ArgumentError,
                "The limit '#{limit}' is below zero, but it should be zero or bigger."
        elsif limit > max_limit
          raise ArgumentError,
                "The limit '#{limit}' is bigger than the configured limit value ('#{max_limit}')."
        end
      end

      def entity_creator(creator = nil)
        return @entity_creator if @entity_creator

        raise ArgumentError, '"entity_creator" has not been defined.' unless creator

        @entity_creator = creator
      end

      def path(path = nil)
        return @path if @path

        raise ArgumentError, '"path" has not been defined.' unless path

        @path = path
      end
    end

    def find_by(attributes)
      fail ArgumentError, '"attributes" expects a hash' unless attributes.is_a? Hash

      filter(attributes).find do |netbox_object|
        attributes.all? do |filter_key, filter_value|
          if filter_key.to_s.start_with?('cf_')
            custom_field = filter_key.to_s.sub('cf_', '')

            netbox_object.custom_fields[custom_field].to_s == filter_value.to_s
          else
            if netbox_object.respond_to?(filter_key)
              netbox_object.public_send(filter_key).to_s == filter_value.to_s
            else
              false
            end
          end
        end
      end
    end

    def filter(filter)
      fail ArgumentError, '"filter" expects a hash' unless filter.is_a? Hash

      @filter = filter
      reset
      self
    end

    def all
      @instance_limit = NetboxClientRuby.config.netbox.pagination.max_limit
      reset
      self
    end

    def limit(limit)
      self.class.check_limit limit unless limit.nil?

      @instance_limit = limit
      reset
      self
    end

    def offset(offset)
      raise ArgumentError, "The offset '#{offset}' is not numeric." unless offset.is_a? Numeric
      raise ArgumentError, "The offset '#{offset}' must not be negative." if offset.negative?

      @offset = offset
      reset
      self
    end

    def page(page)
      raise ArgumentError, "The offset '#{page}' is not numeric but has to be." unless page.is_a? Numeric
      raise ArgumentError, "The offset '#{page}' must be integer but isn't." unless page.integer?
      raise ArgumentError, "The offset '#{page}' must not be negative but is." if page.negative?

      limit = @instance_limit || self.class.limit
      offset(limit * page)
    end

    def [](index)
      return nil if length <= index

      as_entity raw_data_array[index]
    end

    def each
      raw_data_array.each { |raw_entity| yield as_entity(raw_entity) }
    end

    ##
    # The number of entities that have been fetched
    def length
      raw_data_array.length
    end

    ##
    # The total number of available entities for that query
    def total
      data[self.class.count_key]
    end

    def reload
      @data = get
      self
    end

    def raw_data!
      data
    end

    alias get! reload
    alias size length
    alias count total

    private

    def reset
      @data = nil
    end

    def raw_data_array
      data[self.class.data_key] || []
    end

    def data
      @data ||= get
    end

    def get
      response connection.get path_with_parameters
    end

    def path_with_parameters
      self.class.path + path_parameters
    end

    def path_parameters
      params = []

      params << @filter
      params << { limit: @instance_limit || self.class.limit }
      params << { offset: @offset } if @offset

      join_path_parameters(params)
    end

    def join_path_parameters(params)
      return '' if params.empty?

      '?' + params.compact.map do |param_obj|
        URI.encode_www_form param_obj
      end.join('&')
    end

    def as_entity(raw_entity)
      entity_creator_method = method self.class.entity_creator
      entity = entity_creator_method.call raw_entity
      entity.data = raw_entity
      entity
    end
  end
end
