# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:articles) do
      primary_key :id
      String :title, null: false
    end
  end
end
