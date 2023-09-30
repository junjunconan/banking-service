# frozen_string_literal: true

require 'spec_helper'

describe Infra::Repositories::BankAccountRepository do
  let(:account_number) { '1111234522226789' }
  let(:balance) { 500000 }
  let(:bank_account) { Domain::BankAccount.new(account_number: account_number, balance: balance) }

  subject { Infra::Repositories::BankAccountRepository.new }

  describe '#save' do
    context 'save new record' do
      it 'should return a saved record with a uuid' do
        saved_record = subject.save(bank_account)

        expect(saved_record).not_to be_nil
        expect(saved_record.uuid).not_to be_nil
        expect(saved_record.account_number).to eq account_number
        expect(saved_record.balance).to eq balance
      end
    end

    context 'save existing record' do
      it 'should return an updated record with the updated balance' do
        saved_record = subject.save(bank_account)
        saved_record.balance = 300000

        updated_record = subject.save(saved_record)

        expect(updated_record).not_to be_nil
        expect(updated_record.uuid).not_to be_nil
        expect(updated_record.account_number).to eq account_number
        expect(updated_record.balance).to eq 300000
      end
    end

    context 'save a record but not found in database' do
      let(:bank_account) { Domain::BankAccount.new(uuid: 'wrong_uuid', account_number: account_number, balance: balance) }

      it 'should raise an error' do
        expect { subject.save(bank_account) }.to raise_error(StandardError, 'Record not found')
      end
    end
  end

  describe '#find_by' do
    before { subject.save(bank_account) }

    shared_examples 'should return the record' do |attrs|
      it do
        record = subject.find_by(attrs)

        expect(record).not_to be_nil
        expect(record.uuid).not_to be_nil
        expect(record.account_number).to eq account_number
        expect(record.balance).to eq balance
      end
    end

    shared_examples 'should return nil' do |attrs|
      it { expect(subject.find_by(attrs)).to be_nil }
    end

    it_behaves_like 'should return the record', account_number: '1111234522226789'
    it_behaves_like 'should return the record', balance: 500000
    it_behaves_like 'should return the record', account_number: '1111234522226789', balance: 500000

    it_behaves_like 'should return nil', account_number: 'wrong_account_number'
    it_behaves_like 'should return nil', balance: 300000
    it_behaves_like 'should return nil', account_number: '1111234522226789', balance: 300000
  end
end
