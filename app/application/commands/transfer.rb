# frozen_string_literal: true

module Application
  module Commands
    class Transfer
      def initialize(data_parser:, banking_service: Application::BankingService.new)
        @data_parser = data_parser
        @banking_service = banking_service
      end

      def execute
        transactions = @data_parser.parse
        loaded_transactions = []

        transactions.each_with_index do |transaction, index|
          result, error = @banking_service.transfer_funds(transaction)

          if result
            loaded_transactions << result
          else
            puts "Error at row #{index + 1}: #{error}"
          end
        end

        puts 'Completed loading transactions'

        loaded_transactions
      end
    end
  end
end
