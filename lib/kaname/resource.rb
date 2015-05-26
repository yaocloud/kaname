require 'yaml'

module Kaname
  class Resource
    class << self
      def yaml(filename = 'keystone.yml')
        @_yaml = if File.exists?(filename)
                   YAML.load_file(filename)
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
          @h[u.name]["tenants"] = {}
          tenants.each do |t|
            r = u.roles(t.id)
            if r.size > 0
              @h[u.name]["tenants"][t.name] = r.first["name"]
            end
          end
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
          heat
        ]
      end
    end
  end
end
