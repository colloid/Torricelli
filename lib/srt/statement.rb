module Pascal
    module SRT
        class AssignmentStatement < SRT::Statement
            def initialize ast, var, expr
                @ast, @var, @expr = ast, var, expr
            end

            def eval
                @var.context.top_frame[@var.index] = @expr.eval
            end
        end
    end
end

