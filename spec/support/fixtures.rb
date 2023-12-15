module Fixtures
  class << self
    def rb(fixture_file)
      path = Rails.root.join('data', 'fixtures', "#{fixture_file}.rb")
      eval(File.read(path)) # rubocop:disable Security/Eval
    end

    def json(fixture_file)
      contents = fixture_content(fixture_file)
      JSON.parse contents
    end

    def fixture_content(fixture_file)
      path = Rails.root.join('data', 'fixtures', "#{fixture_file}.json")
      IO.read path
    end
  end
end
