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

  describe "Text scan about" do
    it "invokes text scan correctly" do
      response = AliyunGreen::Text.scan("Hello, world!")
      # {"code"=>200, "data"=>[{"code"=>200, "content"=>"Hello, world!", "msg"=>"OK", "results"=>[{"label"=>"normal", "rate"=>99.91, "scene"=>"antispam", "suggestion"=>"pass"}], "taskId"=>"txt68HT9XiCXSB5Z9J6Gzswj1-1wxZXX"}], "msg"=>"OK", "requestId"=>"E9D11DA9-90B9-5A4F-9EFB-694EF42D8032"}
      expect(response.dig("code")).to eq(200)
    end
  end

  describe "Image scan about" do
    it "invokes image scan correctly" do
      tasks = [
        {
          url: "https://www.betaqr.com/images/wallpapers/rebirth.jpg",
        },
      ]

      response = AliyunGreen::Image.scan(tasks)
      puts response
      # {"code"=>200, "data"=>[{"code"=>200, "extras"=>{}, "msg"=>"OK", "results"=>[{"label"=>"normal", "rate"=>99.9, "scene"=>"porn", "suggestion"=>"pass"}, {"label"=>"normal", "rate"=>100.0, "scene"=>"terrorism", "suggestion"=>"pass"}], "taskId"=>"img4ubk19AOA2s7saK5dZROfM-1wy2$k", "url"=>"https://www.betaqr.com/images/wallpapers/rebirth.jpg"}], "msg"=>"OK", "requestId"=>"9A2524EC-C9DC-59F2-9B0A-C2B8BEA4D5F1"}

      # {"code"=>200, "data"=>[{"code"=>200, "extras"=>{}, "msg"=>"OK", "results"=>[{"label"=>"porn", "rate"=>95.92, "scene"=>"porn", "suggestion"=>"review"}, {"label"=>"normal", "rate"=>100.0, "scene"=>"terrorism", "suggestion"=>"pass"}], "taskId"=>"img74JOskCik585d8$1ncDPdF-1wy3di", "url"=>"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsc01.alicdn.com%2Fkf%2FHTB1ldIMbdfvK1RjSspfq6zzXFXap%2F235262355%2FHTB1ldIMbdfvK1RjSspfq6zzXFXap.jpg&refer=http%3A%2F%2Fsc01.alicdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1660999559&t=977c7868c88f6e6ba6f29f5dfe60c512"}], "msg"=>"OK", "requestId"=>"D141D88C-96C0-5CA0-ACD1-6B2D22A7E83F"}

      expect(response.dig("code")).to eq(200)
    end

    it "invokes image async scan correctly" do
      tasks = [
        {
          url: "https://img-blog.csdn.net/20161015114557738",
        },
      ]
      response = AliyunGreen::Image.scan_async(tasks, callback_url: "https://webhook.site/310b91f4-91d8-41bd-97aa-f3344c08471f")
      #{"code"=>200, "data"=>[{"code"=>200, "msg"=>"OK", "taskId"=>"img4@ek3IUEQPK6NV2RkorQfO-1wy3NX", "url"=>"https://img-blog.csdn.net/20161015114557738"}], "msg"=>"OK", "requestId"=>"350662A1-6912-5DDE-8EBB-451166B20B93"}

      #callback url  会收到到POST信息
      # {"code":200,"extras":{},"msg":"OK","results":[{"label":"sexy","rate":77.57,"scene":"porn","suggestion":"review"},{"label":"normal","rate":100.0,"scene":"terrorism","suggestion":"pass"}],"taskId":"img3Bc@EMajQgP6kzzoF2xRPS-1wy3Qp","url":"https://img-blog.csdn.net/20161015114557738"}
      puts response
      expect(response["code"]).to eq 200
    end

    it "invokes result correctly" do
      tasks = [
        {
          url: "https://img-blog.csdn.net/20161015114557738",
        },
      ]
      response = AliyunGreen::Image.scan_async(tasks)

      task_id = response.dig("data", 0, "taskId")
      answer = AliyunGreen::Image.check_task_answer([task_id])
      puts answer
      # 过程中， 和过程结束
      # {"code"=>200, "data"=>[{"code"=>280, "extras"=>{}, "msg"=>"PROCESSING - queue", "taskId"=>"img3BE68uhtk1q5ZO3Dl1BGdZ-1wy40m", "url"=>"https://img-blog.csdn.net/20161015114557738"}], "msg"=>"OK", "requestId"=>"5F3E211C-C883-51D7-8C54-9D735902D054"}
      # {"code"=>200, "data"=>[{"code"=>200, "extras"=>{}, "msg"=>"OK", "results"=>[{"label"=>"sexy", "rate"=>77.57, "scene"=>"porn", "suggestion"=>"review"}, {"label"=>"normal", "rate"=>100.0, "scene"=>"terrorism", "suggestion"=>"pass"}], "taskId"=>"img3BE68uhtk1q5ZO3Dl1BGdZ-1wy40m", "url"=>"https://img-blog.csdn.net/20161015114557738"}], "msg"=>"OK", "requestId"=>"2A7B414A-6110-59CC-BAA6-077BB757F15F"}
      expect(answer["code"]).to eq 200
    end
  end
end
