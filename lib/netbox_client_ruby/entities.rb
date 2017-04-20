require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/error/local_error'
require 'pry'

module NetboxClientRuby
  module Entities
    include NetboxClientRuby::Communication

    MAX_SIGNED_64BIT_INT = 9_223_372_036_854_775_807

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

        @limit = limit || NetboxClientRuby.config.pagination.default_limit

        check_limit

        @limit
      end

      def check_limit
        if @limit.nil?
          raise ArgumentError,
                "'limit' has not been defined or and no 'default_limit' was set."
        elsif !@limit.is_a?(Numeric)
          raise ArgumentError,
                "The limit '#{@limit}' is not numeric but it has to be."
        elsif !@limit.integer?
          raise ArgumentError,
                "The limit '#{@limit}' is not decimal but it has to be."
        elsif @limit < 0
          raise ArgumentError,
                "The limit '#{@limit}' is below zero, but it should be zero or bigger."
        elsif @limit > MAX_SIGNED_64BIT_INT
          raise ArgumentError,
                "The limit '#{@limit}' is bigger than the allowed limit value."
        end
      end

      def entity_creator(creator = nil)
        return @entity_creator if @entity_creator

        if creator
          @entity_creator = creator
        else
          raise ArgumentError, '"entity_creator" has not been defined.'
        end
      end

      def path(path = nil)
        return @path if @path

        raise ArgumentError, '"path" has not been defined.' unless path

        @path = path
      end
    end

    def filter(filter)
      raise ArgumentError, '"filter" expects a hash' unless filter.is_a? Hash

      @filter = filter
      reset
      self
    end

    def [](index)
      return nil if length <= index

      as_entity raw_data_array[index]
    end

    def as_array
      raw_data_array.map { |raw_entity| as_entity raw_entity}
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

    def path_parameters
      return '' unless @filter
      '?' + URI.encode_www_form(@filter)
    end

    def path_with_parameters
      self.class.path + path_parameters
    end

    def as_entity(raw_entity)
      entity_creator_method = method self.class.entity_creator
      entity = entity_creator_method.call raw_entity
      entity.data = raw_entity
      entity
    end
  end
end
