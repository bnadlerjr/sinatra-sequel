# frozen_string_literal: true

require 'logger'
require 'sequel'
require 'sinatra/base'
require_relative 'sequel/migrator'
require_relative 'sequel/version'

module Sinatra # rubocop:disable Style/Documentation
  # Sinatra extension that adds Sequel ORM features.
  #
  module SequelExtension
    # These helpers are added to the Sinatra application.
    #
    module Helpers
      def database
        settings.database
      end
    end

    def self.registered(app)
      app.helpers SequelExtension::Helpers
      app.set :database_migrations_path, File.join('db', 'migrate')
    end

    def database=(url, options={})
      @database = nil
      set :database_url, url
      set :database_options, options
      database
    end

    def database
      @database ||= ::Sequel.connect(database_url, database_options).tap do |db|
        Sinatra::Sequel::Migrator.new(db, database_migrations_path).check!
        db.freeze unless 'development' == environment.to_s
      end
    end
  end

  register SequelExtension
end
