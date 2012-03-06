module S3Stream
  class Upload

    # S3Stream::Upload.to(:s3object => s3object, :log_to => $stdout) do |out|
    #   out.write("abc")
    #   out.write("123")
    # end
    def self.to(args={})
      stream = new(args)
      begin
        yield stream
        stream.close
      rescue => e
        stream.cancel
        raise
      end
    end

    attr_reader :size

    def initialize(args={})
      @s3object = args[:s3object] || raise("Missing :s3object")
      @log = args[:log_to] # optional
      reset
      @upload = @s3object.multipart_upload
    end

    def write(data)
      @buffer << data
      flush if @chunk < S3Stream::MAX_CHUNKS && @buffer.size >= @buffer_size
      @size += data.size
    end

    def close
      flush if @buffer.size > 0
      unless @upload.close.nil?
        log "Done uploading #{size} bytes to #{location}."
      end
    end

    def cancel
      @upload.abort unless @upload.nil?
      reset
      log "Canceled upload to #{location}."
    end

    private

    def location
      "s3://#{@s3object.bucket.name}/#{@s3object.key}"
    end

    def reset
      @buffer = ""
      @buffer_size = S3Stream::INITIAL_BUFFER_SIZE
      @size = 0
      @chunk = 1
      @upload = nil
    end

    def flush
      log "Uploading part #{@chunk} (#{@buffer.size} bytes)."
      @upload.add_part(@buffer)
      @buffer_size = (@buffer_size * S3Stream::BUFFER_GROWTH_FACTOR).to_i
      @buffer.clear
      @chunk += 1
      nil
    end

    def log(msg)
      unless @log.nil?
        @log.puts(msg)
        @log.flush
      end
    end
  end
end