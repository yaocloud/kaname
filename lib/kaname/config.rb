require 'yao'
require 'yaml'

module Kaname
  class Config
    @@username = String.new
    @@ca_cert = nil
    @@client_key = nil
    @@client_cert = nil

    def self.setup
      setup_yao
    end

    def self.username
      @@username
    end

    private

    def self.setup_yao
      Yao.configure do
        auth_url             ENV['OS_AUTH_URL']
        tenant_name          ENV['OS_TENANT_NAME']
        username             ENV['OS_USERNAME']
        password             ENV['OS_PASSWORD']
        ca_cert              ENV['OS_CACERT']
        client_cert          ENV['OS_CERT']
        client_key           ENV['OS_KEY']
        region_name          ENV['OS_REGION_NAME']
        identity_api_version ENV['OS_IDENTITY_API_VERSION']
        user_domain_name     ENV['OS_USER_DOMAIN_NAME']
        project_domain_name  ENV['OS_PROJECT_DOMAIN_NAME']
        debug                ENV['YAO_DEBUG']
      end
    end
  end
end
