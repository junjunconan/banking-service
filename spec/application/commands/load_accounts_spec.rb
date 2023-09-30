# frozen_string_literal: true

require 'spec_helper'

describe Application::Commands::LoadAccounts do
  let(:data_parser) { double('data_parser') }
  let(:repository) { double('Infra::Repositories::BankAccountRepository') }

  subject { Application::Commands::LoadAccounts.new(data_parser: data_parser, repository: repository) }

  describe '#execute' do
    let(:bank_account_1) { double('Domain::BankAccount', valid?: true) }
    let(:bank_account_2) { double('Domain::BankAccount', valid?: false, errors: ['error']) }
    let(:bank_accounts) { [bank_account_1, bank_account_2] }

    it do
      expect(data_parser).to receive(:parse).and_return(bank_accounts)
      expect(repository).to receive(:save).with(bank_account_1).once.and_return(bank_account_1)
      expect(bank_account_2).to receive(:errors)
      expect(subject.execute).to eq [bank_account_1]
    end
  end
end
