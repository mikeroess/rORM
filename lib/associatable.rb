require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor :foreign_key, :class_name, :primary_key

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      :foreign_key => "#{name}_id".to_sym,
      :class_name => name.to_s.camelcase,
      :primary_key => :id
    }

    belongs_to_settings = defaults.merge(options)
    belongs_to_settings.keys.each do |key|
      self.send("#{key}=", belongs_to_settings[key])
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      :foreign_key => "#{self_class_name.underscore}_id".to_sym,
      :class_name => name.to_s.singularize.camelcase,
      :primary_key => :id
    }

    has_many_settings = defaults.merge(options)
    has_many_settings.keys.each do |key|
      self.send("#{key}=", has_many_settings[key])
    end
  end
end

module Associatable
  def assoc_options
    @assoc_options ||= {}
  end

  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)

    define_method(name) do
      belongs_to_settings = self.class.assoc_options[name]
      query_val = self.send(belongs_to_settings.foreign_key)

      belongs_to_settings.model_class
        .where(belongs_to_settings.primary_key => query_val)
        .first
    end
  end

  def has_many(name, options = {})
    self.assoc_options[name] = HasManyOptions.new(name, self.name, options)

    define_method(name) do
      has_many_settings = self.class.assoc_options[name]
      query_val = self.send(has_many_settings.primary_key)

      has_many_settings.model_class
        .where(has_many_settings.foreign_key => query_val)
    end
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_ops = self.class.assoc_options[through_name]
      through_table, through_pk, through_fk =
        through_ops.table_name, through_ops.primary_key, through_ops.foreign_key

      source_opts = through_ops.model_class.assoc_options[source_name]
      source_table, source_pk, source_fk =
        source_opts.table_name, source_opts.primary_key, source_opts.foreign_key

      fk_value = self.send(through_fk)
      results = self.class.has_one_through_sql_query(source_table, through_table, source_fk, source_pk, through_pk, fk_value)

      source_opts.model_class.parse_all(results).first
    end
  end

  def has_one_through_sql_query(source_table, through_table, source_fk, source_pk, through_pk, val)
    results = DBConnection.execute(<<-SQL, val)
      SELECT
        #{source_table}.*
      FROM
        #{through_table}
      JOIN
        #{source_table}
      ON
        #{through_table}.#{source_fk} = #{source_table}.#{source_pk}
      WHERE
        #{through_table}.#{through_pk} = ?
    SQL
  end

end

class SQLObject
  extend Associatable
end
