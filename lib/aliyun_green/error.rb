module AliyunGreen
  class Error < StandardError
    attr_reader :code
    ClientError = Class.new(self)

    # 596 账号未授权、账号欠费、账号未开通、账号被禁等原因，具体可以参考返回的msg。
    PermissionDenyError =  Class.new(ClientError)

    # SignatureDoesNotMatch
    SignatureDoesNotMatchError =  Class.new(ClientError)

    def initialize(message = '', code = nil)
      super(message)

      @code = code
    end
  end
end