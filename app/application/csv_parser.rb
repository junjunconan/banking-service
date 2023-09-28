# frozen_string_literal: true

module Application
  class CsvParser
    def initialize(file_path:, model:)
      @file_path = file_path
      @model = model
    end

    def parse
      result = []

      CSV.read(@file_path).each do |row|
        result << @model.initialize_from_csv(row)
      end

      result
    end
  end
end
