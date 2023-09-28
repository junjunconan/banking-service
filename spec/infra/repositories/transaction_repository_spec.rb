# frozen_string_literal: true

require 'spec_helper'

describe Infra::Repositories::TransactionRepository do
  let(:from_account) { '1111234522226789' }
  let(:to_account) { '1234567890123456' }
  let(:amount) { 500000 }
  let(:transaction) { Domains::Transaction.new(from_account: from_account, to_account: to_account, amount: amount) }

  subject { Infra::Repositories::TransactionRepository.new }

  describe '#save' do
    context 'save new record' do
      it 'should return a saved record with a uuid' do
        saved_record = subject.save(transaction)

        expect(saved_record).not_to be_nil
        expect(saved_record.uuid).not_to be_nil
        expect(saved_record.from_account).to eq from_account
        expect(saved_record.to_account).to eq to_account
        expect(saved_record.amount).to eq amount
      end
    end

    context 'save existing record' do
      it 'should return an updated record with the updated amount' do
        saved_record = subject.save(transaction)
        saved_record.amount = 300000

        updated_record = subject.save(saved_record)

        expect(updated_record).not_to be_nil
        expect(updated_record.uuid).not_to be_nil
        expect(updated_record.from_account).to eq from_account
        expect(updated_record.to_account).to eq to_account
        expect(updated_record.amount).to eq 300000
      end
    end

    context 'save a record but not found in database' do
      let(:transaction) { Domains::Transaction.new(uuid: 'wrong_uuid', from_account: from_account, to_account: to_account, amount: amount) }

      it 'should raise an error' do
        expect { subject.save(transaction) }.to raise_error(StandardError, 'Record not found')
      end
    end
  end
end
