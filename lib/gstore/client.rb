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
      
      def get(bucket, path, options={})
        _http_request(Net::HTTP::Get, bucket, path, options)
      end
      
      def put(bucket, path, options={})
        _http_request(Net::HTTP::Put, bucket, path, options)
      end
      
      def delete(bucket, path, options={})
        _http_request(Net::HTTP::Delete, bucket, path, options)
      end
      
      def head(bucket, path, options={})
        _http_request(Net::HTTP::Head, bucket, path, options)
      end
      
      def _http_request(method, bucket, path, options={})
        host = @host
        host = "#{bucket}.#{@host}" if bucket
        params = options.delete(:params) || {}
        headers = options.delete(:headers) || {}
        params[:"max-keys"] = params.delete(:max_keys) if params and params[:max_keys]
        headers[:"x-goog-acl"] = headers.delete(:x_goog_acl) if headers and headers[:x_goog_acl]
        signed_request(method, host, path, params, headers, options)
      end
      
  end
end
   
