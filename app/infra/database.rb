# frozen_string_literal: true

module Infra
  class Database
    attr_reader :bank_accounts, :transactions

    def initialize
      @bank_accounts = []
      @transactions = []
    end

    @instance = new

    private_class_method :new
    
    def self.instance
      @instance
    end

    def self.clear
      @instance = new
    end

    def insert_record(attrs, table)
      table = Database.instance.send(table)
      raise StandardError.new('Table not found') if table.nil?

      table << attrs
      attrs
    end

    def update_record(attrs, table)
      table = Database.instance.send(table)
      raise StandardError.new('Table not found') if table.nil?

      index = table.find_index { |existing_record| existing_record[:uuid] == attrs[:uuid] }
      raise StandardError.new('Record not found') if index.nil?

      table[index] = attrs
    end

    def find_record_by(attrs, table)
      table = Database.instance.send(table)
      raise StandardError.new('Table not found') if table.nil?

      table.find { |record| record >= (attrs || {}) }
    end
  end
end
