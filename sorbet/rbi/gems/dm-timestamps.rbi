# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strong
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/dm-timestamps/all/dm-timestamps.rbi
#
# dm-timestamps-1.2.0
module DataMapper
end
module DataMapper::Timestamps
  def self.included(model); end
  def set_timestamps; end
  def set_timestamps_on_save; end
  def touch; end
end
module DataMapper::Timestamps::ClassMethods
  def timestamps(*names); end
end
class DataMapper::Timestamps::InvalidTimestampName < RuntimeError
end
