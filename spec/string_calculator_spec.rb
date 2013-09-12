require_relative "../lib/string_calculator"
require_relative "../lib/logger"
require "bogus/rspec"

describe StringCalculator do
	subject(:calc) { StringCalculator.new(logger) }
	let(:logger) { fake(:logger) }

	describe ".add" do
		def adding(numbers)
			calc.add(numbers)
		end

		context "empty string" do
			specify { adding("").should == 0 }
		end

		context "single number" do
			specify { adding("1").should == 1 }
			specify { adding("10").should == 10 }
		end

		context "multiple numbers" do
			specify { adding("1,2").should == 3 }
			specify { adding("1,2,3").should == 6 }

			it "logs the sum" do
				adding("1,2")
				logger.should have_received.write("got 3")
			end
		end

		context "multi-line input" do
			specify { adding("1\n2,3").should == 6 }
			specify { adding("1\n2\n3,4").should == 10 }
		end	

		context "different delimiters" do
			specify { adding("//;\n1;2").should == 3 }
			specify { adding("//*\n1*2").should == 3 }
			specify { adding("//[***]\n1***2***3").should == 6 }
		end

		context "multiple delimiters" do
			specify { adding("//[*][%]\n1*2%3").should == 6 }
			specify { adding("//[**][???]\n1???2\n3**0").should == 6 }
		end

		context "negative numbers" do
			it "raises an error" do
				expect { adding("-1") }.to raise_error
			end

			it "returns the negative numbers" do
				expect { adding("-1") }.to raise_error("negatives not allowed: -1")
				expect { adding("-1,-2") }.to raise_error("negatives not allowed: -1, -2")
			end
		end

		context "numbers over 1000" do
			specify { adding("1001, 2").should == 2 }
		end

	end
end