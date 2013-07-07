# === Cinderella set (inside the module 'Pascal'):
#class SyntaxError < RuntimeError
#parse_file(filename) /* defined in c */
#class BasicEntity
#class Token
#   attr_reader :identifier     <= String
#   attr_reader :filename       <= String
#   attr_reader :lineno         <= Fixnum
#   attr_reader :column         <= Fixnum
#end
# ===

require_relative 'cinderella/cinderella.so'
require_relative 'common'
require_relative 'context'
require_relative 'type'
require_relative 'ast/ast'
require_relative 'srt/srt'
require_relative 'stdlib/stdlib'

