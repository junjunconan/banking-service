# frozen_string_literal: true

require 'spec_helper'

describe Application::BankingService do
  let(:from_account) { '1111234522226789' }
  let(:to_account) { '1234567890123456' }
  let(:amount) { 500000 }
  let(:transaction) { Domain::Transaction.new(from_account: from_account, to_account: to_account, amount: amount) }
  let(:bank_account_repository) { double('Infra::Repositories::BankAccountRepository') }
  let(:transaction_repository) { double('Infra::Repositories::TransactionRepository') }
  let(:mock_from_account) { double('Domain::BankAccount') }
  let(:mock_to_account) { double('Domain::BankAccount') }

  subject { Application::BankingService.new(bank_account_repository: bank_account_repository, transaction_repository: transaction_repository) }

  describe '#transfer_funds' do
    before do
      expect(bank_account_repository).to receive(:find_by).with(account_number: from_account).and_return(mock_from_account)
      expect(bank_account_repository).to receive(:find_by).with(account_number: to_account).and_return(mock_to_account)
    end

    shared_examples 'account not found' do
      it do
        result, error = subject.transfer_funds(transaction)
        expect(result).to eq false
        expect(error).to eq 'Account not found'
      end
    end
    
    it_behaves_like 'account not found' do
      let(:mock_from_account) { nil }
    end

    it_behaves_like 'account not found' do
      let(:mock_to_account) { nil }
    end

    context 'insufficient balance' do
      it do
        expect(mock_from_account).to receive(:withdraw).with(transaction.amount).and_return(false)
        expect(mock_from_account).to receive(:errors).and_return(['Insufficient balance'])
  
        result, error = subject.transfer_funds(transaction)
        expect(result).to eq false
        expect(error).to eq 'Insufficient balance'
      end
    end

    context 'success' do
      it do
        expect(mock_from_account).to receive(:withdraw).with(transaction.amount).and_return(true)
        expect(mock_to_account).to receive(:deposit).with(transaction.amount).and_return(true)
        expect(bank_account_repository).to receive(:save).with(mock_from_account)
        expect(bank_account_repository).to receive(:save).with(mock_to_account)
        expect(transaction_repository).to receive(:save).with(transaction).and_return(transaction)
  
        result, error = subject.transfer_funds(transaction)
        expect(result).to eq transaction
        expect(error).to be_nil
      end
    end
  end
end
