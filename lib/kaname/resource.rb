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
        @_users ||= Yao::User.list
      end

      def tenants
        @_tenants ||= Yao::Tenant.list
      end

      def roles
        @_roles ||= Yao::Role.list
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
            r = Yao::Role.list_for_user(u.name, on: t.name)
            if r.size > 0
              @h[u.name]["tenants"][t.name] = r.first.name
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
          ceilometer
        ]
      end
    end
  end
end
