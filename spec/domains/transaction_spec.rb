# frozen_string_literal: true

require 'spec_helper'

describe Domains::Transaction do
  let(:uuid) { 'uuid' }
  let(:from_account) { '1111234522226789' }
  let(:to_account) { '1234567890123456' }
  let(:amount) { 500000 }

  describe '.initialize_from_csv' do
    let(:csv_row) { [from_account, to_account, '5000.00'] }

    it 'should be initialized with from_account, to_account and amount' do
      transaction = Domains::Transaction.initialize_from_csv(csv_row)

      expect(transaction.from_account).to eq from_account
      expect(transaction.to_account).to eq to_account
      expect(transaction.amount).to eq 500000
    end
  end

  describe '#new_record?' do
    subject { Domains::Transaction.new(uuid: uuid, from_account: from_account, to_account: to_account, amount: amount) }

    context 'new record' do
      let(:uuid) { nil }

      it { expect(subject.new_record?).to eq true }
    end

    context 'existing record' do
      let(:uuid) { 'some_uuid' }

      it { expect(subject.new_record?).to eq false }
    end
  end
end
