require "test/test_helper_with_wrong"

require "predicated/from/url_part"
include Predicated

apropos "parse url parts and convert them into predicates" do

  apropos "basic operations" do

    test "simple signs" do
      assert { Predicate.from_url_part("a=1") == Predicate{ Eq("a","1") } }
      assert { Predicate.from_url_part("a<1") == Predicate{ Lt("a","1") } }
      assert { Predicate.from_url_part("a>1") == Predicate{ Gt("a","1") } }
      assert { Predicate.from_url_part("a<=1") == Predicate{ Lte("a","1") } }
      assert { Predicate.from_url_part("a>=1") == Predicate{ Gte("a","1") } }
    end

    test "not" do
      assert { Predicate.from_url_part("!(a=1)") == Predicate{ Not(Eq("a","1")) } }
    end

    test "simple and + or" do
      assert { Predicate.from_url_part("a=1&b=2") == Predicate{ And(Eq("a","1"),Eq("b","2")) } }
      assert { Predicate.from_url_part("a=1|b=2") == Predicate{ Or(Eq("a","1"),Eq("b","2")) } }
    end

    test "complex and + or" do
      assert { Predicate.from_url_part("a=1&b=2|c=3") == 
        Predicate{ Or( And(Eq("a","1"),Eq("b","2")), Eq("c","3") ) } }
    end
    
    test "parens change precedence" do
      assert { Predicate.from_url_part("a=1|b=2&c=3") == 
        Predicate{ Or( Eq("a","1"), And(Eq("b","2"),Eq("c","3")) ) } }

      assert { Predicate.from_url_part("(a=1|b=2)&c=3") == 
        Predicate{ And( Or(Eq("a","1"),Eq("b","2")), Eq("c","3") ) } }
    end

  end
end