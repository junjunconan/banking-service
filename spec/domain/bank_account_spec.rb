# frozen_string_literal: true

require 'spec_helper'

describe Domain::BankAccount do
  let(:uuid) { 'uuid' }
  let(:account_number) { '1111234522226789' }
  let(:balance) { 500000 }

  describe '.initialize_from_csv' do
    let(:csv_row) { [account_number, '5000.00'] }

    it 'should be initialized with account_number and balance' do
      bank_account = Domain::BankAccount.initialize_from_csv(csv_row)

      expect(bank_account.account_number).to eq account_number
      expect(bank_account.balance).to eq 500000
    end
  end

  subject { Domain::BankAccount.new(uuid: uuid, account_number: account_number, balance: balance) }

  describe '#new_record?' do
    context 'new record' do
      let(:uuid) { nil }

      it { expect(subject.new_record?).to eq true }
    end

    context 'existing record' do
      let(:uuid) { 'some_uuid' }

      it { expect(subject.new_record?).to eq false }
    end
  end

  describe '#valid?' do
    context 'valid' do
      it do
        expect(subject.valid?).to eq true
        expect(subject.errors).to be_empty
      end
    end

    shared_examples 'account_number is not valid' do
      it do
        expect(subject.valid?).to eq false
        expect(subject.errors).to eq ['Account number should be 16 digits']
      end
    end
    
    it_behaves_like 'account_number is not valid' do
      let(:account_number) { '12345678901234567' }
    end

    it_behaves_like 'account_number is not valid' do
      let(:account_number) { '123456789012345' }
    end

    it_behaves_like 'account_number is not valid' do
      let(:account_number) { '12345678901234ab' }
    end

    it_behaves_like 'account_number is not valid' do
      let(:account_number) { '12345678901234+-' }
    end
  end

  describe '#withdraw' do
    context 'insufficient balance' do
      it do
        expect(subject.withdraw(balance + 1)).to eq false
        expect(subject.balance).to eq balance
        expect(subject.errors).to eq ['Insufficient balance']
      end
    end

    context 'sufficient balance' do
      it do
        expect(subject.withdraw(balance)).to eq true
        expect(subject.balance).to eq 0
        expect(subject.errors).to be_empty
      end
    end
  end

  describe '#deposit' do
    it do
      expect(subject.deposit(10000)).to eq true
      expect(subject.balance).to eq balance + 10000
    end
  end
end
