module Pascal
    class Type < BasicEntity
        def from expr
            return expr if expr.type == self.type
            invalid_conversion expr.type, self.type
        end

        def try_from expr # 0 - no way, 3 - needs conversion, 5 - fits excellently
            return 5 if expr.type == self.type
            return 0
        end

        def name
            raise Exception, "pure virtual function call", caller
        end

        def == rhs
            self.class == rhs.class
        end

        def type
            self.class.new
        end

        def invalid_conversion from, to
            semantic_error "Invalid conversion ('#{from.name}' => '#{to.name}')"
        end
    end

    class String < Pascal::Type
        Pascal.stdlib.add_type("STRING", self.new)
        def name
            "STRING"
        end
    end


    class Char < Pascal::Type
        Pascal.stdlib.add_type("CHAR", self.new)
        def name
            "CHAR"
        end
    end

    class Int < Pascal::Type
        Pascal.stdlib.add_type("INTEGER", self.new)
        def name
            "INTEGER"
        end

        def try_from
            if expr.type == self.type
                5
            elsif expr.type == Real
                3
            else
                0
            end
        end

        def from expr
            case
            when expr.type == self.type
                expr
            when expr.type.class == Real
                RealToInt(expr.ast, expr)
            else
                invalid_conversion expr.type, self.class
            end
        end
    end

    class Void < Pascal::Type
        def name
            "Void"
        end
    end
end
