module Kaname
  module Adapter
    class Mock
      def find_user(name)
        {"name" => name}
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
    end
  end
end
