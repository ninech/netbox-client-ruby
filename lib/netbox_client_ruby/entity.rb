require 'netbox_client_ruby/communication'
require 'netbox_client_ruby/error/local_error'

module NetboxClientRuby
  module Entity
    include NetboxClientRuby::Communication

    def self.included(other_klass)
      other_klass.extend ClassMethods
    end

    module ClassMethods
      ##
      # Expects ids in the following format:
      #   id 'an_id_field'
      #   id :an_id_field
      #   id 'an_id_field', 'another_id_field'
      #   id :an_id_field, :another_id_field
      #   id an_id_field: 'id_field_in_data'
      #   id an_id_field: :id_field_in_data
      #   id 'an_id_field' => :id_field_in_data
      #   id 'an_id_field' => 'id_field_in_data'
      #   id an_id_field: 'id_field_in_data', :another_id_field: 'id_field2_in_data'
      #
      def id(*fields)
        return @id_fields if @id_fields

        raise ArgumentError, "No 'id' was defined, but one is expected." if fields.empty?

        @id_fields = {}
        if fields.first.is_a?(Hash)
          fields.first.each { |key, value| @id_fields[key.to_s] = value.to_s }
        else
          fields.map(&:to_s).each do |field|
            field_as_string = field.to_s
            @id_fields[field_as_string] = field_as_string
          end
        end

        @id_fields.keys.each do |field|
          define_method(field) { instance_variable_get "@#{field}" }
        end

        @id_fields
      end

      def readonly_fields(*fields)
        return @readonly_fields if @readonly_fields

        @readonly_fields = fields.map(&:to_s)
      end

      def deletable(deletable = false)
        @deletable ||= deletable
      end

      def path(path = nil)
        @path ||= path

        return @path if @path

        raise ArgumentError, "No argument to 'path' was given."
      end

      def creation_path(creation_path = nil)
        @creation_path ||= creation_path

        return @creation_path if @creation_path

        raise ArgumentError, "No argument to 'creation_path' was given."
      end

      def object_fields(*fields)
        return @object_fields if @object_fields

        if fields.nil? || fields.empty?
          @object_fields = []
        else
          @object_fields = fields.map(&:to_s)
        end
      end

      # allowed values:
      # <code>
      # array_object_fields :field_a, :field_b, :field_c, 'fieldname_as_string'
      # # next is ame as previous
      # array_object_fields field_a: nil, field_b: nil, field_c: nil, 'fieldname_as_string': nil
      # # next defines the types of the objects
      # array_object_fields field_a: Klass, field_b: proc { |data| Klass.new data }, field_c: nil, 'fieldname_as_string'
      # </code>
      def array_object_fields(*fields_to_class_map)
        return @array_object_fields if @array_object_fields

        if fields_to_class_map.nil? || fields_to_class_map.empty?
          @array_object_fields = {}
        else
          fields_map = turn_all_items_into_a_single_hash(fields_to_class_map)
          @array_object_fields = fields_map
        end
      end

      def turn_all_items_into_a_single_hash(fields_to_class_map)
        fields_map = {}
        fields_to_class_map.each do |field_definition|
          if field_definition.is_a?(Hash)
            fields_to_class_map[0].each do |field, klass_or_proc|
              fields_map[field.to_s] = klass_or_proc
            end
          else
            fields_map[field_definition.to_s] = nil
          end
        end
        fields_map
      end
    end

    def initialize(given_ids = nil)
      return self if given_ids.nil?

      if id_fields.count == 1 && !given_ids.is_a?(Hash)
        instance_variable_set("@#{id_fields.keys.first}", given_ids)
        return self
      end

      check_given_ids(given_ids)

      given_ids.each { |id_field, id_value| instance_variable_set "@#{id_field}", id_value }

      self
    end

    def revert
      dirty_data.clear
      self
    end

    def reload
      @data = get
      revert
      self
    end

    def save
      return post unless ids_set?
      patch
    end

    def create(raw_data)
      raise LocalError, "Can't 'create', this object already exists" if ids_set?

      @dirty_data = raw_data
      post
    end

    def delete
      raise NetboxClientRuby::LocalError, "Can't delete unless deletable=true" unless deletable
      return self if @deleted

      @data = response connection.delete path
      @deleted = true
      revert
      self
    end

    def update(updated_fields)
      checked_updated_fields = {}
      updated_fields.each do |key, values|
        s_key = normalize_accessor key

        checked_updated_fields[s_key] = values unless readonly_fields.include? s_key
      end

      dirty_data.merge! checked_updated_fields
      patch
    end

    def raw_data!
      data
    end

    def method_missing(name_as_symbol, *args, &block)
      name = normalize_accessor name_as_symbol

      if name.end_with?('=')
        if readonly_fields.include?(name[0..-2])
          super
        else
          dirty_data[name[0..-2]] = args[0]
          return
        end
      end

      # allow access to the unmodified data using 'zone.always_string!' or 'zone._name!'
      if name.end_with?('!') && data.keys.include?(name[0..-2])
        return data[name[0..2]]
      end

      return objectify(name) if object_fields.include? name
      return arrayify(name, array_object_fields[name]) if array_object_fields.keys.include? name

      return dirty_data[name] if dirty_data.keys.include? name
      return data[name] if data.is_a?(Hash) && data.keys.include?(name)

      super
    end

    def respond_to_missing?(name_as_symbol, *args)
      name = normalize_accessor name_as_symbol

      return false if name.end_with?('=') && readonly_fields.include?(name[0..-2])
      return true if name.end_with?('!') && data.keys.include?(name[0..-2])

      return true if object_fields.include? name
      return true if array_object_fields.keys.include? name

      return true if dirty_data.keys.include? name
      return true if data.is_a?(Hash) && data.keys.include?(name)

      super
    end

    ##
    # :internal: Used to pre-populate an entity
    def data=(data)
      @data = data
    end

    alias get! reload
    alias remove delete

    private

    def post
      return self if dirty_data.empty?

      @data = response connection.post creation_path, dirty_data
      extract_ids
      revert
      self
    end

    def patch
      return self if dirty_data.empty?

      @data ||= {}
      response_data = response (connection.patch path, dirty_data)
      @data.merge! response_data
      revert
      self
    end

    def check_given_ids(given_ids)
      if !given_ids.is_a? Hash
        raise ArgumentError, "'#{self.class}.new' expects the argument to be a Hash when multiple ids are defined"
      elsif given_ids.empty?
        raise ArgumentError, "'#{self.class}.new' expects a the argument to not be empty."
      end

      missing_ids = id_fields.keys - given_ids.keys.map(&:to_s)

      unless missing_ids.empty?
        raise ArgumentError,
              "'#{self.class}.new' expects a value for all defined IDs. The following values are missing: '#{missing_ids.join(', ')}'"
      end
    end

    def normalize_accessor(symbol_or_string)
      always_string = symbol_or_string.to_s

      # allows access to remote data who's name conflicts with pre-defined methods
      # e.g. write 'zone._zone_id' instead of 'zone.zone_id' to access the remote value of 'zone_id'
      always_string.start_with?('_') ? always_string[1..-1] : always_string
    end

    def data
      @data ||= get
    end

    def get
      response connection.get path
    end

    def readonly_fields
      self.class.readonly_fields
    end

    def deletable
      self.class.deletable
    end

    def object_fields
      self.class.object_fields
    end

    def array_object_fields
      self.class.array_object_fields
    end

    def objectify(name)
      hash_to_object data[name]
    end

    def arrayify(name, klass_or_proc = nil)
      data[name].map do |data|
        if klass_or_proc.nil?
          hash_to_object data
        elsif klass_or_proc.is_a? Proc
          klass_or_proc.call data
        else
          klass_or_proc.new data
        end
      end
    end

    def creation_path
      @creation_path ||= replace_path_variables_in self.class.creation_path
    end

    def path
      @path ||= replace_path_variables_in self.class.path
    end

    def replace_path_variables_in(path)
      interpreted_path = path.clone
      path.scan(/:([a-zA-Z_][a-zA-Z0-9_]+[!?=]?)/) do |match, *|
        interpreted_path.gsub! ":#{match}", send(match).to_s
      end
      interpreted_path
    end

    def dirty_data
      @dirty_data ||= {}
    end

    def id_fields
      self.class.id
    end

    def extract_ids
      id_fields.each do |id_attr, id_field|
        unless data.has_key?(id_field)
          raise LocalError, "Can't find the id field '#{id_field}' in the received data."
        end

        instance_variable_set("@#{id_attr}", data[id_field])
      end
    end

    def ids_set?
      id_fields.map { |id_attr, _| instance_variable_get("@#{id_attr}") }.all?
    end
  end
end
