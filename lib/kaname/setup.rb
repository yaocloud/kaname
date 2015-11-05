require 'yao'
require 'yaml'

module Kaname
  class Setup
    def self.execute
      config_file = File.join(Dir.home, '.kaname')

      raise '~/.kaname is missing' unless File.exists?(config_file)

      config = YAML.load_file(config_file)

      Yao.configure do
        auth_url    config['auth_url']
        tenant_name config['tenant']
        username    config['username']
        password    config['password']
      end
    end
  end
end
