require_relative 'db_connection'
require 'active_support/inflector'
require_relative 'associatable'
require_relative 'searchable'

class SQLObject
  include ActiveSupport

  def self.all
    call = DBConnection.execute(<<-SQL)
    SELECT
      "#{self.table_name}".*
    FROM
      "#{self.table_name}"
    SQL
    self.parse_all(call)
  end

  def self.find(id)
    record = self.get_record(id)
    record.empty? ? nil : self.new(record.first)
  end

  def initialize(params = {})
    self.class.finalize!
    keys = params.keys.map { |key| key.to_sym}
    cols = self.class.columns

    keys.each { |key| raise "unknown attribute '#{key}'" unless self.class.columns.include?(key) }
    params.each { |key, value|  self.send("#{key}=", value) }
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    values = []
    self.class.columns.each do |column|
      values << self.send(column)
    end

    values
  end

  def insert
    column_names = self.class.columns.drop(1).join(", ")
    question_marks = (["?"] * (self.class.columns.length - 1)).join(", ")

    insert_record(column_names, question_marks)
    self.id = DBConnection.last_insert_row_id
  end

  def update
    column_names = self.class.columns.drop(1).join(" = ?, ")
    column_names += " = ?"

    vals = attribute_values
    vals = vals.push(vals.shift)
    update_record(column_names, vals)
  end

  def save
    self.id ? self.update : self.insert
  end

  private

  def self.finalize!
    self.columns.each do |column|
      define_method(column) { self.attributes[column] }
      define_method("#{column}=") { |val| self.attributes[column] = val }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ? @table_name : ActiveSupport::Inflector.tableize(self.name)
  end

  def self.columns
    @cols ||= self.get_column_names
    @cols.first.map { |col_name| col_name = col_name.to_sym }
  end

  def self.parse_all(results)
    results.map { |result| self.new(result) }
  end

  def self.get_column_names
    @cols ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        "#{self.table_name}"
      WHERE
        null
    SQL
  end

  def self.get_record(id)
    record = DBConnection.execute(<<-SQL, id)
    SELECT
      "#{self.table_name}".*
    FROM
      "#{self.table_name}"
    WHERE
      "#{self.table_name}".id = ?
    SQL
  end

  def insert_record(column_names, question_marks)
    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
    INSERT INTO
      "#{self.class.table_name}" (#{column_names})
    VALUES
      (#{question_marks})
    SQL
  end

  def update_record(column_names, vals)
    DBConnection.execute(<<-SQL, *vals)
     UPDATE
       #{self.class.table_name}
     SET
       #{column_names}
     WHERE
       id = ?
      SQL
  end

end
