module Pascal
    class CompilationError < RuntimeError; end

    module AST
        class Program < BasicEntity
            attr_reader :name           # Token
            attr_reader :declarations   # Array of DeclarationLine
            attr_reader :main           # Array of <Statement>

            def perceive
                Pascal.compilation_good = true
                @name.upcase!
                context = Context.new Pascal.stdlib

                @declarations.each { |decl| decl.perceive(context) }
                body = @main.map { |stmt| stmt.perceive(context) }

                if Pascal.compilation_good
                    SRT::Program.new(self, context, body)
                else
                    raise CompilationError
                end
            end
        end

        class DeclarationLine < BasicEntity
            attr_reader :type           # Token
            attr_reader :variables      # Array of Token

            def perceive context
                @type.upcase!

                type = context.get_type(@type)
                @variables.each do |var|
                    var.upcase!
                    context.add_variable(var, type)
                end
                nil
            end
        end
    end
end
