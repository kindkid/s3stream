require "s3stream/version"
require "thor"
require "aws/s3"

module S3Stream 
  class Main < Thor
    desc "fetch bucket filename", "download/stream the file from S3 to stdout"
    def fetch(bucket, filename)
      AWS::S3::S3Object.stream(filename, bucket) do |chunk|
        $stdout.write chunk
      end
    end
    
    desc "store bucket filename", "upload/stream the file from stdin to S3"
    def store(bucket, filename)
      AWS::S3::S3Object.store(filename, ARGF, bucket)
    end
  end
end
