module Pascal
    class Context < BasicEntity
        class BadType
            def from expr
                expr
            end
        end

        class Variable
            attr_accessor :index
            attr_reader   :type
            attr_reader   :context
            def initialize context, name, type
                @context, @name, @type = context, name, type
            end
        end

        class BadVariable
            def type
                BadType.new
            end
        end

=begin
    class BasicFunction
        def initialize
            @stack = []
        end
        def new_frame
            frame = []
            @stack << frame
            Pascal.stack << frame
            nil
        end
        def pop_frame
            @stack = @stack[0 ... @stack.length - 1]
            Pascal.stack = Pascal.stack[0 ... Pascal.stack - 1]
            nil
        end
    end

        class Function
            attr_reader :parameters     # Array of Types of Arguments
            attr_reader :type           # Type of Return Value
            attr_reader :body           # Function Body
            attr_reader :context        # Link to the Context

            def adapt args
                @parameters.length.times do |i|
                    args[i] = parameters.type.from(args[i]) # TODO here checks are redundant
                end
                nil
            end
        end
=end

        class BadFunction
            def type
                BadType.new
            end
            def adapt args
            end
        end

        class PolyFunction
            def initialize *args
                @storage = [].concat args
            end

            def + other
                @storage.concat other.storage
                self
            end

            def select args
                results = []
                @storage.each do |fun|
                    results << fun.try_on(args)
                end

                max = results.max
                if max == 0
                    Pascal.compilation_error "Wrong arguments for the function"
                    return BadFunction.new
                end

                num = results.count(max)
                if num > 1
                    Pascal.compilation_error "Ambiguous function call"
                    return BadFunction.new
                end

                return @storage[results.index(max)]
            end

            protected 
            def storage
                @storage
            end
        end

        def initialize (*args)
            @toplevel = args
            @personal_stack = []
            @storage = Hash.new
            def @storage.[] name
                super name.to_s
            end
            def @storage.[]=(key, value)
                super(key.to_s, value)
            end
            @index = 0
        end

        def new_frame
            frame = []
            @personal_stack << frame
            Pascal.stack << frame
            nil
        end

        def pop_frame
            @personal_stack = @personal_stack[0 ... (@personal_stack.length - 1) ]
            Pascal.stack = Pascal.stack[0 ... (Pascal.stack.length - 1) ]
            nil
        end

        def top_frame
            @personal_stack[@personal_stack.length - 1]
        end

        def dock unit
            @toplevel.push_back unit
            self
        end

        def semantic_error *args
            Pascal.compilation_error *args
        end

        def get_function(name, args)
            found = self[name]
            if found.length > 0 and found.inject(true) { |res, fnd| res and fnd.class == PolyFunction }
                fun = found.inject(PolyFunction.new, :+)
                return fun.select(args)
            end

            if found.length > 1
                semantic_error "Ambiguous name '#{name}'"
            else
                semantic_error "Function name expected but '#{name}' found"
            end
            BadFunction.new
        end

        def get_type(name)
            found = self[name]
            return found[0] if found.length == 1 and Pascal::Type === found[0]

            if found.length <= 1
                semantic_error "Type name expected but '#{name}' found"
            else
                semantic_error "Ambiguous name '#{name}'"
            end
            BadType.new
        end

        def get_variable(name)
            found = self[name]
            return found[0] if found.length == 1 and found[0].class == Variable

            if found.length <= 1
                semantic_error "Variable name expected but '#{name}' found"
            else
                semantic_error "Ambiguous name '#{name}'"
            end
            BadVariable.new
        end

        def add_variable(name, type)
            if @storage[name]
                semantic_error "Redefinition of the identifier '#{name}'"
            end

            var = Variable.new(self, name, type)
            var.index = @index
            @index = @index + 1
            @storage[name] = var
            nil
        end

        def add_type(name, type)
            if @storage[name]
                semantic_error "Redefinition of the identifier '#{name}'"
            end
            @storage[name] = type
            nil
        end

        def add_function(name, function)
            fnd = @storage[name]

            if fnd
                if fnd.class != PolyFunction
                    @storage[name] = fnd + PolyFunction.new(function)
                else
                    semantic_error "Redefinition of the identifier '#{name}'"
                end
            else
                @storage[name] = PolyFunction.new(function)
            end
            nil
        end

        protected
        def [] (name)
            found = @storage[name]
            if found
                return found if found.class == Array
                return [ found ]
            end

            found = []
            @toplevel.each do |tl; fnd|
                fnd = tl[name]
                found.concat fnd
            end

            return found
        end
    end

    Pascal.stdlib = Context.new
end
