require 'net/http'
require 'json'

module Kaname
  module Adapter
    class Real
      def find_user(name)
        Yao::User.find_by_name(name)
      end

      def create_user(name, email)
        password = Kaname::Generator.password
        puts "#{name},#{password}"

        Yao::User.create(name: name, email: email, password: password)
      end

      def create_user_role(tenant_name, user_hash, role_name)
        Yao::Role.grant(role_name, to: user_hash["name"], on: tenant_name)
      end

      def update_user_password(credentials, old_password, new_password)
        if old_password && new_password
          # TODO: need to confirm port number of endpoint
          endpoint = "http://#{URI(credentials[:openstack_management_url]).hostname}:5000/v2.0"
          url = URI.parse("#{endpoint}/OS-KSCRUD/users/#{credentials[:openstack_current_user_id]}")
          req = Net::HTTP::Patch.new(url.path)
          req["Content-type"] = "application/json"
          req["X-Auth-Token"] = credentials[:openstack_auth_token]
          req.body = JSON.generate({'user' => {'password' => new_password, 'original_password' => old_password}})
          res = Net::HTTP.start(url.host, url.port) {|http|
            http.request(req)
          }
          if res.code == "200"
            puts "Your password is updated. Please update your ~/.fog configuration too."
          else
            raise "password updating is failed"
          end
        end
      end

      def delete_user(name)
        Yao::User.destroy find_user(name).id
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
