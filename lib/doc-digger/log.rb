require 'logger'

module DocDigger

  module Log
    class << self
      attr_accessor :err, :out

      def out
        @out ||= Logger.new(STDOUT)
      end

      def err
        @err ||= Logger.new(STDERR)
      end
      
    end
  end

end