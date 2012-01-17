class BaseTestDomain
  include ActiveModel::Validations

  attr_accessor :domain_name
end

class TestDomain < BaseTestDomain
  validates :domain_name, :domain => true
end

class TestDomainWithMessage < BaseTestDomain
  validates :domain_name, :domain => { :message => 'invalid' }
end