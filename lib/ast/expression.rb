module Pascal
    module AST
        class FunctionCall < AST::Expression
            attr_reader :name           # Token
            attr_reader :arguments      # Array of <AST::Expression>

            def perceive(context)
                @name.upcase!
                args = @arguments.map { |e| e.perceive(context) }
                func = context.get_function(@name, args)
                SRT::FunctionCall.new(self, func, args)
            end
        end

        class StringLiteral < AST::Expression
            attr_reader :string         # Token

            def perceive(context)
                str = @string[1 ... @string.length - 1]
                #str.gsub!(/''/, "'") # TODO normalize_string
                if str.length == 1
                    SRT::CharLiteral.new(self, str)
                else
                    SRT::StringLiteral.new(self, str)
                end
            end
        end

        class EvaluateVariable < AST::Expression       # TODO rename class
            attr_reader :name           # Token

            def perceive(context)
                @name.upcase!
                variable = context.get_variable(@name)
                SRT::VariableEvaluation.new(self, variable)
            end
        end
    end
end
