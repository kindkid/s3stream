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
      buffer = ""
      total = 0
      buffer_size = INITIAL_BUFFER_SIZE
      puts "Uploading, please be patient."
      object.multipart_upload do |upload|
        (1..MAX_CHUNKS).each do |chunk|
          if $stdin.eof?
            puts "End of input."
            break
          end
          if chunk < MAX_CHUNKS
            print "Buffering input (up to #{buffer_size} bytes) ... "
            $stdin.read(buffer_size, buffer)
            puts "done."
            print "Uploading part #{chunk} (#{buffer.size} bytes) ... "
            upload.add_part(buffer)
            puts "done."
            buffer_size = (buffer_size * BUFFER_GROWTH_FACTOR).to_i
          else
            print "Last part (#{chunk})! Buffering input (unlimited) ..."
            buffer = $stdin.read
            puts "done."
            print "Uploading part #{chunk} (#{buffer.size} bytes) ... "
            upload.add_part(buffer)
            puts "done."
          end
          total += buffer.size
        end
      end
      puts "Done uploading to s3://#{bucket_name}/#{filename} (#{total} bytes)"
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