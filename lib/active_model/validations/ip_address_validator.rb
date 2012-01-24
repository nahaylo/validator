module ActiveModel
  module Validations
    class IpAddressValidator < ActiveModel::EachValidator
      def validate_each(record, attr_name, value)
        # do not validate if value is empty
        return if value.nil?

        @validator = ::Validator::IpAddress.new(value)

        # validate IPv4 or IPv6 if they are only allowed
        if options[:only] and [:ipv4, :ipv6].include?(options[:only])
          if options[:only] == :ipv4 and !@validator.valid_ipv4?
            record.errors.add(attr_name, :"ip_address.invalid.ipv4", options)
            return
          end
          if options[:only] == :ipv6 and !@validator.valid_ipv6?
            record.errors.add(attr_name, :"ip_address.invalid.ipv6", options)
            return
          end
        end

        if options[:allow_prefix] == true and @validator.has_prefix?
          unless @validator.valid_prefix?
            record.errors.add(attr_name, :"ip_address.prefix_invalid.#{@validator.is_ipv4? ? "ipv4" : "ipv6"}", options)
            return 
          end
        elsif @validator.has_prefix?
          record.errors.add(attr_name, :'ip_address.prefix_disallowed', options)
          return
        end

        unless @validator.valid?
          record.errors.add(attr_name, :'ip_address.invalid.general', options)
        end
      end
    end

    module HelperMethods
      #   class Ip < ActiveRecord::Base
      #     validates_ip_address_of :ip
      #   end
      #
      def validates_ip_address_of(*attr_names)
        validates_with IpAddressValidator, _merge_attributes(attr_names)
      end
    end
  end
end
