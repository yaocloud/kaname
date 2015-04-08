require 'securerandom'

module Kaname
  class Generator
    class << self
      def password
        SecureRandom.base64(6)
      end
    end
  end
end
