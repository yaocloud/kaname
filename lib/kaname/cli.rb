require 'yaml'
require 'fog'
require 'thor'
require 'diffy'

module Kaname
  class CLI < Thor
    class_option :verbose, type: :boolean, aliases: "-V", default: false

    desc 'apply', 'Commands about configuration apply'
    def apply
      if Kaname::Resource.yaml
        Kaname::Resource.yaml.each do |user,h|
          id = Kaname::Resource.user(user)
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
      puts Diffy::Diff.new(YAML.dump(Kaname::Resource.users_hash), YAML.dump(Kaname::Resource.yaml))
    end
  end
end
