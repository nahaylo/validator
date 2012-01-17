module Validator
  class Domain
    LENGTH = 255
    LABEL_LENGTH = 63
    
    def initialize(value)
      @value = value
    end

    def valid_by_length?(length = LENGTH)
      @value.length <= length
    end

    def valid_by_label_length?(label_length = LABEL_LENGTH)
      !(@value.split(".").find{|f| f.length > label_length and f.length > 1 })
    end

    def valid_by_regexp?
      @value =~ /^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/i
    end

    # valid if passes all conditions
    def valid?
      valid_by_length? and valid_by_label_length? and valid_by_regexp?
    end
  end
end
