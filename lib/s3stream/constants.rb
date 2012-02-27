module S3Stream
  KB = 1024
  MB = 1024 * KB
  GB = 1024 * MB
  TB = 1024 * GB

  MAX_CHUNKS = 10_000
  MAX_FILE_SIZE = 5 * TB
  INITIAL_BUFFER_SIZE = 5 * MB

  BUFFER_GROWTH_FACTOR = 1.0006533241143831
  #BUFFER_GROWTH_FACTOR = begin
  #  require 's3stream/buffer_growth'
  #  BufferGrowth.new(INITIAL_BUFFER_SIZE, MAX_FILE_SIZE, MAX_CHUNKS).solve
  #end
end