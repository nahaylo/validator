class BaseTestIpAddress
  include ActiveModel::Validations

  attr_accessor :ip
end

class TestIpAddress < BaseTestIpAddress
  validates :ip, :ip_address => true
end

class TestIpAddressWithPrefix < BaseTestIpAddress
  validates :ip, :ip_address => { :allow_prefix => true }
end

class TestIpAddress4 < BaseTestIpAddress
  validates :ip, :ip_address => { :only => :ipv4 }
end

class TestIpAddress6 < BaseTestIpAddress
  validates :ip, :ip_address => { :only => :ipv6 }
end

class TestIpAddressWithMessage < BaseTestIpAddress
  validates :ip, :ip_address => { :message => "invalid" }
end