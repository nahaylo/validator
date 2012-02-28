class BaseTestDomain
  include ActiveModel::Validations

  attr_accessor :domain_name
end

class TestDomain < BaseTestDomain
  validates :domain_name, :domain => true
end

class TestDomainWithLength < BaseTestDomain
  validates :domain_name, :domain => { :length => 200, :label_length => 60 }
end

class TestDomainWithMessage < BaseTestDomain
  validates :domain_name, :domain => { :message => 'invalid' }
end

class TestDomainWithoutTld < BaseTestDomain
  validates :domain_name, :domain => { :check_tld  => false }
end
