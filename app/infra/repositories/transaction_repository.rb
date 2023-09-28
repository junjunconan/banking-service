# frozen_string_literal: true

module Infra
  module Repositories
    class TransactionRepository
      def initialize(db: Infra::Database.instance)
        @db = db
      end

      def save(transaction)
        attrs_to_save = {
          uuid: transaction.uuid,
          from_account: transaction.from_account,
          to_account: transaction.to_account,
          amount: transaction.amount
        }

        result = if transaction.new_record?
                   @db.insert_record(attrs_to_save.merge(uuid: SecureRandom.uuid), :transactions)
                 else
                   @db.update_record(attrs_to_save, :transactions)
                 end
        
        Domains::Transaction.new(result) unless result.nil?
      end
    end
  end
end
