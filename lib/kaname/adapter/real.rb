module Kaname
  module Adapter
    class Real
      def find_user(name)
        user = Kaname::Resource.users.find_by_name(name)
        {"id" => user.id, "name" => user.name}
      end

      def create_user(name, email)
        password = Kaname::Generator.password
        puts "#{user},#{password}"
        response = Fog::Identity[:openstack].create_user(resource[0], password, diff[2]['email'])
        response.data[:body]["user"]
      end

      def create_user_role(tenant_name, user_hash, role_name)
        tenant = Kaname::Resource.tenants.find{|t| t.name == tenant_name}
        role = Kaname::Resource.roles.find{|r| r.name == role_name}
        Fog::Identity[:openstack].create_user_role(tenant.id, user_hash["id"], role.id)
      end

      def delete_user(name)
        user = find_user(name)
        Fog::Identity[:openstack].delete_user(user["id"])
      end

      def delete_user_role(tenant_name, user_hash, role_name)
        tenant = Kaname::Resource.tenants.find{|t| t.name == tenant_name}
        role = Kaname::Resource.roles.find{|r| r.name == role_name}
        Fog::Identity[:openstack].delete_user_role(tenant.id, user_hash["id"], role.id)
      end

      def change_user_role(tenant_name, user_hash, before_role_name, after_role_name)
        delete_user_role(tenant_name, user_hash, before_role_name)
        create_user_role(tenant_name, user_hash, after_role_name)
      end
    end
  end
end
