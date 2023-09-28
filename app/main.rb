# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'csv'
require 'securerandom'

require 'application/banking_service'
require 'application/csv_parser'
require 'application/commands/get_balance'
require 'application/commands/load_accounts'
require 'application/commands/transfer'
require 'application/command_manager'
require 'domains/bank_account'
require 'domains/transaction'
require 'infra/repositories/bank_account_repository'
require 'infra/repositories/transaction_repository'
require 'infra/database'

class Main
  def run
    puts 'Please input command (EXIT to quit):'
    puts 'Usage:'
    puts '1. loadaccounts FILE_PATH'
    puts '2. transfer FILE_PATH'
    puts '3. getbalance ACCOUNT_NUMBER'

    manager = Application::CommandManager.new

    loop do
      begin
        input = gets
        manager.parse(input)&.execute
      
        break if input =~ /exit/i
      rescue StandardError => e
        puts e.message
      end
    end
  end
end

Main.new.run
