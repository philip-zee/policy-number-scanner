# frozen_string_literal: true

class FileParser
  def initialize(uploaded_file)
    @uploaded_file = uploaded_file
  end

  def parse_file
    @parse_file ||= CSV.open(@uploaded_file.path, headers: false, header_converters: :symbol).map(&:to_h)
  end
end
