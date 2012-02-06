require "active_model"
require "active_support/i18n"
require "active_support/inflector"

require "active_model/validations/domain_validator"
require "active_model/validations/ip_address_validator"
require "active_model/validations/email_validator"

module Validator
  %w(domain version ip_address email).each do |model|
    autoload model.camelize.to_sym, "validator/#{model}"
  end
end

I18n.load_path << File.dirname(__FILE__) + '/validator/locale/en.yml'
