module AliyunGreen
  module Image
    class << self
      def scan(tasks, **options)
        check_tasks(tasks)
        response = AliyunGreen.client.post("/green/image/scan", build_payload(tasks, options))
        response
      end

      def scan_async(tasks, **options)
        check_tasks(tasks)
        callback_url = options[:callback_url]
        payload = build_payload(tasks, options)
        if callback_url
          payload[:callback] = callback_url
          payload[:seed] = SecureRandom.uuid
        end
        answer = AliyunGreen.client.post("/green/image/asyncscan", payload)
        answer["seed"] = payload[:seed] if callback_url

        answer
      end

      def check_task_answer(task_ids)
        response = AliyunGreen.client.post("/green/image/results", task_ids)
      end

      def feedback
      end

      def scene_dict
        {
          porn: "图片智能鉴黄",
          terrorism: "图片暴恐涉政",
          ad: "图文违规",
          qrcode: "图片二维码",
          live: "图片不良场景",
          logo: "图片logo",
        }
      end

      def scene_response_dict
        {
          porn: {
            normal: "正常",
            sexy: "性感",
            porn: "色情",
          },
          terrorism: {
            normal: "正常",
            bloody: "血腥",
            explosion: "爆炸烟光",
            outfit: "特殊装束",
            logo: "特殊标识",
            weapon: "武器",
            politics: "涉政",
            violence: "打斗",
            crowd: "聚众",
            parade: "游行",
            carcrash: "车祸现场",
            flag: "旗帜",
            location: "地标",
            drug: "涉毒",
            gamble: "赌博",
            others: "其他",
          },
          ad: {
            normal: "正常",
            ad: "其他广告",
            politics: "文字含涉政内容",
            porn: "文字含涉黄内容",
            abuse: "文字含辱骂内容",
            terrorism: "文字含暴恐内容",
            contraband: "文字含违禁内容",
            spam: "文字含其他垃圾内容",
            npx: "牛皮癣广告",
            qrcode: "含二维码",
            programCode: "含小程序码",
          },
          qrcode: {
            normal: "正常",
            qrcode: "含二维码",
            programCode: "含小程序码",
          },
          live: {
            normal: "正常",
            meaningless: "图片中无内容（例如黑屏、白屏）",
            PIP: "画中画",
            smoking: "吸烟",
            drivelive: "车内直播",
            drug: "涉毒",
            gamble: "赌博",
          },
          logo: {
            normal: "正常",
            TV: "含受管控的logo",
            trademark: "含商标",
          },

        }
      end

      private

      def check_tasks(tasks)
        raise ArgumentError, "tasks must be an Array" unless tasks.is_a?(Array)
        raise ArgumentError, "tasks size must no more than 100" unless tasks.size <= 100
        raise ArgumentError, "tasks must be an Array of Hash with necessary key url" unless tasks.all? { |task| task.is_a?(Hash) || task.keys.include?(:url) }
      end

      def calc_valid_scenes(options)
        scenes = options[:secnes] || options["secnes"] || []

        valid_scenes = scenes.select { |x| scene_dict.keys.map(&:to_s).include? x.to_s }
        valid_scenes = ["porn", "terrorism"] if valid_scenes.size == 0
      end

      # 需要先在内容安全/设置/机器审核/业务场景: default 中进行初始配置是
      def build_payload(tasks, options)
        scenes = calc_valid_scenes(options)
        payload = {
          bizType: "default",
          scenes: scenes,
          tasks: tasks,
        }
        payload
      end
    end
  end
end
