# frozen_string_literal: true

require 'spec_helper'

describe Application::Commands::GetBalance do
  let(:balance) { 500000 }
  let(:bank_account) { double('Domain::BankAccount', account_number: '1111234522226789', balance: balance) }
  let(:repository) { double('Infra::Repositories::BankAccountRepository') }
  let(:account_number) { nil }

  subject { Application::Commands::GetBalance.new(account_number: account_number, repository: repository) }

  describe '#execute' do
    context 'account not found' do
      let(:account_number) { '1234567890123456' }

      it 'should return nil' do
        expect(repository).to receive(:find_by).with(account_number: account_number).and_return(nil)
        expect(subject.execute).to be_nil
      end
    end

    context 'success' do
      let(:account_number) { '1111234522226789' }

      it 'should return the account balance' do
        expect(repository).to receive(:find_by).with(account_number: account_number).and_return(bank_account)
        expect(subject.execute).to eq balance
      end
    end
  end
end
