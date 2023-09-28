# frozen_string_literal: true

require 'spec_helper'

describe Application::Commands::Transfer do
  let(:data_parser) { double('data_parser') }
  let(:banking_service) { double('banking_service') }

  subject { Application::Commands::Transfer.new(data_parser: data_parser, banking_service: banking_service) }

  describe '#execute' do
    let(:transaction_1) { double('Domains::Transaction') }
    let(:transaction_2) { double('Domains::Transaction') }
    let(:transactions) { [transaction_1, transaction_2] }

    it do
      expect(data_parser).to receive(:parse).and_return(transactions)
      expect(banking_service).to receive(:transfer_funds).with(transaction_1).once.and_return([transaction_1])
      expect(banking_service).to receive(:transfer_funds).with(transaction_2).once.and_return([false, 'error'])
      expect(subject.execute).to eq [transaction_1]
    end
  end
end
