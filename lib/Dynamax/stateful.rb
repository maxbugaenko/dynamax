require 'faraday'
# stateful.co communication module
module Dynamax
  module Stateful
    # stateful.co counter
    class Counter
      def initialize(name)
        @name = name
        @conn = Faraday.new(url: 'http://www.stateful.co') do |faraday|
          faraday.request :url_encoded
          faraday.adapter Faraday.default_adapter
        end
      end

      def inc(value = 1)
        response = @conn.get do |req|
          req.url '/c/' + @name + '/inc?value=' + value.to_s
          req.headers['X-Sttc-URN'] = Dynamax.creds['stateful']['urn']
          req.headers['X-Sttc-Token'] = Dynamax.creds['stateful']['token']
          req.headers['Accept'] = 'text/plain'
        end
        response.body.to_i
      end
    end
  end
end