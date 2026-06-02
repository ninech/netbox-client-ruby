# frozen_string_literal: true

module NetboxClientRuby
  module Entities # rubocop:disable Metrics/ModuleLength
    include NetboxClientRuby::Communication
    include NetboxClientRuby::BulkOperations
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

      def check_limit(limit) # rubocop:disable Metrics/MethodLength
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

    def find_by(attributes) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      raise ArgumentError, '"attributes" expects a hash' unless attributes.is_a? Hash

      filter(attributes).find do |netbox_object|
        attributes.all? do |filter_key, filter_value|
          if filter_key.to_s.start_with?('cf_')
            custom_field = filter_key.to_s.sub('cf_', '')

            netbox_object.custom_fields[custom_field].to_s == filter_value.to_s
          elsif netbox_object.respond_to?(filter_key)
            netbox_object.public_send(filter_key).to_s == filter_value.to_s
          else
            false
          end
        end
      end
    end

    def filter(filter)
      raise ArgumentError, '"filter" expects a hash' unless filter.is_a? Hash

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

    ##
    # Generalized filterable + paginated read (Exigence B), available on every
    # collection. Configures filter/limit/offset and returns self so the caller
    # can read +#results+, +#next_url+, +#total+, or enumerate. Chainable.
    #
    #   nb.core.object_changes.get_list(
    #     { changed_object_type_id: [12, 34], time_after: ts, ordering: '-time' },
    #     limit: 100
    #   )
    def get_list(filters = {}, limit: nil, offset: nil)
      filter(filters) unless filters.nil? || filters.empty?
      self.limit(limit) unless limit.nil?
      self.offset(offset) unless offset.nil?
      self
    end

    ##
    # Raw +results+ array of the current page (no entity wrapping).
    def results
      raw_data_array
    end

    ##
    # Absolute URL of the next / previous page as returned by NetBox, or nil.
    def next_url
      data['next']
    end

    def previous_url
      data['previous']
    end

    ##
    # Follows +next+ from the current (filtered/limited) query until exhausted
    # and returns every entity across all pages. This is the incremental-polling
    # aggregation used against /core/object-changes/ (Exigence B).
    def all_pages
      collected = []
      page = data

      loop do
        (page[self.class.data_key] || []).each { |raw_entity| collected << as_entity(raw_entity) }
        next_page_url = page['next']
        break if next_page_url.nil? || next_page_url.empty?

        page = response connection.get(next_page_url)
      end

      collected
    end

    ##
    # Lazily yields each raw page Hash ({results:, next:, ...}), following next.
    def each_page
      return enum_for(:each_page) unless block_given?

      page = data
      loop do
        yield page
        next_page_url = page['next']
        break if next_page_url.nil? || next_page_url.empty?

        page = response connection.get(next_page_url)
      end
    end

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
