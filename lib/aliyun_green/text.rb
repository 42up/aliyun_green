module AliyunGreen
  module Text
    class << self
      def scan(content, data_id = nil)
        tasks = [
          {
            dataId: data_id,
            content: content,
          },
        ]

        response = AliyunGreen.client.post("/green/text/scan", build_payload(tasks))

        response
      end

      def bulk_scan
        # TODO
      end

      def feedback
        # TODO
      end

      private

      def build_payload(tasks)
        payload = {
          bizType: "default",
          scenes: ["antispam"],
          tasks: tasks,
        }
        payload
      end
    end
  end
end
