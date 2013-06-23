require "lib/flesher/pascal.so"

module Pascal
    class Program
        attr_reader :name           # String
        attr_reader :declarations   # Array of DeclarationLine => GLOB SYM TABLE
        attr_reader :main           # Array of <Statement>
    end

    class DeclarationLine
        attr_reader :type           # String
        attr_reader :variables      # Array of String
    end

    class FunctionCall              # <Expression>
        attr_reader :name           # String
        attr_reader :parameters     # Array of <Expression>
    end

    class StringLiteral             # <Expression>
        attr_reader :string         # String
    end

   #class SyntaxError < RuntimeError
   #parse_file(fd) /* defined in c */
end
