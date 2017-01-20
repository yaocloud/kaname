require 'yao'
require 'yaml'

module Kaname
  class Config
    class << self
      def setup
        load_config
        setup_yao
      end

      def username
        @@username
      end

      def management_url
        @@management_url
      end

      def parallel
        @@parallel
      end

      private

      def load_config
        config = begin
                   YAML.load_file(File.join(Dir.home, '.kaname'))
                 rescue Errno::EOENT
                   raise '~/.kaname is missing'
                 end

        %w[auth_url tenant username password].each do |conf_item|
          raise "Configuration '#{conf_item}' is missing. Check your ~/.kaname" unless config[conf_item]
        end

        @@auth_url       = config['auth_url']
        @@tenant         = config['tenant']
        @@username       = config['username']
        @@password       = config['password']
        @@management_url = config['management_url']
        @@parallel       = config['parallel'].is_a?(Numeric) ? config['parallel'].to_i : 1
        true
      end

      def setup_yao
        Yao.configure do
          auth_url    @@auth_url
          tenant_name @@tenant
          username    @@username
          password    @@password
        end
      end
    end
  end
end
