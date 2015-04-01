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
          begin
            p users.find_by_name(user)
          rescue Fog::Identity::OpenStack::NotFound
            # create new users
          end

          h.each do |tenant, role|
            p tenants.find{|t| t.name == tenant}
            p roles.find{|r| r.name == role}
          end
        end
      end
    end
  end
end
