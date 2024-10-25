# frozen_string_literal: true

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
          define_method(field) { instance_variable_get :"@#{field}" }
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

      # allowed values:
      # <code>
      # object_fields :field_a, :field_b, :field_c, 'fieldname_as_string'
      # # next is ame as previous
      # object_fields field_a: nil, field_b: nil, field_c: nil, 'fieldname_as_string': nil
      # # next defines the types of the objects
      # object_fields field_a: Klass, field_b: proc { |data| Klass.new data }, field_c: nil, 'fieldname_as_string'
      # </code>
      def object_fields(*fields_to_class_map)
        return @object_fields if @object_fields

        if fields_to_class_map.nil? || fields_to_class_map.empty?
          @object_fields = {}
        else
          fields_map = sanitize_mapping(fields_to_class_map)
          @object_fields = fields_map
        end
      end

      def sanitize_mapping(fields_to_class_map)
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

    def initialize(given_values = nil)
      return self if given_values.nil?

      if id_fields.count == 1 && !given_values.is_a?(Hash)
        instance_variable_set(:"@#{id_fields.keys.first}", given_values)
        return self
      end

      given_values.each do |field, value|
        if id_fields.key? field.to_s
          instance_variable_set :"@#{field}", value
        else
          # via method_missing, because it checks for readonly fields, etc.
          method_missing("#{field}=", value)
        end
      end

      self
    end

    def revert
      dirty_data.clear
      self
    end

    def reload
      raise LocalError, "Can't 'reload', this object has never been saved" unless ids_set?

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

    def update(new_values)
      new_values.each do |attribute, values|
        s_attribute = attribute.to_s
        next if readonly_fields.include? s_attribute

        sym_attr_writer = :"#{attribute}="
        if methods.include?(sym_attr_writer)
          public_send(sym_attr_writer, values)
        else
          dirty_data[s_attribute] = values
        end
      end

      patch
    end

    def url
      "#{connection.url_prefix}#{path}"
    end

    def raw_data!
      data
    end

    def [](name)
      s_name = name.to_s
      dirty_data[s_name] || data[s_name]
    end

    def []=(name, value)
      dirty_data[name.to_s] = value
    end

    def method_missing(name_as_symbol, *args, &block)
      name = name_as_symbol.to_s

      if name.end_with?('=')
        is_readonly_field = readonly_fields.include?(name[0..-2])
        is_instance_variable = instance_variables.include?(:"@#{name[0..-2]}")
        not_this_classes_business = is_readonly_field || is_instance_variable

        return super if not_this_classes_business

        dirty_data[name[0..-2]] = args[0]
        return args[0]
      end

      return dirty_data[name] if dirty_data.key? name
      return objectify(data[name], object_fields[name]) if object_fields.key? name
      return data[name] if data.is_a?(Hash) && data.key?(name)

      super
    end

    def respond_to_missing?(name_as_symbol, *args)
      name = name_as_symbol.to_s

      return false if name.end_with?('=') && readonly_fields.include?(name[0..-2])
      return false if name.end_with?('=') && instance_variables.include?(name[0..-2])

      return true if dirty_data.key? name
      return true if object_fields.key? name
      return true if data.is_a?(Hash) && data.key?(name)

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
      response_data = response connection.patch(path, dirty_data)
      @data.merge! response_data
      revert
      self
    end

    def data
      @data ||= get
    end

    def get
      response connection.get path unless @deleted or !ids_set?
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

    def data_to_obj(raw_data, klass_or_proc = nil)
      if klass_or_proc.nil?
        hash_to_object raw_data
      elsif klass_or_proc.is_a? Proc
        klass_or_proc.call raw_data
      else
        klass_or_proc.new raw_data
      end
    end

    def objectify(raw_data, klass_or_proc = nil)
      return nil if raw_data.nil?

      return data_to_obj(raw_data, klass_or_proc) unless raw_data.is_a? Array

      raw_data.map do |raw_data_entry|
        data_to_obj(raw_data_entry, klass_or_proc)
      end
    end

    def creation_path
      @creation_path ||= replace_path_variables_in self.class.creation_path
    end

    def path
      @path ||= replace_path_variables_in self.class.path
    end

    def replace_path_variables_in(path)
      interpreted_path = path.dup
      path.scan(/:([a-zA-Z_][a-zA-Z0-9_]+[!?=]?)/) do |match, *|
        path_variable_value = send(match)
        return interpreted_path.gsub! ":#{match}", path_variable_value.to_s unless path_variable_value.nil?
        raise LocalError, "Received 'nil' while replacing ':#{match}' in '#{path}' with a value."
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
        unless data.key?(id_field)
          raise LocalError, "Can't find the id field '#{id_field}' in the received data."
        end

        instance_variable_set(:"@#{id_attr}", data[id_field])
      end
    end

    def ids_set?
      id_fields.map { |id_attr, _| instance_variable_get(:"@#{id_attr}") }.all?
    end
  end
end
