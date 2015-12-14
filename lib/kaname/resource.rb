require 'yaml'

module Kaname
  class Resource
    class << self
      def yaml(filename = 'keystone.yml')
        @_yaml = if File.exists?(filename)
                   YAML.load_file(filename)
                 else
                   nil
                 end
      end
    end
  end
end
