# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: true
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/dm-aggregates/all/dm-aggregates.rbi
#
# dm-aggregates-1.2.0
module DataMapper
end
module DataMapper::Aggregates
  def self.include_aggregate_api; end
end
module DataMapper::Aggregates::Functions
  def aggregate(*args); end
  def assert_property_type(name, *types); end
  def avg(*args); end
  def count(*args); end
  def direction_map; end
  def max(*args); end
  def min(*args); end
  def normalize_field(field); end
  def sum(*args); end
  include DataMapper::Assertions
end
module DataMapper::Aggregates::Collection
  def property_by_name(property_name); end
  include DataMapper::Aggregates::Functions
end
module DataMapper::Aggregates::Operators
  def avg; end
  def count; end
  def max; end
  def min; end
  def sum; end
end
class Symbol
  include DataMapper::Aggregates::Operators
end
module DataMapper::Aggregates::Model
  def property_by_name(property_name); end
  include DataMapper::Aggregates::Functions
end
module DataMapper::Aggregates::Query
  def assert_valid_fields_with_operator(fields, unique); end
  def self.included(base); end
end
module DataMapper::Aggregates::Repository
  def aggregate(query); end
end
module DataMapper::Adapters
  def self.aggregate_extensions(const_name); end
  def self.aggregate_module(const_name); end
  def self.include_aggregate_api(const_name); end
  extend Anonymous_Module_3
end
module Anonymous_Module_3
  def const_added(const_name); end
end
class DataMapper::Repository
  include DataMapper::Aggregates::Repository
end
module DataMapper::Model
  include DataMapper::Aggregates::Model
end
class DataMapper::Collection < LazyArray
  include DataMapper::Aggregates::Collection
end
class DataMapper::Query
  def assert_valid_fields_without_operator(fields, unique); end
  include DataMapper::Aggregates::Query
end
module DataMapper::Aggregates::DataObjectsAdapter
  def aggregate(query); end
  def aggregate_field_statement(aggregate_function, property, qualify); end
  def avg(property, value); end
  def count(property, value); end
  def max(property, value); end
  def min(property, value); end
  def sum(property, value); end
  extend DataMapper::Chainable
  include Anonymous_Module_4
end
module Anonymous_Module_4
  def property_to_column_name(property, qualify); end
end
