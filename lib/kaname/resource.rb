require 'yaml'

module Kaname
  class Resource
    DEFAULT_FILENAME = 'keystone.yml'
    class << self
      def yaml
        @_yaml = if File.exists?(DEFAULT_FILENAME)
                   YAML.load_file(DEFAULT_FILENAME)
                 else
                   nil
                 end
      end

      def users
        @_users ||= Fog::Identity[:openstack].users
      end

      def tenants
        @_tenants ||= Fog::Identity[:openstack].tenants
      end

      def roles
        @_roles ||= Fog::Identity[:openstack].roles
      end
    end
  end
end
