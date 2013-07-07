module Pascal
    module Stdlib
        # WRITELN
        class Writeln
            def initialize
                @stack = Context.new
            end
            def adapt *args
            end
            def name 
                "WRITELN"
            end
            def try_on *args # TODO check more precisely
                5
            end
            def eval args
                @stack.new_frame
                args.each { |a| print a.eval }
                puts
                @stack.pop_frame # TODO ensure
            end
        end

        Pascal.stdlib.add_function("WRITELN", Writeln.new)
    end
end
