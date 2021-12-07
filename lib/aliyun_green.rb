# frozen_string_literal: true
require_relative "aliyun_green/version"
require_relative "aliyun_green/text"
require_relative "aliyun_green/error"
require_relative "aliyun_green/client"
require_relative "aliyun_green/configuration"

module AliyunGreen
  attr_writer :configuration

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.client
    AliyunGreen::Client.new(
      endpoint: 'cn-beijing',
      api_version: '2018-05-09',
      access_key_id: AliyunGreen.configuration.access_key_id,
      access_key_secret: AliyunGreen.configuration.access_key_secret,
      enable_internal: AliyunGreen.configuration.enable_internal
    )
  end
end
