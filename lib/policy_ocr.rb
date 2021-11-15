require 'pry'

module PolicyOcr

    # initializing global variables
    # @file takes in sample.txt, maps and 
    # creates strings for each line, and 
    # chomps(removes) the "\n" by using the to_proc
    # chomp method (.map { | foo | foo.chomp })

    @file = File.readlines("./spec/fixtures/sample.txt").map(&:chomp)
    @lines = @file.size / 4 # taking size of the file (44 lines) divided by 4 (1 ocr)
    @columns = @file.first.size / 3 # taking the size of the first line (27 columns) divided by 3 (1 ocr digit)

    # method for mapping out digits into strings
    # we are creating values for each string pattern
    def self.digits 
        {
            " _ | ||_|   " => '0',
            "     |  |   " => '1',
            " _  _||_    " => '2',
            " _  _| _|   " => '3',
            "   |_|  |   " => '4',
            " _ |_  _|   " => '5',
            " _ |_ |_|   " => '6',
            " _   |  |   " => '7',
            " _ |_||_|   " => '8',
            " _ |_| _|   " => '9'
        }
    end

    # creates a string of the policy number,
    # by injecting the bars and pipes into a
    # string from @file.

    #line equals amount of lines(44) in each ocr_block(11)
    #column equals amount of ocr_columns(9) in each ocr_block(11)

    def self.policy_number(line, column)
        (0..3).inject("") do | ocr_num, sections | 
            ocr_num + @file[line * 4 + sections][column * 3, 3]
        end
    end
    
    # this method takes in an OCR file,
    # and parces the number using exclusive
    # ranges

    def self.conversion(file)
        (0...@lines).inject([]) do | policy_array, line |
            policy_array << numbers(line)
        end.map{ | number_string | number_string.to_i } # turning string to integer
    end

    # call policy_number to inject 
    # digits first into an string,
    # to be called in the conversion method

    def self.numbers(line)
        (0...@columns).inject("") do |digit, column| 
            digit + digits.fetch(policy_number(line, column))
        end
    end

end

# unable to actually receive nine 0s as ruby
# counts multiple int 0s as the value of 
# a single int 0
p PolicyOcr.conversion(@file)

PolicyOcr.conversion(@file).map{ | policy_num | p policy_num } # see each number individually
