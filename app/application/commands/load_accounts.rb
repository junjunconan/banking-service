# frozen_string_literal: true

module Application
  module Commands
    class LoadAccounts
      def initialize(data_parser:, repository: Infra::Repositories::BankAccountRepository.new)
        @data_parser = data_parser
        @repository = repository
      end

      def execute
        bank_accounts = @data_parser.parse
        loaded_accounts = []

        bank_accounts.each_with_index do |bank_account, index|
          if bank_account.valid?
            loaded_accounts << @repository.save(bank_account)
          else
            puts "Error at row #{index + 1}: #{bank_account.errors.join(', ')}"
          end
        end

        puts 'Completed loading accounts'

        loaded_accounts
      end
    end
  end
end
