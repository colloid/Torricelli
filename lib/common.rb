module Pascal
    class << Pascal
        attr_accessor :compilation_good
        attr_accessor :stdlib
        attr_accessor :stack
        Pascal.stack = []
    end

    class Token
        attr_reader :identifier
        attr_reader :filename
        attr_reader :lineno
        attr_reader :column

        def upcase!
            @identifier.upcase!
            self
        end
        def to_s
            @identifier
        end
        def == another
            self.to_s == another.to_s
        end
    end

    def self.semantic_assert (constraint, message)
        unless constraint
            compilation_error message
        end
    end

    def self.compilation_error (msg)
        Pascal.compilation_good = false
        STDERR.puts msg
    end

    module AST
        class Statement < BasicEntity
        end

        class Expression < AST::Statement
        end
    end

    module SRT
        class Statement < BasicEntity
        end

        class Expression < SRT::Statement
        end
    end
end


