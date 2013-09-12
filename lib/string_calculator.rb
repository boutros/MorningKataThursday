class StringCalculator

	def initialize(logger)
		@logger = logger
	end

	def add(numbers)
		sum = calculate_sum(prepare_numbers(numbers))
		@logger.write("got #{sum}")
		sum
	end

	private

	def prepare_numbers(input)
		input.gsub(/[^0-9\-]/, ",")
		     .split(",")
		     .map { |e| e.to_i }
		     .reject { |n| n > 1000 }
	end

	def calculate_sum(numbers)
		if numbers.any? { |n| n < 0 }
			raise "negatives not allowed: #{numbers.select { |n| n < 0}.join(', ')}" 
		end

		numbers.inject(0) { |r,e| r+=e.to_i }
	end

end