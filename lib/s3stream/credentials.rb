module S3Stream

  private

  def self.credentials
    access_key_id, secret_access_key = nil

    # Try AWS tools' standard way
    if ENV['AWS_CREDENTIAL_FILE'] && File.file?(ENV['AWS_CREDENTIAL_FILE'])
      File.open(ENV['AWS_CREDENTIAL_FILE']) do |f|
        f.lines.each do |line|
          access_key_id = $1 if line =~ /^AWSAccessKeyId=(.*)$/
          secret_access_key = $1 if line =~ /^AWSSecretKey=(.*)$/
        end
      end
    end

    # Try aws-s3 gem's way
    access_key_id     ||= ENV['AMAZON_ACCESS_KEY_ID']
    secret_access_key ||= ENV['AMAZON_SECRET_ACCESS_KEY']

    # Try s3cmd gem's way
    access_key_id     ||= ENV['AWS_ACCESS_KEY']
    secret_access_key ||= ENV['AWS_SECRET_KEY']

    if access_key_id.nil? || secret_access_key.nil?
      nil
    else
      {:access_key_id => access_key_id, :secret_access_key => secret_access_key}
    end
  end

  CREDENTIALS = S3Stream.credentials
end
