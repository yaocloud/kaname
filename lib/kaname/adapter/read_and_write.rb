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
        unless Kaname::Config.management_url
          raise 'management_url is missing. Check the configuration file.'
        end

        if old_password && new_password
          token = Yao::Auth.try_new.token
          me    = Yao::User.get_by_name(Kaname::Config.username)
          endpoint = Kaname::Config.management_url

          url = URI.parse("#{endpoint}/OS-KSCRUD/users/#{me.id}")

          req = Net::HTTP::Patch.new(url.path)
          req["Content-type"] = "application/json"
          req["X-Auth-Token"] = token
          req.body = JSON.generate({'user' => {'password' => new_password, 'original_password' => old_password}})

          res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }

          if res.code == "200"
            puts "Your password is updated. Please update your ~/.kaname configuration too."
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
