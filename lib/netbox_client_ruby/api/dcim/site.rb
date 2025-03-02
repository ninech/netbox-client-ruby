# frozen_string_literal: true

module NetboxClientRuby
  module DCIM
    class Site
      include Entity

      STATUS_VALUES = {
        active: 1,
        planned: 2,
        retired: 4
      }.freeze

      id id: :id
      readonly_fields :count_prefixes, :count_vlans, :count_racks,
                      :count_devices, :count_circuits

      deletable true
      path 'dcim/sites/:id/'
      creation_path 'dcim/sites/'
      object_fields(
        tenant: proc { |raw_region| Tenancy::Tenant.new raw_region['id'] },
        region: proc { |raw_region| DCIM::Region.new raw_region['id'] },
        status: proc do |raw_status|
          STATUS_VALUES.key(raw_status['value']) || raw_status['value']
        end
      )
    end
  end
end
