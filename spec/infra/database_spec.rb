# frozen_string_literal: true

require 'spec_helper'

describe Infra::Database do
  describe '.instance' do
    it 'should return the same instance' do
      instance_1 = Infra::Database.instance
      instance_2 = Infra::Database.instance

      expect(instance_1).to be(instance_2)
    end
  end

  describe '.clear' do
    it 'should clear and re-initialize the instance' do
      instance_1 = Infra::Database.instance
      Infra::Database.clear
      instance_2 = Infra::Database.instance

      expect(instance_1).not_to be(instance_2)
    end
  end

  describe '#insert_record' do
    let(:database) { Infra::Database.instance }
    let(:attrs) { { uuid: 'uuid' } }

    it 'should insert a record to the table' do
      database.insert_record(attrs, :bank_accounts)
      expect(database.bank_accounts).to eq [attrs]
    end

    it 'should raise an error when table is not found' do
      expect { database.insert_record(attrs, :non_existing_table) }.to raise_error(StandardError, 'Table not found')
    end
  end

  describe '#update_record' do
    let(:database) { Infra::Database.instance }
    let(:attrs) { { uuid: 'uuid', name: 'name' } }

    before { database.bank_accounts << { uuid: 'uuid' } }

    it 'should update the record' do
      database.update_record(attrs, :bank_accounts)
      expect(database.bank_accounts).to eq [attrs]
    end

    it 'should raise an error when record is not found' do
      expect { database.update_record({ uuid: 'wrong_uuid' }, :bank_accounts) }.to raise_error(StandardError, 'Record not found')
    end

    it 'should raise an error when table is not found' do
      expect { database.update_record(attrs, :non_existing_table) }.to raise_error(StandardError, 'Table not found')
    end
  end

  describe '#find_record_by' do
    let(:database) { Infra::Database.instance }
    let(:attrs) { { uuid: 'uuid' } }

    before { database.bank_accounts << attrs }

    it 'should find the record' do
      expect(database.find_record_by(attrs, :bank_accounts)).to eq attrs
    end

    it 'should return nil' do
      expect(database.find_record_by({ uuid: 'another_uuid' }, :bank_accounts)).to be_nil
    end

    it 'should raise an error when table is not found' do
      expect { database.find_record_by(attrs, :non_existing_table) }.to raise_error(StandardError, 'Table not found')
    end
  end
end
