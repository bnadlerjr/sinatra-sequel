# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
namespace :db do
  Sequel::DATABASES.first
  migrations_path = File.join('db', 'migrate')
  migrator = Sinatra::Sequel::Migrator.new(db, migrations_path)

  desc 'Migrate the database to latest version'
  task :migrate do
    migrator.migrate!
    puts '<= db:migrate executed'
  end

  desc 'Perform migration reset (full erase and migration up)'
  task :reset do
    migrator.reset!
    puts '<= db:reset executed'
  end

  desc 'Create a new migration file'
  task :create_migration do
    ARGV.each do |a|
      # When we run 'rake db:create_migration create_users', rake will also
      # try to run 'rake create_users'. To avoid a rake abort error, we define
      # an empty method for these (ie: "task :create_users do ; end")
      next if a.nil?

      # rubocop:disable Lint/EmptyBlock, Style/BlockDelimiters
      # rubocop:disable Rake/Desc, Layout/SpaceBeforeSemicolon
      task a.to_sym do ; end
      # rubocop:enable Rake/Desc, Layout/SpaceBeforeSemicolon
      # rubocop:enable Lint/EmptyBlock, Style/BlockDelimiters
    end

    name = ARGV[1]
    unless name
      puts 'No NAME specified. Example usage: `rake db:create_migration NAME`'
      exit
    end

    files = Pathname(migrations_path).children
    if (duplicate = files.find { |path| path.basename.to_s.include?(name) })
      puts "Another migration is already named \"#{name}\": #{duplicate}."
      exit
    end

    filename = "#{Time.now.utc.strftime('%Y%m%d%H%M%S')}_#{name}.rb"
    path = File.join(migrations_path, filename)

    text = <<~TEXT
      # frozen_string_literal: true

      # See https://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html
      Sequel.migration do
        change do
        end
      end
    TEXT

    File.write(path, text)
    puts "<= db:create_migration created the file #{path}"
  end
end
# rubocop:enable Metrics/BlockLength
