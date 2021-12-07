module AliyunGreen
  class Configuration
    attr_accessor :access_key_id, :access_key_secret,
                  :region_id, :api_version, :enable_internal

    def initialize
      @access_key_id = ""
      @access_key_secret = ""
      @endpoint = "cn-beijing"
      @api_version = "2018-05-09"
      @enable_internal = false
    end

    def to_hash
      {
        endpoint: @endpoint,
        api_version: @api_version,
        access_key_id: @access_key_id,
        access_key_secret: @access_key_secret,
      }
    end
  end
end