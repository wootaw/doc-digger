require 'rest-client'
require "doc-digger/log"

module DocDigger
  module HTTP
    class << self

      def post (url, req_body = nil, opts = {})
        req_headers = {
          :connection => 'close',
          :accept     => '*/*',
          :user_agent => Config.settings[:user_agent]
        }

        if opts[:headers].is_a?(Hash) then
          req_headers.merge!(opts[:headers])
        end

        response = RestClient.post(url, req_body, req_headers)
        return response.code.to_i, response.body, response.raw_headers
      rescue => e
        Log.err.warn "#{e.message} => DocDigger::HTTP.post('#{url}')"
        if e.respond_to?(:response) && e.response.respond_to?(:code) then
          return e.response.code, e.response.body, e.response.raw_headers
        end
        return nil, nil, nil
      end

    end
  end

end
