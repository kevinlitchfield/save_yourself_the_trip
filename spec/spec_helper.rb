require "bundler/setup"
require 'active_record'
require 'sqlite3'

ActiveRecord::Base.establish_connection({
  adapter: 'sqlite3',
  database: 'save_yourself_the_trip_test.db',
})

class CreateTables < ActiveRecord::Migration[5.0]
  def change
    unless ActiveRecord::Base.connection.data_source_exists?('buildings')
      create_table :buildings do |t|
        t.string :address
      end
    end

    unless ActiveRecord::Base.connection.data_source_exists?('apartments')
      create_table :apartments do |t|
        t.belongs_to :building
      end
    end
  end
end

unless ActiveRecord::Base.connection.data_source_exists?('buildings') && ActiveRecord::Base.connection.data_source_exists?('buildings')
  CreateTables.migrate(:up)
end

class Building < ActiveRecord::Base
  has_many :apartments
end

class Apartment < ActiveRecord::Base
  belongs_to :building
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after(:each, type: :spec_type) do
    Building.delete_all
    Apartment.delete_all
  end
end

require "save_yourself_the_trip"
