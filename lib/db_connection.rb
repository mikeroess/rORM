require 'sqlite3'

PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'
ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')
BOOKS_SQL_FILE = File.join(ROOT_FOLDER, 'books.sql')
BOOKS_DB_FILE = File.join(ROOT_FOLDER, 'books.db')

class DBConnection
  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    commands = [
      "rm '#{BOOKS_DB_FILE}'",
      "cat '#{BOOKS_SQL_FILE}' | sqlite3 '#{BOOKS_DB_FILE}'"
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open(BOOKS_DB_FILE)
  end

  def self.instance
    reset if @db.nil?

    @db
  end

  def self.execute(*args)
    instance.execute(*args)
  end

  # always returns column names as first row
  def self.execute2(*args)
    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end
end
