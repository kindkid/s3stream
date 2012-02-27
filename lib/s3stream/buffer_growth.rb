module S3Stream
  class BufferGrowth
  
    EPSILON = 1.0e-16

    def initialize(initial_buffer_size, max_file_size, max_chunks)
      @max_chunks = max_chunks
      @max_file_size = max_file_size
      @initial_buffer_size = initial_buffer_size
    end

    def solve
      lower_bound = 1.0
      upper_bound = 1.0
      upper_bound *= 2.0 until too_big?(upper_bound)
      begin
        puts "bounds: #{[lower_bound, upper_bound]}"
        return lower_bound if (upper_bound - lower_bound) < EPSILON
        guess = (lower_bound + upper_bound) / 2.0
        return lower_bound if [lower_bound,upper_bound].include?(guess)
        if too_big?(guess)
          upper_bound = guess
        else
          lower_bound = guess
        end
      end while true
    end

    private

    def too_big?(growth_factor)
      total = 0
      buffer_size = @initial_buffer_size
      (1..@max_chunks).each do
        total += buffer_size
        buffer_size = (buffer_size * growth_factor).to_i
        return true if total > @max_file_size
      end
      false
    end
  end
end