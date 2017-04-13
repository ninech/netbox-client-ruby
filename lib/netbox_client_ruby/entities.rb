require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/error/local_error'
require 'pry'

module NetboxClientRuby
  module Entities
    include NetboxClientRuby::Communication

    def self.included(other_klass)
      other_klass.extend ClassMethods
    end

    attr_accessor :filter

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

        if @limit
          @limit
        else
          raise ArgumentError,
                '"limit" has not been defined or and no default_limit was set.'
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

    def [](index)
      return nil if length <= index

      list = data[self.class.data_key] || []
      as_entity list[index]
    end

    ##
    # The number of entities that have been fetched
    def length
      data[self.class.data_key].length
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

    def data
      @data ||= get
    end

    def get
      response connection.get path
    end

    def path_parameters
      return '' unless @filter
      '?' + URI.encode_www_form(@filter)
    end

    def path
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
