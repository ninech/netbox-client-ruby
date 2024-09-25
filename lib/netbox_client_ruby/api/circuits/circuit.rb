# frozen_string_literal: true

require 'netbox_client_ruby/entity'
require 'netbox_client_ruby/api/circuits/circuit_type'
require 'netbox_client_ruby/api/circuits/provider'
require 'netbox_client_ruby/api/tenancy/tenant'

module NetboxClientRuby
  module Circuits
    class Circuit
      include Entity

      STATUS_VALUES = {
        deprovisioning: 0,
        active: 1,
        planned: 2,
        provisioning: 3,
        offline: 4,
        decommissioned: 5,
      }.freeze

      id id: :id
      deletable true
      path 'circuits/circuits/:id.json'
      creation_path 'circuits/circuits/'

      object_fields(
        provider: proc do |raw_data|
          Provider.new raw_data['id']
        end,
        status: proc do |raw_status|
          STATUS_VALUES.key(raw_status['value']) || raw_status['value']
        end,
        type: proc { |raw_data| CircuitType.new raw_data['id'] },
        tenant: proc { |raw_data| Tenancy::Tenant.new raw_data['id'] }
      )
    end
  end
end
