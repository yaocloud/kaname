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
        user = Yao::User.find_by_name(name).first
        {"id" => user.id, "name" => user.name}
      end

      def list_tenants
        @_tenants ||= if keystone_v2?
                        Yao::Tenant.list
                      else
                        Yao::Project.list
                      end
      end

      def list_roles
        @_roles ||= Yao::Role.list
      end

      def list_role_assignments
        unless @_role_assignments
          @_role_assignments ||= Yao::RoleAssignment.list
          Yao::Auth.try_new
        end
        @_role_assignments
      end

      def users_hash
        @_user_hash ||= list_users.each_with_object(Hash.new { |h,k| h[k] = {} }) do |u,uh|
          next if ignored_users.include?(u.name)
          uh[u.name]["email"] = u.email
          uh[u.name]["tenants"] = tenant_role_hash(u.id)
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

      def keystone_v2?
        Yao.default_client.pool["identity"].url_prefix.to_s.match(/v2\.0/)
      end

      def tenant_role_hash(user_id)
        list_role_assignments.each_with_object(Hash.new) do |t,th|
          if t.user.id == user_id
            th[list_tenants.find {|ts| ts.id == t.scope["project"]["id"]}["name"]] = list_roles.find {|r| r.id == t.role.id }['name']
          end
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
          octavia
        ]
      end
    end
  end
end
