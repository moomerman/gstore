module GStore
  class Client
    
    def list_buckets(options={})
      get(nil, '/', options)
    end
    
    def create_bucket(bucket, options={})
      put(bucket, '/', options)
    end
    
    def get_bucket(bucket, options={})
      get(bucket, '/', options)
    end
    
    def delete_bucket(bucket, options={})
      delete(bucket, '/', options)
    end
    
  end
end