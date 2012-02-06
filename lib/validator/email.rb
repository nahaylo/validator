module Validator
  class Email
    attr_accessor :domain

    # Returns the local part (the left hand side of the @ sign in the email address) of the address
    #  a = Email.new('vitaliy@gmail.com')
    #  a.local #=> 'vitaliy'
    attr_accessor :local

    LOCAL_LENGTH = 64 
    
    def initialize(value)
      @value = value
      self.parse
    end

    def parse
      @local, @domain = @value.split(/@/)
    end

    def is_email?
      @value.split(/@/).size == 2
    end

    def valid_by_local_length?(local_length = nil)
      @local.length <= (local_length || LOCAL_LENGTH)
    end

    def valid_by_regexp?
      @value =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
    end

    # valid if passes all conditions
    def valid?
      is_email? and valid_by_local_length? and valid_by_regexp?
    end
  end
end
