require 'netbox_client_ruby/api/dcim/regions'
require 'netbox_client_ruby/api/dcim/region'
require 'netbox_client_ruby/api/dcim/sites'
require 'netbox_client_ruby/api/dcim/site'
require 'netbox_client_ruby/communication'

module NetboxClientRuby
  class DCIM
    {
      sites: Sites,
      regions: Regions
    }.each_pair do |method_name, class_name|
      define_method(method_name) do
        class_name.new
      end
    end

    {
      site: Site,
      region: Region
    }.each_pair do |method_name, class_name|
      define_method(method_name) do |id|
        class_name.new id
      end
    end
  end
end
