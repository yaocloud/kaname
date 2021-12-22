require 'net/http'
require 'json'

module Kaname
  module Adapter
    class ReadAndWrite < ReadOnly
      def create_user(name, email)
        password = Kaname::Generator.password
        puts "#{name},#{password}"

        user = Yao::User.create(name: name, email: email, password: password)
        {"id" => user.id,  "name" => user.name}
      end

      def create_user_role(tenant_name, user_hash, role_name)
        Yao::Role.grant(role_name, to: user_hash["name"], on: tenant_name)
      end

      def update_user_password(old_password, new_password)
        if old_password && new_password
          me    = Yao::User.get_by_name(Kaname::Config.username)
          client= Yao.default_client.pool['identity']

          params = JSON.generate({'user' => {'password' => new_password, 'original_password' => old_password}})
          res = client.patch("./OS-KSCRUD/users/#{me.id}") do |req|
            req.body = params
            req.headers['Content-Type'] = 'application/json'
          end

          if res.status == 200
            puts "Your password is updated. Please update your $OS_PASSWORD configuration too."
          else
            raise "password updating is failed"
          end
        end
      end

      def delete_user(name)
        Yao::User.destroy find_user(name)["id"]
      end

      def delete_user_role(tenant_name, user_hash, role_name)
        Yao::Role.revoke(role_name, from: user_hash["name"], on: tenant_name)
      end

      def change_user_role(tenant_name, user_hash, before_role_name, after_role_name)
        delete_user_role(tenant_name, user_hash, before_role_name)
        create_user_role(tenant_name, user_hash, after_role_name)
      end
    end
  end
end
