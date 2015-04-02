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

      def users_hash
        return @h if @h

        @h = {}
        users.each do |u|
          next if ignored_users.include?(u.name)
          @h[u.name] = {}
          @h[u.name]["email"] = u.email
        end
        @h
      end

      # default service users
      def ignored_users
        %w[
          neutron
          glance
          cinder
          admin
          nova_ec2
          nova
        ]
      end
    end
  end
end
