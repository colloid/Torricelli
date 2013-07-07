require "test/unit"
require "context"

module Pascal
    class Context
        attr_writer :functions
        attr_writer :types
        attr_writer :variables
    end
end

class TestContext < Test::Unit::TestCase
    def test_one
        top = Pascal::Context.new(nil)
        top.functions[:fish] = "bulk"
        top.functions[:cat] = "mewoo"
        top.functions[:tiger] = "rrrrr"

        bottom = Pascal::Context.new(top)
        bottom.functions[:cow] = "mooo"
        bottom.functions[:fly] = "zzzz"
        bottom.functions[:tiger] = "mewo"

        assert_equal(bottom.functions[:cow], "mooo")
        assert_nil(bottom.functions[:lion])
        assert_equal(bottom.functions[:tiger], "mewo")
        assert_equal(top.functions[:tiger], "rrrrr")
        assert_nil(top.functions[:fly])
        assert_equal(top.functions[:fish], "bulk")
    end
end
