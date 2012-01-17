$:.unshift(File.dirname(__FILE__) + '/../lib')

require "rubygems"
require "validator"

RSpec.configure do |config|

end


RSpec::Matchers.define :have_errors_on do |attribute, errors_size|
  @message = nil
  #@errors_size = errors_size

  chain :with_message do |message|
    @message = message
  end

  match do |model|
    model.errors.clear
    model.valid?

    @has_errors = !model.errors[attribute].blank?
#    @has_errors_on_size = ((!errors_size.nil?) ? true : false) #model.errors[attribute].size == errors_size : false)

    if @message
      (@has_errors || @has_errors_on_size) && model.errors[attribute].include?(@message)
      @has_errors && model.errors[attribute].include?(@message)
    else
      @has_errors #|| @has_errors_on_size
    end
  end

  failure_message_for_should do |model|
    msg = []
    if @message
      msg << "Validation errors #{model.errors[attribute].inspect} should include #{@message.inspect}" if @has_errors
      msg << "have #{@errors_size} errors" if @has_errors_on_size
      msg.join(" and ")
    else
      msg << "#{model.class} should have errors on #{attribute.inspect}" if @has_errors
      msg << "have #{@errors_size} errors" if @has_errors_on_size
      msg.join(" and ")
    end
    msg.to_s
  end

  failure_message_for_should_not do |model|
    "#{model.class} should not have an error on #{attribute.inspect} "  + (@message.blank? ? "" : " with message \"#{@message}\"")
  end

  description do
    "have errors on #{attribute.inspect}" + (@message.blank? ? "" : " with message \"#{@message}\"") + (@errors_size.nil? ? "" : " and have #{@errors_size} errors")
  end
end
