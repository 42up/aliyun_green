module AliyunGreen
  module Text
    def self.scan(content, data_id = nil)
      tasks = [
        {
          dataId: data_id,
          content: content
        }
      ]

      response = AliyunGreen.client.post('/green/text/scan', tasks)

      response
    end

    def self.bulk_scan
      # TODO
    end
    
    def self.feedback
      # TODO
    end
  end
end