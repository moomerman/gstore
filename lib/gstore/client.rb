require 'gstore/request'
require 'gstore/bucket'
require 'gstore/object'

module GStore
  class Client
    
    def initialize(options = {})
      @access_key = options[:access_key]
      @secret_key = options[:secret_key]
      @debug = options[:debug] and options[:debug] == true
      @host = options[:host] || 'commondatastorage.googleapis.com'
    end

    private
      
      def get(bucket, path, params={}, options={})
        _http_request(Net::HTTP::Get, bucket, path, params, options)
      end
      
      def put(bucket, path, params={}, options={})
        _http_request(Net::HTTP::Put, bucket, path, params, options)
      end
      
      def delete(bucket, path, params={}, options={})
        _http_request(Net::HTTP::Delete, bucket, path, params, options)
      end
      
      def head(bucket, path, params={}, options={})
        _http_request(Net::HTTP::Head, bucket, path, params, options)
      end
      
      def _http_request(method, bucket, path, params, options={})
        host = @host
        host = "#{bucket}.#{@host}" if bucket
        signed_request(method, host, path, params, options)
      end
      
  end
end
   
