# frozen_string_literal: true

module Application
  module Commands
    class GetBalance
      def initialize(account_number:, repository: Infra::Repositories::BankAccountRepository.new)
        @account_number = account_number
        @repository = repository
      end

      def execute
        bank_account = @repository.find_by(account_number: @account_number)

        if bank_account.nil?
          puts 'Bank account not found!'
        else
          puts "Balance: #{bank_account.balance}"
        end

        bank_account&.balance
      end
    end
  end
end
