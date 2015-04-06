require 'yaml'
require 'fog'
require 'thor'
require 'hashdiff'
require 'diffy'

module Kaname
  class CLI < Thor
    class_option :verbose, type: :boolean, aliases: "-V", default: false

    desc 'apply', 'Commands about configuration apply'
    def apply
      if Kaname::Resource.yaml
        diffs = HashDiff.diff(Kaname::Resource.users_hash, Kaname::Resource.yaml)
        diffs.each do |diff|
          resource = diff[1].split('.')
          if resource.size == 1 # "user"
            if diff[0] == "+"
              response = Kaname::Resource.create_user(resource[1], diff[2]['email'])
              id = response.data[:body]["user"]["id"]
              diff[2]["tenants"].each do |tenant, role|
                tenant = Kaname::Resource.tenants.find{|t| t.name == tenant}
                role = Kaname::Resource.roles.find{|r| r.name == role}
                Fog::Identity[:openstack].create_user_role(tenant.id, id, role.id)
              end
            else
              id = Kaname::Resource.user(resource[0])
              Fog::Identity[:openstack].delete_user(id)
            end
          elsif resource.size == 3 # "user.tenants.foo"
            id = Kaname::Resource.user(resource[0])
            tenant = Kaname::Resource.tenants.find{|t| t.name == resource[2]}
            role = Kaname::Resource.roles.find{|r| r.name == diff[2]}
            case diff[0]
            when "+"
              Fog::Identity[:openstack].create_user_role(tenant.id, id, role.id)
            when "-"
              Fog::Identity[:openstack].delete_user_role(tenant.id, id, role.id)
            when "~"
              Fog::Identity[:openstack].delete_user_role(tenant.id, id, role.id)
              role = Kaname::Resource.roles.find{|r| r.name == diff[3]}
              Fog::Identity[:openstack].create_user_role(tenant.id, id, role.id)
            end
          else # "user.tenants"
            # XXX
          end
        end
      else
        puts "Please put you keystone configuration file named keystone.yml to current directory."
      end
    end

    desc 'diff', 'Commands about show diffs from your openstack'
    def diff
      puts Diffy::Diff.new(YAML.dump(Kaname::Resource.users_hash), YAML.dump(Kaname::Resource.yaml))
    end
  end
end
