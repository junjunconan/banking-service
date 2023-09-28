# frozen_string_literal: true

module Application
  class BankingService
    def initialize(bank_account_repository: Infra::Repositories::BankAccountRepository.new, transaction_repository: Infra::Repositories::TransactionRepository.new)
      @bank_account_repository = bank_account_repository
      @transaction_repository = transaction_repository
    end

    def transfer_funds(transaction)
      from_account = @bank_account_repository.find_by(account_number: transaction.from_account)
      to_account = @bank_account_repository.find_by(account_number: transaction.to_account)

      return false, 'Account not found' if from_account.nil? || to_account.nil?
      return false, from_account.errors.join(',') unless from_account.withdraw(transaction.amount)
  
      to_account.deposit(transaction.amount)

      @bank_account_repository.save(from_account)
      @bank_account_repository.save(to_account)
      @transaction_repository.save(transaction)
    end
  end
end
