require "./spec_helper"

def read_as_array(filename)
  lines = [] of String
  File.each_line(filename) { |line|
    lines << line.chomp
  }
  return lines
end

describe Stemmer do
  # TODO: Write tests

  it "should stem input to output" do
    input_words  = read_as_array("spec/fixtures/input.txt")
    output_words = read_as_array("spec/fixtures/output.txt")

    input_words.size().times do |i|
      input_words[i].stem.should eq output_words[i]
    end  
  end
end
