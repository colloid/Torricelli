module Pascal
    module SRT
        class Program < BasicEntity
            def initialize(ast, context, body)
                @ast, @context, @body = ast, context, body
            end

            def eval
                @context.new_frame
                @body.each { |stmt| stmt.eval } # TODO ensure pop_frame
                @context.pop_frame
            end
        end
    end
end


