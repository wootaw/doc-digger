require "doc-digger/config"

module DocDigger

  def self.connect!(options)
    DocDigger::Config.init(access_key: options[:access_key], secret_key: options[:secret_key])
  end

end
