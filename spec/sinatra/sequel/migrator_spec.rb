# frozen_string_literal: true

RSpec.describe Sinatra::Sequel::Migrator do
  subject(:migrator) { described_class.new(database, migrations_path) }

  let(:log_output) { StringIO.new }
  let(:database) { Sequel.connect('sqlite:///', loggers: [Logger.new(log_output)]) }

  describe '#check!' do
    context 'when there are migration files' do
      let(:migrations_path) { File.join(fixtures_path, 'migrations') }

      context 'and migrations are pending' do
        before { migrator.check! }

        it 'runs any pending migrations' do
          expect(database[:schema_info].count).to eq(1)
        end

        it 'logs migration messages' do
          log_output.rewind
          expect(log_output.readlines).to \
            include(
              /Pending migrations detected/,
              /Begin applying migration/,
              /Database migrations completed/
            )
        end
      end

      context 'and migrations are current' do
        before do
          ::Sequel.extension :migration
          Sequel::Migrator.run(database, migrations_path)
          migrator.check!
        end

        it 'does not perform migrations' do
          expect(database[:schema_info].count).to eq(1)
        end

        it 'does not log migration messages' do
          log_output.rewind
          expect(log_output.readlines).not_to \
            include(
              /Pending migrations detected/,
              /Database migrations completed/
            )
        end
      end
    end

    context 'when no migration files exist' do
      let(:migrations_path) { File.join(fixtures_path, 'no_migrations') }

      before { migrator.check! }

      it 'does nothing' do
        expect(database.tables).not_to include(:schema_info)
      end

      it 'does not log migration messages' do
        log_output.rewind
        expect(log_output.readlines).not_to \
          include(
            /Pending migrations detected/,
            /Database migrations completed/
          )
      end
    end
  end

  describe '#migrate!' do
    context 'when there are migration files' do
      let(:migrations_path) { File.join(fixtures_path, 'migrations') }

      it 'runs any pending migrations' do
        migrator.migrate!
        expect(database[:schema_info].count).to eq(1)
      end

      it 'does nothing when the migrations are current' do
        ::Sequel.extension :migration
        Sequel::Migrator.run(database, migrations_path)
        migrator.migrate!
        expect(database[:schema_info].count).to eq(1)
      end
    end

    context 'when no migration files exist' do
      let(:migrations_path) { File.join(fixtures_path, 'no_migrations') }

      it 'does nothing' do
        migrator.migrate!
        expect(database.tables).not_to include(:schema_info)
      end
    end
  end

  describe '#reset!' do
    context 'when there are migration files' do
      let(:migrations_path) { File.join(fixtures_path, 'migrations') }

      it 'resets the database when the migrations are not current' do
        migrator.reset!
        expect(database[:schema_info].count).to eq(1)
      end

      it 'resets the database when the migrations are current' do
        ::Sequel.extension :migration
        Sequel::Migrator.run(database, migrations_path)
        migrator.reset!
        expect(database[:schema_info].count).to eq(1)
      end
    end

    context 'when no migration files exist' do
      let(:migrations_path) { File.join(fixtures_path, 'no_migrations') }

      it 'does nothing' do
        migrator.reset!
        expect(database.tables).not_to include(:schema_info)
      end
    end
  end
end
