require 'securerandom'

module Kaname
  class Generator
    class << self
      def password_length
        @password_length ||= 14
      end

      def password_length=(length)
        @password_length = length
      end

      def password
        SecureRandom.base64(@password_length)
      end
    end
  end
end
