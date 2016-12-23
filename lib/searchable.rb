require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(conditions_hash)
    where_query = conditions_hash.keys.join(" = ? AND ")
    where_query += " = ?"
    vals = conditions_hash.values

    results = filter_record(vals, where_query)
    parse_all(results)
  end

  private
  def filter_record(vals, where_query)
    DBConnection.execute(<<-SQL, *vals)
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      #{where_query}

    SQL
  end
end

class SQLObject
  extend Searchable
end
