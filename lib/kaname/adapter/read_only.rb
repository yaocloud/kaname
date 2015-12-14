module Kaname
  module Adapter
    class ReadOnly
      def initialize
        Kaname::Config.setup
      end

      def list_users
        @_users ||= Yao::User.list
      end

      def find_user(name)
        user = Yao::User.find_by_name(name)
        {"id" => user.id, "name" => user.name}
      end

      def list_tenants
        @_tenants ||= Yao::Tenant.list
      end

      def list_roles
        @_roles ||= Yao::Role.list
      end

      def users_hash
        return @h if @h

        @h = {}
        list_users.each do |u|
          next if ignored_users.include?(u.name)
          @h[u.name] = {}
          @h[u.name]["email"] = u.email
          @h[u.name]["tenants"] = {}
          list_tenants.each do |t|
            r = Yao::Role.list_for_user(u.name, on: t.name)
            if r.size > 0
              @h[u.name]["tenants"][t.name] = r.first.name
            end
          end
        end
        @h
      end

      def create_user(name, email)
        puts "Create User: #{name} #{email}"
        {"name" => name}
      end

      def create_user_role(tenant, user_hash, role)
        puts "Create User Role: #{tenant} #{user_hash["name"]} #{role}"
      end

      def delete_user(name)
        puts "Delete User: #{name}"
      end

      def delete_user_role(tenant, user_hash, role)
        puts "Delete User Role: #{tenant} #{user_hash["name"]} #{role}"
      end

      def change_user_role(tenant, user_hash, before_role, after_role)
        delete_user_role(tenant, user_hash, before_role)
        create_user_role(tenant, user_hash, after_role)
      end

      private

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
