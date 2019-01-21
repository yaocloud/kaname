require 'yao'
require 'yaml'

module Kaname
  class Config
    @@username = String.new

    def self.setup
      load_config unless envs_exist?
      setup_yao
    end

    def self.username
      @@username
    end

    private

    def self.envs_exist?
      %w[OS_AUTH_URL OS_TENANT_NAME OS_USERNAME OS_PASSWORD OS_CERT OS_KEY OS_REGION_NAME].any?{|k|ENV[k]}
    end

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
      @@client_cert    = config['client_cert']
      @@client_key     = config['client_key']
      @@region_name    = config['region_name']
      true
    end

    def self.setup_yao
      Yao.configure do
        auth_url    (ENV['OS_AUTH_URL']    || @@auth_url)
        tenant_name (ENV['OS_TENANT_NAME'] || @@tenant)
        username    (ENV['OS_USERNAME']    || @@username)
        password    (ENV['OS_PASSWORD']    || @@password)
        client_cert (ENV['OS_CERT']        || @@client_cert)
        client_key  (ENV['OS_KEY']         || @@client_key)
        region_name (ENV['OS_REGION_NAME'] || @@region_name)
      end
    end
  end
end
