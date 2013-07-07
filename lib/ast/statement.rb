module Pascal
    module AST
        class AssignmentStatement < Statement # TODO AssignmentStatement => Assignment
            attr_reader :name           # Token
            attr_reader :expression     # <AST::Expression>

            def perceive(context)
                @name.upcase!
                variable = context.get_variable(@name)
                expr = @expression.perceive(context)
                SRT::AssignmentStatement.new(self, variable, variable.type.from(expr))
            end
        end
    end
end
