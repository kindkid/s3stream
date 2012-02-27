module S3Stream
  class Main < Thor
    desc "fetch bucket filename", "download/stream the file from S3 to stdout"
    def fetch(bucket_name, filename)
      require "aws/s3"
      AWS::S3::Base.establish_connection!(S3Stream::CREDENTIALS)
      AWS::S3::S3Object.stream(filename, bucket_name) do |chunk|
        $stdout.write chunk
      end
    end
    
    desc "store bucket filename", "upload/stream the file from stdin to S3"
    def store(bucket_name, filename)
      require "aws-sdk"
      $stdout.sync = true
      s3 = AWS::S3.new(S3Stream::CREDENTIALS)
      bucket = s3.buckets[bucket_name]
      object = bucket.objects[filename]
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
  end
end