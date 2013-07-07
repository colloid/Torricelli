require "test/unit"
require "pascal"

class Test_hello_world_perceive < Test::Unit::TestCase
    def test_hello_world
        @ast = File.open("examples/hello_world.pas") do |file|
            Pascal.parse_file(file.fileno)
        end
        @ast.perceive
        @ast.eval
    end
end
