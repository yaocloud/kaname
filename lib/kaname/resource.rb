require 'yaml'

module Kaname
  class Resource
    class << self
      def use_adapter(adapter_class)
        @adapter = adapter_class.new
      end

      def yaml(filename = 'keystone.yml')
        @_yaml = if File.exists?(filename)
                   YAML.load_file(filename)
                 else
                   nil
                 end
      end

      def users
        @_users ||= @adapter.list_users
      end

      def tenants
        @_tenants ||= @adapter.list_tenants
      end

      def roles
        @_roles ||= @adapter.list_roles
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
            r = @adapter.list_roles_for_user(u.name, t.name)
            @h[u.name]["tenants"][t.name] = r.first.name if r.size > 0
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
