# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strong
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/http-form_data/all/http-form_data.rbi
#
# http-form_data-2.1.1
module HTTP
end
module HTTP::FormData
  def self.create(data); end
  def self.ensure_hash(obj); end
  def self.multipart?(data); end
end
module HTTP::FormData::Readable
  def read(length = nil, outbuf = nil); end
  def rewind; end
  def size; end
  def to_s; end
end
class HTTP::FormData::Part
  def content_type; end
  def filename; end
  def initialize(body, content_type: nil, filename: nil); end
  include HTTP::FormData::Readable
end
class HTTP::FormData::File < HTTP::FormData::Part
  def filename_for(io); end
  def initialize(path_or_io, opts = nil); end
  def make_io(path_or_io); end
  def mime_type; end
end
class HTTP::FormData::CompositeIO
  def advance_io; end
  def current_io; end
  def initialize(ios); end
  def read(length = nil, outbuf = nil); end
  def rewind; end
  def size; end
end
class HTTP::FormData::Multipart
  def boundary; end
  def content_length; end
  def content_type; end
  def glue; end
  def initialize(data, boundary: nil); end
  def self.generate_boundary; end
  def tail; end
  include HTTP::FormData::Readable
end
class HTTP::FormData::Multipart::Param
  def content_type; end
  def filename; end
  def footer; end
  def header; end
  def initialize(name, value); end
  def parameters; end
  def self.coerce(data); end
  include HTTP::FormData::Readable
end
class HTTP::FormData::Urlencoded
  def content_length; end
  def content_type; end
  def initialize(data); end
  def self.encoder; end
  def self.encoder=(implementation); end
  include HTTP::FormData::Readable
end
class HTTP::FormData::Error < StandardError
end
