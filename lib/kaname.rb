require "kaname/version"
require 'yaml'
require 'fog'

module Kaname
  class CLI
    DEFAULT_FILENAME = 'keystone.yml'
    class << self
      def yaml
        @_yaml = if File.exists?(DEFAULT_FILENAME)
                   YAML.load_file(DEFAULT_FILENAME)
                 else
                   ""
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

      def run
        yaml.each do |user,h|
          id = begin
                 user = users.find_by_name(user)
                 user.id
               rescue Fog::Identity::OpenStack::NotFound
                 response = Fog::Identity[:openstack].create_user(user, h["password"], h["email"])
                 response.data[:body]["user"]["id"]
               end

          h["tenants"].each do |tenant, role|
            tenant = tenants.find{|t| t.name == tenant}
            role = roles.find{|r| r.name == role}
            Fog::Identity[:openstack].create_user_role(tenant.id, id, role.id)
          end
        end
      end
    end
  end
end
