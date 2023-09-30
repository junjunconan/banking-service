# frozen_string_literal: true

module Infra
  module Repositories
    class BankAccountRepository
      def initialize(db: Infra::Database.instance)
        @db = db
      end

      def save(bank_account)
        attrs_to_save = {
          uuid: bank_account.uuid,
          account_number: bank_account.account_number,
          balance: bank_account.balance
        }

        result = if bank_account.new_record?
                   @db.insert_record(attrs_to_save.merge(uuid: SecureRandom.uuid), :bank_accounts)
                 else
                   @db.update_record(attrs_to_save, :bank_accounts)
                 end

        Domain::BankAccount.new(result) unless result.nil?
      end

      def find_by(attrs)
        result = @db.find_record_by(attrs, :bank_accounts)
        Domain::BankAccount.new(result) unless result.nil?
      end
    end
  end
end
