require 'netbox_client_ruby/entities'
require 'netbox_client_ruby/api/dcim/rack_reservation'

module NetboxClientRuby
  module DCIM
    class RackReservations
      include Entities

      path 'dcim/rack-reservations.json'
      data_key 'results'
      count_key 'count'
      entity_creator :entity_creator

      private

      def entity_creator(raw_entity)
        RackReservation.new raw_entity['id']
      end
    end
  end
end
