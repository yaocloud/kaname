require 'yaml'
require 'fog'
require 'thor'

module Kaname
  class CLI < Thor
    DEFAULT_FILENAME = 'keystone.yml'

    class_option :verbose, type: :boolean, aliases: "-V", default: false

    desc 'apply', 'Commands about configuration apply'
    def apply
      if yaml
        yaml.each do |user,h|
          id = begin
                 user = users.find_by_name(user)
                 user.id
               rescue Fog::Identity::OpenStack::NotFound
                 response = Fog::Identity[:openstack].create_user(user, h["password"], h["email"])
                 response.data[:body]["user"]["id"]
               end

          h["tenants"].each do |tenant, role|
            tenant = tenants.find{|t| t.name == tenant}
            role = roles.find{|r| r.name == role}
            Fog::Identity[:openstack].create_user_role(tenant.id, id, role.id)
          end
        end
      else
        puts "Please put you keystone configuration file named keystone.yml to current directory."
      end
    end

    private

    def yaml
      @_yaml = if File.exists?(DEFAULT_FILENAME)
                 YAML.load_file(DEFAULT_FILENAME)
               else
                 nil
               end
    end

    def users
      @_users ||= Fog::Identity[:openstack].users
    end

    def tenants
      @_tenants ||= Fog::Identity[:openstack].tenants
    end

    def roles
      @_roles ||= Fog::Identity[:openstack].roles
    end

  end
end
