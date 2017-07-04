module DocDigger

  class Exception < RuntimeError; end

  class MissingArgumentsError < Exception

    def initialize(missing_keys)
      key_list = missing_keys.map { |key| key.to_s }.join(' and the ')
      super("You did not provide both required arguments. Please provide the #{key_list}.")
    end
    
  end

  class ArgumentTypeError < Exception

    def initialize(key, clazz)
      super("The #{key} must be data of #{clazz} class.")
    end

  end

end
