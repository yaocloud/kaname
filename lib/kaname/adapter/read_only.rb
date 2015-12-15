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
        @_user_hash ||= list_users.each_with_object(Hash.new { |h,k| h[k] = {} }) do |u,uh|
          next if ignored_users.include?(u.name)
          uh[u.name]["email"] = u.email
          uh[u.name]["tenants"] = tenant_role_hash(u.name, list_tenants)
        end
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

      def tenant_role_hash(user_name, tenants)
        tenants.each_with_object(Hash.new) do |t,th|
          r = Yao::Role.list_for_user(user_name, on: t.name)
          th[t.name] = r.first.name if r.size > 0
        end
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
