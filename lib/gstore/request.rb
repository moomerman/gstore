require 'time'
require 'openssl'
require 'digest/sha1'
require 'base64'
require 'uri'
require 'net/https'
require 'cgi'

module GStore
  class Client
    
    def signed_request(method, host, path, params={}, headers={}, options={})
      
      if @debug
        puts
        puts "***** METHOD: #{method}"
        puts "***** HOST: #{host}"
        puts "***** PATH: #{path}"
        puts "***** PARAMS: #{params.inspect}"
        puts "***** HEADERS: #{headers.inspect}"
        puts "***** OPTIONS: #{options.inspect}"
        puts
      end
      
      headers = {
        :Host => host,
        :Date => Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S -0000'),
        :"Content-Type" => 'text/plain',
        #:"Content-MD5" => ''
      }
      if options[:data]
        headers = headers.merge(:"Content-Length" => options[:data].size)
      else
        headers = headers.merge(:"Content-Length" => 0) 
      end
      
      bucket = nil
      if host =~ /(\S+).#{@host}/
        bucket = $1
      end
      
      canonical_headers = method.name.gsub('Net::HTTP::', '').upcase + "\n" +
        '' + "\n" + # Content-MD5
        headers[:"Content-Type"] + "\n" + # Content-Type
        headers[:Date] + "\n" # Date
      
      canonical_resource = ""
      canonical_resource += "/#{bucket}" if bucket
      canonical_resource += path
      #canonical_resource += params_to_request_string(params) unless params.empty?
      
      authorization = 'GOOG1 ' + @access_key + ':' + sign((canonical_headers + canonical_resource).toutf8)
      
      if @debug
        puts
        puts "+++++ BUCKET: #{bucket}"
        puts "+++++ HEADERS: #{headers.inspect}"
        puts "+++++ CANONICAL_HEADERS: #{canonical_headers}"
        puts "+++++ CANONICAL_RESOURCE: #{canonical_resource}"
        puts "+++++ AUTHORIZATION: #{authorization}"
        puts
      end
      
      _http_do(method, host, path, params_to_request_string(params), headers.merge(:Authorization => authorization), options[:data])
    end
    
    private
      def sign(str)
        digest = OpenSSL::Digest::Digest.new('sha1')
        b64_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, @secret_key, str)).gsub("\n","")
      end
      
      def _http_do(method, host, path, params, headers, data=nil)
        http = Net::HTTP.new(host, 443)
        http.use_ssl = true
        http.set_debug_output $stderr if @debug
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
        
        http.start do
          req = method.new(path + params)
          req.content_type = 'application/x-www-form-urlencoded'
          req['User-Agent'] = "moomerman-gstore-gem"
          headers.each do |key, value|
            req[key.to_s] = value
          end
                    
          response = http.request(req, data)

          return response.body
        end
      end
      
      def params_to_request_string(params)
        return "" if params.empty?
        sorted_params = params.sort {|x,y| x[0].to_s <=> y[0].to_s}
        escaped_params = sorted_params.collect do |p|
          encoded = (CGI::escape(p[0].to_s) + "=" + CGI::escape(p[1].to_s))
          encoded.gsub('+', '%20')
        end
        "?#{escaped_params.join('&')}"
      end
  end
end