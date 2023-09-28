# frozen_string_literal: true

module Domains
  class BankAccount
    attr_accessor :uuid, :account_number, :balance, :errors

    def initialize(attrs)
      @uuid = attrs[:uuid]
      @account_number = attrs[:account_number]
      @balance = attrs[:balance]
      @errors = []
    end

    def self.initialize_from_csv(array)
      # balance in cents
      new(account_number: array[0], balance: (array[1].to_f * 100).to_i)
    end

    def new_record?
      uuid.nil?
    end

    def valid?
      unless account_number.to_s.match(/^\d{16}$/)
        errors << 'Account number should be 16 digits'
      end
      
      errors.empty?
    end

    def withdraw(amount)
      if @balance < amount
        errors << 'Insufficient balance'
        return false
      end

      @balance -= amount
      true
    end

    def deposit(amount)
      @balance += amount
      true
    end
  end
end
