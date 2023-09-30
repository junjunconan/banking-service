# frozen_string_literal: true

module Domain
  class Transaction
    attr_accessor :uuid, :from_account, :to_account, :amount, :errors

    def initialize(attrs)
      @uuid = attrs[:uuid]
      @from_account = attrs[:from_account]
      @to_account = attrs[:to_account]
      @amount = attrs[:amount]
      @errors = []
    end

    def self.initialize_from_csv(array)
      # amount in cents
      new(from_account: array[0], to_account: array[1], amount: (array[2].to_f * 100).to_i)
    end

    def new_record?
      uuid.nil?
    end
  end
end
