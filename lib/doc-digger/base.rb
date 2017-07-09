require "doc-digger/config"
require "doc-digger/scan"
require "doc-digger/http"

module DocDigger

  class << self

    DIGEST = OpenSSL::Digest.new("sha1")

    def connect!(options)
      Config.init(access_key: options[:access_key], secret_key: options[:secret_key])
    end

    def upload(root, file)
      Config.check
      docs = scan(root, file)
      sign = OpenSSL::HMAC.digest(DIGEST, Config.settings[:secret_key], docs.to_json)

      params = {
        project_key: Config.settings[:access_key],
        data: Base64.urlsafe_encode64(docs.to_json),
        sign: Base64.urlsafe_encode64(sign)
      }

      url = "#{Config.settings[:upload_host]}/api/v1/documents"
      HTTP.post(url, params, { "Content-Type" => "application/json" })
    end

  end

end
