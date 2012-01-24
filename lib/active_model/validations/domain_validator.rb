module ActiveModel
  module Validations
    class DomainValidator < ActiveModel::EachValidator
      def initialize(options)
        options[:length] ||= ::Validator::Domain::LENGTH
        options[:label_length] ||= ::Validator::Domain::LABEL_LENGTH

        super(options)
      end

      def validate_each(record, attr_name, value)
        # do not validate if value is empty
        return if value.nil?

        @validator = ::Validator::Domain.new(value)

        # max domain length
        unless @validator.valid_by_length?(options[:length])
          record.errors.add(attr_name, :'domain.length', options)
        end

        # label is limited to between 1 and 63 octets
        unless @validator.valid_by_label_length?(options[:label_length])
          record.errors.add(attr_name, :'domain.label_length', options)
        end

        # skip proceeding validation if errors
        return unless record.errors.blank?

        unless @validator.valid_by_regexp?
          record.errors.add(attr_name, :'domain.invalid', options)
        end
      end
    end

    module HelperMethods
      #   class Dns < ActiveRecord::Base
      #     validates_domain_of :domain_name
      #   end
      #
      def validates_domain_of(*attr_names)
        validates_with DomainValidator, _merge_attributes(attr_names)
      end
    end
  end
end
