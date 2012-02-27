require "thor"
require "s3stream/version"
require "s3stream/constants"
require "s3stream/main"
require "s3stream/credentials"

if S3Stream::CREDENTIALS.nil?
  puts "Environmental variables must be set."
  puts "See https://github.com/kindkid/s3stream/blob/v#{S3Stream::VERSION}/README"
  exit(1)
end
