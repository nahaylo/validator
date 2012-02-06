module ActiveModel
  module Validations
    class EmailValidator < ActiveModel::EachValidator
      def initialize(options)
        options[:local_length] ||= ::Validator::Email::LOCAL_LENGTH

        options[:domain] ||= {}
        options[:domain_length] = options[:domain][:length] ||= ::Validator::Domain::LENGTH
        options[:domain_label_length] = options[:domain][:label_length] ||= ::Validator::Domain::LABEL_LENGTH

        super(options)
      end

      def validate_each(record, attr_name, value)
        # do not validate if value is empty
        return if value.nil?

        @validator = ::Validator::Email.new(value)

        unless @validator.is_email? 
          record.errors.add(attr_name, :'email.invalid', options)
          return false
        end

        unless @validator.valid_by_local_length?(options[:local_length])
          record.errors.add(attr_name, :'email.local_length', options)
          return false
        end

        unless @validator.valid_by_regexp?
          record.errors.add(attr_name, :'email.invalid', options)
          return false
        end

        # validate domain part of email address
        @domain_validator = ::Validator::Domain.new(@validator.domain)

        # max domain length
        unless @domain_validator.valid_by_length?(options[:domain_length])
          record.errors.add(attr_name, :'email.domain.length', options)
        end

        # label is limited to between 1 and 63 octets
        unless @domain_validator.valid_by_label_length?(options[:domain_label_length])
          record.errors.add(attr_name, :'email.domain.label_length', options)
        end

        # skip proceeding validation if errors
        return unless record.errors.blank?

        unless @domain_validator.valid_by_regexp?
          record.errors.add(attr_name, :'email.domain.invalid', options)
        end
      end
    end

    module HelperMethods
      #   class User < ActiveRecord::Base
      #     validates_email_of :email_address
      #   end
      #
      def validates_email_of(*attr_names)
        validates_with EmailValidator, _merge_attributes(attr_names)
      end
    end
  end
end
