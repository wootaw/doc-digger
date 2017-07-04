require 'tmpdir'
require "doc-digger/exceptions"

module DocDigger
  module Config
    class << self
      DEFAULTS = {
        :access_key => {
          :default      => nil,
          :public       => true,
          :type         => String,
          :required     => true,
          :description  => 'Your DocDigger access key.'
        },
        :secret_key => {
          :default      => nil,
          :public       => true,
          :type         => String,
          :required     => true,
          :description  => 'Your DocDigger secret key.'
        },
        :upload_host => {
          :default      => 'http://api.apiwoods.com',
          :public       => false,
          :type         => String,
          :required     => true,
          :description  => 'Upload host'
        }
      }.freeze

      attr_reader :settings

      def init(options = {})
        @settings = Hash[DEFAULTS.map { |k, v| [k, v[:default]] }]
        @settings.merge!(options.select { |k, v| DEFAULTS[k][:public] })

        DEFAULTS.each do |k, v|
          raise MissingArgumentsError, [k] if v[:required] && @settings[k].nil?
          raise ArgumentTypeError.new(k, v[:type]) unless @settings[k].class == v[:type]
        end
      end

      def load(file)
        if File.exist?(file)
          config_options = YAML.load_file(file)
          config_options.symbolize_keys!
          init(config_options)
        else
          raise MissingConfigError, file
        end
      end

    end
  end
end
