Active Model Validator [![Travis](https://secure.travis-ci.org/nahaylo/validator.png)](http://travis-ci.org/nahaylo/validator)
============================

This is a ActiveModel validators for domains (including TLDs), ip addresses and email addresses.

Installation
------------
    gem install validator

Usage
-------

In your models, the gem provides new validators like :domain, :ip_address or :email

    class Model < ActiveRecord::Base
      validates :domain_name, :domain => true
      validates :ip, :ip_address => true
      validates :email_address, :email => true
    end


Domain Validator
----------------

    # validate domain name by full length, label length, TLD existing
    validates :domain_name, :domain => true

    validates :domain_name, :domain => { :message => 'custom message' }

    # custom full domain and label length
    validates :domain_name, :domain => { :length => 200, :label_length => 60 }

    # skip TLD validation
    validates :domain_name, :domain => { :check_tld => false }


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


Email Address Validator
-----------------------

    validates :email_address, :email => true

    validates :email_address, :email => { :message => 'custom message' }

    # custom local part, full domain and label length of email address
    validates :email_address, :email => { :local_length => 60, :domain => { :length => 200, :label_length => 60 }}


Localization Tricks
-------------------
To customize error message, you can use { :message => "your custom message" } or simple use Rails localization en.yml file, for instance:

    en:
      errors:
        messages:
          domain:
            length: "your custom length error message"
         ip_address:
           invalid:
             general: "your custom invalid ip address error message"
      activemodel:
        errors:
          messages:
            domain:
              invalid: "custom error message only for activemodel"
           models:
             your_model:
               domain:
                 invalid: "custom error message for YourDomain model"


Copyright
---------

Copyright (c) 2011 Vitaliy Nahaylo. See LICENSE for details.
