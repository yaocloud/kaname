require 'yaml'
require 'fog'
require 'thor'
require 'hashdiff'
require 'diffy'

module Kaname
  class CLI < Thor
    class_option :verbose, type: :boolean, aliases: "-V", default: false

    option :dryrun, type: :boolean, aliases: "-d", default: true
    desc 'apply', 'Commands about configuration apply'
    def apply
      if Kaname::Resource.yaml
        diffs = HashDiff.diff(Kaname::Resource.users_hash, Kaname::Resource.yaml)
        diffs.each do |diff|
          resource = diff[1].split('.')
          if resource.size == 1 # "user"
            if diff[0] == "+"
              if options[:dryrun]
                puts "Create User: #{resource[0]}"
              else
                password = Kaname::Generator.password
                puts "#{user},#{password}"
                response = Fog::Identity[:openstack].create_user(resource[0], password, diff[2]['email'])
                user = response.data[:body]["user"]
              end
              diff[2]["tenants"].each do |tenant, role|
                tenant = Kaname::Resource.tenants.find{|t| t.name == tenant}
                role = Kaname::Resource.roles.find{|r| r.name == role}
                if options[:dryrun]
                  puts "Create User Role: #{tenant.name} #{resource[0]} #{role.name}"
                else
                  Fog::Identity[:openstack].create_user_role(tenant.id, user["id"], role.id)
                end
              end
            else
              user = Kaname::Resource.user(resource[0])
              if options[:dryrun]
                puts "Delete User: #{user.name}"
              else
                Fog::Identity[:openstack].delete_user(user.id)
              end
            end
          elsif resource.size == 3 # "user.tenants.foo"
            user = Kaname::Resource.user(resource[0])
            tenant = Kaname::Resource.tenants.find{|t| t.name == resource[2]}
            role = Kaname::Resource.roles.find{|r| r.name == diff[2]}
            case diff[0]
            when "+"
              if options[:dryrun]
                puts "Create User Role: #{tenant.name} #{user.name} #{role.name}"
              else
                Fog::Identity[:openstack].create_user_role(tenant.id, user.id, role.id)
              end
            when "-"
              if options[:dryrun]
                puts "Delete User Role: #{tenant.name} #{user.name} #{role.name}"
              else
                Fog::Identity[:openstack].delete_user_role(tenant.id, user.id, role.id)
              end
            when "~"
              if options[:dryrun]
                puts "Delete User Role: #{tenant.name} #{user.name} #{role.name}"
                role = Kaname::Resource.roles.find{|r| r.name == diff[3]}
                puts "Create User Role: #{tenant.name} #{user.name} #{role.name}"
              else
                Fog::Identity[:openstack].delete_user_role(tenant.id, user.id, role.id)
                role = Kaname::Resource.roles.find{|r| r.name == diff[3]}
                Fog::Identity[:openstack].create_user_role(tenant.id, user.id, role.id)
              end
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
