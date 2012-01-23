Active Model Validator
============================

This is a ActiveModel validators for domains and ip addresses.

Installation
------------
gem install validator

Usage
-------

In your models, the gem provides new validators like :domain or :ip_address

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


Copyright
---------

Copyright (c) 2011 Vitaliy Nahaylo. See LICENSE for details.
