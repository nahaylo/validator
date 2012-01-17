module ActiveModel
  module Validations
    class DomainValidator < ActiveModel::EachValidator
      # Call `#initialize` on the superclass, adding a default
      # `:allow_nil => false` option.
      def initialize(options)
        super(options.reverse_merge(:allow_nil => false))
      end

      def validate_each(record, attr_name, value)
        return if options[:allow_nil] && value.nil?

        # do not validate if value is empty
        return if value.nil?

        @validator = ::Validator::Domain.new(value)

        # max domain length
        unless @validator.valid_by_length?
          record.errors.add(attr_name, :'domain.length', options)
          #return
        end

        # label is limited to between 1 and 63 octets
        unless @validator.valid_by_label_length?
          record.errors.add(attr_name, :'domain.label_length', options)
          #return
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
