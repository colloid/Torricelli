module Pascal
    module SRT
        class FunctionCall < SRT::Expression
            def initialize ast, func, args
                @ast, @func, @args = ast, func, args
                @func.adapt(@args)
            end

            def type
                @func.type
            end

            def eval
                result = catch(@func.name) do # TODO ensure @func.pop_frame
                    @func.eval @args
                end
                result
            end
        end

        class StringLiteral < SRT::Expression
            def initialize ast, literal
                @ast, @literal = ast, literal
            end

            def type
                Pascal::String.new
            end

            def eval
                @literal
            end
        end

        class CharLiteral < SRT::Expression
            def initialize ast, literal
                @ast, @literal = ast, literal
            end

            def type
                Pascal::Char.new
            end

            def eval
                @literal
            end
        end

        class VariableEvaluation < SRT::Expression
            def initialize ast, variable
                @ast, @variable = ast, variable
            end

            def type
                @variable.type
            end

            def eval
                @variable.context.top_frame[@variable.index]
            end
        end
    end
end
