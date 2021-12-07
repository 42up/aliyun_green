require "httpx"
require "time"

# TODO: validate config
# TODO: 支持clientInfo

module AliyunGreen
  class Client
    attr_accessor :endpoint, :api_version, :access_key_id,:access_key_secret, :enable_internal

    def initialize(config)
      self.endpoint          = config[:endpoint]
      self.api_version       = config[:api_version]
      self.access_key_id     = config[:access_key_id]
      self.access_key_secret = config[:access_key_secret]
      self.enable_internal   = config[:enable_internal]
    end

    def post(uri , tasks, params = {})
      payload = {
        bizType: 'default',
        scenes: ["antispam"],
        tasks: tasks
      }

      url = "https://#{get_host(self.endpoint)}#{uri}"

      mix_headers = default_headers
      request_body = payload.to_json

      mix_headers['content-md5']    = Digest::MD5.base64digest request_body
      mix_headers['content-length'] = request_body.length.to_s

      string2sign = string_to_sign('/green/text/scan', mix_headers, params)
      mix_headers.merge!(authorization: authorization(string2sign))

      response = HTTPX.with(headers: mix_headers).post(url, body: payload.to_json)

      r =  JSON.parse(response)

      raise AliyunGreen::Error::SignatureDoesNotMatchError if r["Code"] == 'SignatureDoesNotMatch'
      raise AliyunGreen::Error::ClientError.new(r["msg"], r["code"]) if r["code"] != 200

      r
    end

    def string_to_sign(uri, headers, query = {})
      header_string = [
        'POST',
        headers['accept'],
        headers['content-md5'] || '',
        headers['content-type'] || '',
        headers['date'],
      ].join("\n")
      "#{header_string}\n#{canonicalized_headers(headers)}#{canonicalized_resource(uri, query)}"
    end

    def canonicalized_headers(headers)
      headers.keys.select { |key| key.to_s.start_with? 'x-acs-' }
        .sort.map { |key| "#{key}:#{headers[key].strip}\n" }.join
    end

    def canonicalized_resource(uri, query_hash = {})
      query_string = query_hash.sort.map { |key, value| "#{key}=#{value}" }.join('&')
      query_string.empty? ? uri : "#{uri}?#{query_string}"
    end

    def authorization(string_to_sign)
      "acs #{self.access_key_id}:#{signature(string_to_sign)}"
    end

    def signature(string_to_sign)
      Base64.encode64(OpenSSL::HMAC.digest('sha1', self.access_key_secret, string_to_sign)).strip
    end

    def default_headers
      default_headers = {
        'accept' => 'application/json',
        'content-type' => 'application/json',
        'date' => Time.now.httpdate,
        'host' => get_host(self.endpoint),
        'x-acs-version' => self.api_version,
        'x-acs-signature-nonce' => SecureRandom.hex(16),
        'x-acs-signature-version' => '1.0',
        'x-acs-signature-method' => 'HMAC-SHA1',
      }
      default_headers
    end

    def get_host(endpoint)
      externals = {
        'cn-shanghai' => 'green.cn-shanghai.aliyuncs.com',
        'cn-beijing' => 'green.cn-beijing.aliyuncs.com',
        'cn-shenzhen' => 'green.cn-shenzhen.aliyuncs.com',
        'ap-southeast-1' => 'green.ap-southeast-1.aliyuncs.com'
      }
      internals = {
        'cn-shanghai' => 'green-vpc.cn-shanghai.aliyuncs.com',
        'cn-beijing' => 'green-vpc.cn-beijing.aliyuncs.com',
        'cn-shenzhen' => 'green-vpc.cn-shenzhen.aliyuncs.com',
        'ap-southeast-1' => 'green-vpc.ap-southeast-1.aliyuncs.com'
      }
      if self.enable_internal
        internals[endpoint]
      else
        externals[endpoint]
      end
    end
  end
end