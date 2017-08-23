require 'yao'
require 'yaml'

module Kaname
  class Config
    %w[username management_url].each do |m|
      self.class_variable_set(:"@@#{m}", String.new)
    end

    def self.setup
      load_config
      setup_yao
    end

    def self.username
      @@username
    end

    def self.management_url
      @@management_url
    end

    private

    def self.load_config
      config_file = File.join(Dir.home, '.kaname')
      raise '~/.kaname is missing' unless File.exists?(config_file)

      config = YAML.load_file(config_file)

      %w[auth_url tenant username password].each do |conf_item|
        raise "Configuration '#{conf_item}' is missing. Check your ~/.kaname" unless config[conf_item]
      end

      @@auth_url       = config['auth_url']
      @@tenant         = config['tenant']
      @@username       = config['username']
      @@password       = config['password']
      @@management_url = config['management_url']
      @@client_cert    = config['client_cert']
      @@client_key     = config['client_key']
      @@region_name    = config['region_name']
      true
    end

    def self.setup_yao
      Yao.configure do
        auth_url    @@auth_url
        tenant_name @@tenant
        username    @@username
        password    @@password
        client_cert @@client_cert
        client_key  @@client_key
        region_name @@region_name
      end
    end
  end
end
