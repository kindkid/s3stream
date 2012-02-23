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

  def self.usage
    puts "Please set AMAZON_ACCESS_KEY_ID and AMAZON_SECRET_ACCESS_KEY environmental variables."
    exit(1)
  end
end

AMAZON_ACCESS_KEY_ID     = ENV['AMAZON_ACCESS_KEY_ID'] || S3Stream.usage
AMAZON_SECRET_ACCESS_KEY = ENV['AMAZON_SECRET_ACCESS_KEY'] || S3Stream.usage

AWS::S3::Base.establish_connection!(
  :access_key_id     => AMAZON_ACCESS_KEY_ID,
  :secret_access_key => AMAZON_SECRET_ACCESS_KEY
)
