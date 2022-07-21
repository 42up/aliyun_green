# frozen_string_literal: true
require "byebug"

RSpec.describe AliyunGreen do
  before(:each) do
    if File.exist?(".debug_ak_sk_value")
      ak, sk = File.read(".debug_ak_sk_value").split("\n")
      AliyunGreen.configure do |config|
        config.access_key_id = ak
        config.access_key_secret = sk
      end
    else
    end
  end

  it "has a version number" do
    expect(AliyunGreen::VERSION).not_to be nil
  end

  it "invokes text scan correctly" do
    response = AliyunGreen::Text.scan("Hello, world!")
    # {"code"=>200, "data"=>[{"code"=>200, "content"=>"Hello, world!", "msg"=>"OK", "results"=>[{"label"=>"normal", "rate"=>99.91, "scene"=>"antispam", "suggestion"=>"pass"}], "taskId"=>"txt68HT9XiCXSB5Z9J6Gzswj1-1wxZXX"}], "msg"=>"OK", "requestId"=>"E9D11DA9-90B9-5A4F-9EFB-694EF42D8032"}
    expect(response.dig("code")).to eq(200)
  end
end
