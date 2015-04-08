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

      def create_user_role(tenant, user_hash, email)
        tenant = Kaname::Resource.tenants.find{|t| t.name == tenant}
        role = Kaname::Resource.roles.find{|r| r.name == role}
        Fog::Identity[:openstack].create_user_role(tenant.id, user_hash["id"], role.id)
      end

      def delete_user(name)
        user = find_user(name)
        Fog::Identity[:openstack].delete_user(user["id"])
      end

      def delete_user_role(tenant, user_hash, role)
        tenant = Kaname::Resource.tenants.find{|t| t.name == tenant}
        role = Kaname::Resource.roles.find{|r| r.name == role}
        Fog::Identity[:openstack].delete_user_role(tenant.id, user_hash["id"], role.id)
      end

      def change_user_role(tenant, user_hash, before_role, after_role)
        delete_user_role(tenant, user_hash, before_role)
        create_user_role(tenant, user_hash, after_role)
      end
    end
  end
end
