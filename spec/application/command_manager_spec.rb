# frozen_string_literal: true

require 'spec_helper'

describe Application::CommandManager do
  let(:data_parser) { double('data_parser') }

  subject { Application::CommandManager.new }

  describe '#parse' do
    context 'loadaccounts command' do
      it do
        expect(Application::CsvParser).to receive(:new).with(file_path: 'file_path', model: Domains::BankAccount).and_return(data_parser)
        expect(Application::Commands::LoadAccounts).to receive(:new).with(data_parser: data_parser)

        subject.parse('loadaccounts file_path')
      end
    end

    context 'getbalance command' do
      it do
        expect(Application::Commands::GetBalance).to receive(:new).with(account_number: '1234567890123456')

        subject.parse('getbalance 1234567890123456')
      end
    end

    context 'transfer command' do
      it do
        expect(Application::CsvParser).to receive(:new).with(file_path: 'file_path', model: Domains::Transaction).and_return(data_parser)
        expect(Application::Commands::Transfer).to receive(:new).with(data_parser: data_parser)

        subject.parse('transfer file_path')
      end
    end

    context 'invalid command' do
      it { expect(subject.parse('invalidcommand')).to be_nil }
      it { expect(subject.parse('')).to be_nil }
      it { expect(subject.parse(nil)).to be_nil }
    end
  end
end
