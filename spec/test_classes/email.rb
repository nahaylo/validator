class BaseTestEmail
  include ActiveModel::Validations

  attr_accessor :email
end

class TestEmail < BaseTestEmail
  validates :email, :email => true
end

class TestEmailWithDomainLength < BaseTestEmail
  validates :email, :email => { :domain => { :length => 200, :label_length => 60 } }
end

class TestEmailWithMessage < BaseTestEmail
  validates :email, :email => { :message => 'invalid' }
end
