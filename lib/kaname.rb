require "kaname/version"

require 'kaname/setup'

require 'kaname/adapter'
require 'kaname/cli'
require 'kaname/generator'
require 'kaname/resource'

module Kaname
end

Kaname::Setup.execute
