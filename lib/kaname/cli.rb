require 'fog'
require 'thor'

module Kaname
  class CLI < Thor
    class_option :verbose, type: :boolean, aliases: "-V", default: false

    desc 'apply', 'Commands about configuration apply'
    def apply
      if Kaname::Resource.yaml
        Kaname::Resource.yaml.each do |user,h|
          id = begin
                 user = Kaname::Resource.users.find_by_name(user)
                 user.id
               rescue Fog::Identity::OpenStack::NotFound
                 response = Fog::Identity[:openstack].create_user(user, h["password"], h["email"])
                 response.data[:body]["user"]["id"]
               end

          h["tenants"].each do |tenant, role|
            tenant = Kaname::Resource.tenants.find{|t| t.name == tenant}
            role = Kaname::Resource.roles.find{|r| r.name == role}
            Fog::Identity[:openstack].create_user_role(tenant.id, id, role.id)
          end
        end
      else
        puts "Please put you keystone configuration file named keystone.yml to current directory."
      end
    end

    desc 'diff', 'Commands about show diffs from your openstack'
    def diff
      p Kaname::Resource.users_hash
    end
  end
end
