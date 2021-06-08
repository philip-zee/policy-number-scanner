# frozen_string_literal: true

module PolicyOcr
  class Validator
    attr_accessor :account_number

    def initialize(account_number)
      @account_number = account_number
    end

    def valid?
      valid_check_sum?
    end

    def valid_check_sum?
      sum = account_number.split('').reverse
                          .each_with_index.map { |num, index| (index + 1) * num.to_i }.sum
      (sum % 11).zero?
    end
  end
end
