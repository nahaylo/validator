module Validator
  require "ipaddress"

  class IpAddress
    def initialize(value)
      @value = value
    end

    # check if ip has prefix
    def has_prefix?
      @value =~ /\//
    end

    # IPv4 addresses which are only 32 bits long
    def valid_ipv4_prefix?
      prefix = get_prefix
      (prefix >= 1 and prefix <= 32)
    end

    # IPv6 addresses are 128 bits long
    def valid_ipv6_prefix?
      prefix = get_prefix
      (prefix >= 1 and prefix <= 128)
    end

    # IPv4 determination by . (dot)
    def is_ipv4?
      @value =~ /\./
    end

    def valid_prefix?
      if is_ipv4?
        valid_ipv4_prefix?
      else
        valid_ipv6_prefix?
      end
    end

    def valid_ipv4?
      IPAddress(@value).ipv4? rescue false
    end

    def valid_ipv6?
      IPAddress(@value).ipv6? rescue false
    end

    def valid?
      valid_ipv4? || valid_ipv6?
    end

  private
     def get_prefix
       @value.split("/").last.to_i
     end
  end
end
