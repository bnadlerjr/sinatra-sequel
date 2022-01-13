# frozen_string_literal: true

module Sinatra
  module Sequel
    # Facade for `Sequel::Migrator`.
    #
    class Migrator
      attr_reader :migrations_path, :database

      def initialize(database, migrations_path)
        ::Sequel.extension :migration
        @migrations_path = migrations_path
        @database = database
      end

      # Checks for pending migrations and runs them if necessary.
      #
      def check!
        return unless migration_files?
        return if run_command(:is_current?)

        write_to_log(:info, 'Pending migrations detected... running migrations')
        migrate!
        write_to_log(:info, 'Database migrations completed')
      end

      # Runs database migrations.
      #
      def migrate!
        return unless migration_files?

        run_command(:run)
      end

      # Performs migration reset (full erase and migration up).
      #
      def reset!
        return unless migration_files?

        run_command(:run, target: 0)
        migrate!
      end

      private

      def migration_files_glob_pattern
        File.join(migrations_path, '*.rb')
      end

      def write_to_log(level, message)
        database.loggers.each { |logger| logger.send(level, message) }
      end

      def run_command(method, opts={})
        ::Sequel::Migrator.public_send(method, database, migrations_path, opts)
      end

      def migration_files?
        !Dir.glob(migration_files_glob_pattern).empty?
      end
    end
  end
end
