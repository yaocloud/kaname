require "kaname/version"
require 'yaml'

module Kaname
  class CLI
    DEFAULT_FILENAME = 'keystone.yml'
    class << self
      def load_yaml
        if File.exists?(DEFAULT_FILENAME)
          YAML.load_file(DEFAULT_FILENAME)
        else
          ""
        end
      end

      def run
        yml = load_yaml

        yml.each do |user,h|
          p user
          h.each do |tenant, role|
            p [tenant, role]
          end
        end
      end
    end
  end
end
