# frozen_string_literal: true

module Application
  class CommandManager
    def parse(input)
      command, argument = input.to_s.split(' ')

      case command
      when /^loadaccounts$/i
        Commands::LoadAccounts.new(data_parser: CsvParser.new(file_path: argument, model: Domains::BankAccount))
      when /^getbalance$/i
        Commands::GetBalance.new(account_number: argument)
      when /^transfer$/i
        Commands::Transfer.new(data_parser: CsvParser.new(file_path: argument, model: Domains::Transaction))
      end
    end
  end
end
