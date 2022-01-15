# frozen_string_literal: true

module SpecHelpers
  def fixtures_path
    File.join('spec', 'fixtures')
  end

  def build_mock_app(env=:production)
    migrations_path = File.join(fixtures_path, 'migrations')
    Class.new(Sinatra::Base) do
      register Sinatra::SequelExtension

      set :environment, env
      set :database_migrations_path, migrations_path
      set :database, 'sqlite:///'
    end
  end
end
