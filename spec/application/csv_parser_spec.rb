# frozen_string_literal: true

require 'spec_helper'

describe Application::CsvParser do
  describe '#parse' do
    let(:csv_rows) { [['row1'], ['row2']] }

    shared_examples 'initialize domain objects from csv' do |model:|
      it do
        expect(CSV).to receive(:read).with('file_path').and_return(csv_rows)
        expect(model).to receive(:initialize_from_csv).exactly(csv_rows.count).times

        Application::CsvParser.new(file_path: 'file_path', model: model).parse
      end
    end
    
    it_behaves_like 'initialize domain objects from csv', model: Domain::BankAccount
    it_behaves_like 'initialize domain objects from csv', model: Domain::Transaction
  end
end
