# frozen_string_literal: true

RSpec.describe Sinatra::Sequel do
  it 'has a version number' do
    expect(Sinatra::Sequel::VERSION).not_to be_nil
  end

  describe '#database' do
    let(:app) { build_mock_app }

    it 'returns a Sequel database' do
      expect(app.database).to be_a(Sequel::SQLite::Database)
    end

    it 'runs any pending migrations' do
      expect(app.database.table_exists?(:schema_info)).to be(true)
    end

    it 'freezes the database' do
      # https://sequel.jeremyevans.net/rdoc/files/doc/code_order_rdoc.html
      expect(app.database.frozen?).to be(true)
    end

    context 'when the development environment is active' do
      it 'does not freeze the database' do
        app = build_mock_app(:development)
        expect(app.database.frozen?).to be(false)
      end
    end
  end
end
