require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/dcim/manufacturer'

module NetboxClientRuby
  class InterfaceOrdering
    attr_reader :value, :label

    def initialize(raw_data)
      @value = raw_data['value']
      @label = raw_data['label']
    end
  end

  class DeviceType
    include NetboxClientRuby::Entity

    id id: :id
    deletable true
    path 'dcim/device-types/:id.json'
    creation_path 'dcim/device-types/'
    object_fields(
      manufacturer: proc { |raw_data| NetboxClientRuby::Manufacturer.new raw_data['id'] },
      interface_ordering: NetboxClientRuby::InterfaceOrdering
    )

  end
end
