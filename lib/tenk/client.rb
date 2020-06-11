module Tenk
  class Client
    def connection
      Faraday.new(url: configuration.api_base) do |faraday|
        faraday.request :retry, max: 5, interval: 0.5, exceptions: [Faraday::ConnectionFailed, Errno::ETIMEDOUT, Timeout::Error]
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
