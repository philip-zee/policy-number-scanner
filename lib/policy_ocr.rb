# frozen_string_literal: true

require './lib/validator'

module PolicyOcr
  ONE = '     |  |'
  TWO = ' _  _||_ '
  THREE = ' _  _| _|'
  FOUR = '   |_|  |'
  FIVE = ' _ |_  _|'
  SIX = ' _ |_ |_|'
  SEVEN = ' _   |  |'
  EIGHT = ' _ |_||_|'
  NINE = ' _ |_| _|'
  ZERO = ' _ | ||_|'
  NUMBER_KEY = { ONE => 1, TWO => 2, THREE => 3, FOUR => 4, FIVE => 5,
                 SIX => 6, SEVEN => 7, EIGHT => 8, NINE => 9, ZERO => 0 }.freeze

  class Handler
    attr_accessor :parsed_numbers, :file_path

    def initialize(file_path)
      @file_path = file_path
      @parsed_numbers = []
    end

    def report_numbers
      parse_file
      parsed_numbers.map(&:join)
    end

    def parse_file
      File.open(file_path, 'r').each_line.each_slice(4) do |slice|
        slice.pop
        combined_line = slice.map { |line| line.scan(/.../) }.transpose
        parsed_numbers << combined_line.map { |stencil| NUMBER_KEY[stencil.join] }
      end
    end
  end
end
