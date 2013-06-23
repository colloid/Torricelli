require "test/unit"
require "shoulda"
require "pascal"

class Test_hello_world < Test::Unit::TestCase
    context "Hello world:" do
        setup do
            @ast = File.open("examples/hello_world.pas") do |file|
                Pascal.parse_file(file.fileno)
            end
        end

        should "be Program" do
            assert (Pascal::Program === @ast)
        end

        should "be named 'HelloWorld'" do
            assert_equal(@ast.name, "HelloWorld")
        end

        should "have no declarations" do
            assert_nil(@ast.declarations)
        end

        context "Program block:" do
            setup do
                @main = @ast.main
            end

            should "have one statement" do
                assert_equal(@main.length, 1)
            end

            context "Statement:" do
                setup do
                    @stmt = @main[0]
                end

                should "be FunctionCall" do
                    assert (Pascal::FunctionCall === @stmt)
                end

                should "be writeln" do
                    assert_equal(@stmt.name, "writeln")
                end

                should "have one string parameter" do
                    assert_equal(@stmt.parameters.length, 1)
                    assert(Pascal::StringLiteral === @stmt.parameters[0])
                    assert_equal(@stmt.parameters[0].string, "'Hello, World!'")
                end
            end
        end
    end
end
