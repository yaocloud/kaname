require 'net/http'

module Kaname
  module Adapter
    class Real
      def find_user(name)
        user = Kaname::Resource.users.find_by_name(name)
        {"id" => user.id, "name" => user.name}
      end

      def create_user(name, email)
        password = Kaname::Generator.password
        puts "#{name},#{password}"
        response = Fog::Identity[:openstack].create_user(name, password, email)
        response.data[:body]["user"]
      end

      def create_user_role(tenant_name, user_hash, role_name)
        tenant = Kaname::Resource.tenants.find{|t| t.name == tenant_name}
        role = Kaname::Resource.roles.find{|r| r.name == role_name}
        Fog::Identity[:openstack].create_user_role(tenant.id, user_hash["id"], role.id)
      end

      def update_user_password
        credentials = Fog::Identity[:openstack].credentials
        puts "current_user: #{credentials[:current_user]["username"]}"

        print "type your current password: "
        old_password = STDIN.noecho(&:gets).strip
        puts
        print "type your new password: "
        new_password = STDIN.noecho(&:gets).strip
        puts

        if old_password && new_password
          url = URI.parse("http://api-vip.u01.pbcloud.local:5000/v2.0/OS-KSCRUD/users/#{credentials[:openstack_current_user_id]}")
          puts "http://api-vip.u01.pbcloud.local:5000/v2.0/OS-KSCRUD/users/#{credentials[:openstack_current_user_id]}"
          req = Net::HTTP::Patch.new(url.path)
          req["Content-type"] = "application/json"
          req["X-Auth-Token"] = credentials[:openstack_auth_token]
          req.body = JSON.generate({'user' => {'password': new_password, 'original_password': old_password}})
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
