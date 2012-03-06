module S3Stream
  class Main < Thor
    desc "fetch bucket filename", "download/stream the file from S3 to stdout"
    def fetch(bucket_name, filename)
      require 'open-uri'
      object = s3object(bucket_name, filename)
      uri = object.url_for(:read, :secure => true, :expires => 60 * 60) # 1 hour
      uri.open do |stream|
        buffer = ""
        until stream.eof?
          stream.readpartial(4096, buffer)
          $stdout.write(buffer)
        end
      end
    end
    
    desc "store bucket filename", "upload/stream the file from stdin to S3"
    def store(bucket_name, filename)
      $stdout.sync = true
      object = s3object(bucket_name, filename)
      S3Stream::Upload.to(:s3object => object, :log_to => $stdout) do |out|
        buffer = ""
        until $stdin.eof?
          $stdin.readpartial(4096, buffer)
          out.write(buffer)
        end
      end
    end

    private

    def s3
      @s3 ||= AWS::S3.new(S3Stream::CREDENTIALS)
    end

    def s3object(bucket_name, key)
      bucket = s3.buckets[bucket_name]
      bucket.objects[key]
    end
  end
end