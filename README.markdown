Active Model Validator
============================

This is a ActiveModel validators for domains and ip addresses.

Example
-------

The following model uses `ActiveModel::Validations::PresenceValidator` and `ActiveRecord::Validations::UniquenessValidator` to ensure the presence and uniqueness of the user’s email attribute. The third line uses `EmailValidator` to check that the email address is valid.

    class Model < ActiveRecord::Base
      validates :domain_name, :domain => true
      validates :ip, :ip_address => true
    end


Domain Validator
----------------

    validates :domain_name, :domain => true

    validates :domain_name, :domain => {:message => 'custom message'}


Ip Address Validator
--------------------

    # validate ip address
    validates :ip, :ip_address => true

    # ip address allowed with prefix
    validates :ip, :ip_address => { :allow_prefix => true }

    # allows only IPv4
    validates :ip, :ip_address => { :only => :ipv4 }

    # allows only IPv6
    validates :ip, :ip_address => { :only => :ipv6 }

    validates :ip, :ip_address => { :message => "custom message" }

Copyright
---------

Copyright (c) 2011 Vitaliy Nahaylo. See LICENSE for details.