module GStore
  class Client
    def put_object(bucket, filename, data, options={})
      put(bucket, "/#{filename}", options, data)
    end
    
    def get_object(bucket, filename, options={})
      outfile = options.delete(:outfile)
      res = get(bucket, "/#{filename}", options)
      if outfile
        File.open(outfile, 'w') {|f| f.write(res) }
      else
        res
      end
    end
    
    def delete_object(bucket, filename, options={})
      delete(bucket, "/#{filename}", options)
    end
    
    def get_object_metadata(bucket, filename, options={})
      head(bucket, "/#{filename}", options)
    end
  end
end