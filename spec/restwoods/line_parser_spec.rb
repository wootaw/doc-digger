require 'spec_helper'

describe Restwoods::LineParser do

  describe ".indentation" do
    context "When have two whitespace in string start" do
      before(:each) do
        @c_str = "*  @doc (document1) Document One\n"
        @coffee_str = "  @doc (document1) Document One\n"
        @elixir_str = "  @doc (document1) Document One\n"
        @erlang_str = "%  @doc (document1) Document One\n"
        @perl_str = "#  @doc (document1) Document One\n"
        @python_str = "  @doc (document1) Document One\n"
        @ruby_str = "  @doc (document1) Document One\n"
      end

      it "Should be returns 2 in c" do
        parser = Restwoods::LineParser.new(@c_str, :java)
        expect(parser.indentation).to eq 2
      end

      it "Should be returns 2 in coffee" do
        parser = Restwoods::LineParser.new(@coffee_str, :coffee)
        expect(parser.indentation).to eq 2
      end

      it "Should be returns 2 in elixir" do
        parser = Restwoods::LineParser.new(@elixir_str, :elixir)
        expect(parser.indentation).to eq 2
      end

      it "Should be returns 2 in erlang" do
        parser = Restwoods::LineParser.new(@erlang_str, :erlang)
        expect(parser.indentation).to eq 2
      end

      it "Should be returns 2 in perl" do
        parser = Restwoods::LineParser.new(@perl_str, :perl)
        expect(parser.indentation).to eq 2
      end

      it "Should be returns 2 in python" do
        parser = Restwoods::LineParser.new(@python_str, :python)
        expect(parser.indentation).to eq 2
      end

      it "Should be returns 2 in ruby" do
        parser = Restwoods::LineParser.new(@ruby_str, :ruby)
        expect(parser.indentation).to eq 2
      end
    end

    context "When without whitespace in string start" do
      before(:each) do
        @c_str = " *@doc (document1) Document One\n"
        @coffee_str = "@doc (document1) Document One\n"
        @elixir_str = "@doc (document1) Document One\n"
        @erlang_str = "  %@doc (document1) Document One\n"
        @perl_str = " \#@doc (document1) Document One\n"
        @python_str = "@doc (document1) Document One\n"
        @ruby_str = "@doc (document1) Document One\n"
      end

      it "Should be returns zero in java" do
        parser = Restwoods::LineParser.new(@c_str, :java)
        expect(parser.indentation).to eq 0
      end

      it "Should be returns zero in coffee" do
        parser = Restwoods::LineParser.new(@coffee_str, :coffee)
        expect(parser.indentation).to eq 0
      end

      it "Should be returns zero in elixir" do
        parser = Restwoods::LineParser.new(@elixir_str, :elixir)
        expect(parser.indentation).to eq 0
      end

      it "Should be returns zero in erlang" do
        parser = Restwoods::LineParser.new(@erlang_str, :erlang)
        expect(parser.indentation).to eq 0
      end

      it "Should be returns zero in perl" do
        parser = Restwoods::LineParser.new(@perl_str, :perl)
        expect(parser.indentation).to eq 0
      end

      it "Should be returns zero in python" do
        parser = Restwoods::LineParser.new(@python_str, :python)
        expect(parser.indentation).to eq 0
      end

      it "Should be returns zero in ruby" do
        parser = Restwoods::LineParser.new(@ruby_str, :ruby)
        expect(parser.indentation).to eq 0
      end
    end
  end

  describe ".parse" do

    context "Parse document command @doc" do
      before(:each) do
        @c_str = "*  @doc (document1) Document One\n"
        @coffee_str = "  @doc  Document One\n"
        @elixir_str = "  @doc (document1)  Document One\n"
        @erlang_str = "%  @doc (document1) Document One\n"
        @perl_str = "#  @doc  Document One\n"
        @python_str = "  @doc (document1) Document One\n"
        @ruby_str = "  @doc  (document1)  Document One\n"
      end

      it "in c" do
        hash = Restwoods::LineParser.new(@c_str, :java).parse
        expect(hash[:type]).to eq :doc
        expect(hash[:part]).to eq :main
        expect(hash[:data][:name]).to eq "document1"
        expect(hash[:data][:summary]).to eq "Document One"
      end

      it "in coffee" do
        hash = Restwoods::LineParser.new(@coffee_str, :coffee).parse
        expect(hash[:type]).to eq :doc
        expect(hash[:part]).to eq :main
        expect(hash[:data][:name].nil?).to be_truthy
        expect(hash[:data][:summary]).to eq "Document One"
      end

      it "in elixir" do
        hash = Restwoods::LineParser.new(@elixir_str, :elixir).parse
        expect(hash[:type]).to eq :doc
        expect(hash[:part]).to eq :main
        expect(hash[:data][:name]).to eq "document1"
        expect(hash[:data][:summary]).to eq "Document One"
      end

      it "in erlang" do
        hash = Restwoods::LineParser.new(@erlang_str, :erlang).parse
        expect(hash[:type]).to eq :doc
        expect(hash[:part]).to eq :main
        expect(hash[:data][:name]).to eq "document1"
        expect(hash[:data][:summary]).to eq "Document One"
      end

      it "in perl" do
        hash = Restwoods::LineParser.new(@perl_str, :perl).parse
        expect(hash[:type]).to eq :doc
        expect(hash[:part]).to eq :main
        expect(hash[:data][:name].nil?).to be_truthy
        expect(hash[:data][:summary]).to eq "Document One"
      end

      it "in python" do
        hash = Restwoods::LineParser.new(@python_str, :python).parse
        expect(hash[:type]).to eq :doc
        expect(hash[:part]).to eq :main
        expect(hash[:data][:name]).to eq "document1"
        expect(hash[:data][:summary]).to eq "Document One"
      end

      it "in ruby" do
        hash = Restwoods::LineParser.new(@ruby_str, :ruby).parse
        expect(hash[:type]).to eq :doc
        expect(hash[:part]).to eq :main
        expect(hash[:data][:name]).to eq "document1"
        expect(hash[:data][:summary]).to eq "Document One"
      end
    end

    context "Parse resource command @res" do
      before(:each) do
        @c_str = "*  @res get /api/v1/a_res Get list of A\n"
        @coffee_str = "  @res get /api/v1/a_res Get list of A\n"
        @elixir_str = "  @res get /api/v1/a_res Get list of A\n"
        @erlang_str = "%  @res get /api/v1/a_res Get list of A\n"
        @perl_str = "#  @res get /api/v1/a_res Get list of A\n"
        @python_str = "  @res get /api/v1/a_res Get list of A\n"
        @ruby_str = "  @res get /api/v1/a_res Get list of A\n"
      end

      it "in c" do
        hash = Restwoods::LineParser.new(@c_str, :java).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :main
        expect(hash[:data][:method]).to eq "get"
        expect(hash[:data][:route]).to eq "/api/v1/a_res"
        expect(hash[:data][:summary]).to eq "Get list of A"
      end

    end

    context "Parse resource command @res_param" do
      before(:each) do
        @java_str = "*  @res_param {Boolean} is A boolean value\n"
        @coffee_str = "  @res_param {String=a,b,c} [str=b] Allowed values\n"
        @perl_str = "#  @res_param (group1) {Object} obj An Object value\n"
        @python_str = "  @res_param (group1) {String} obj.name name of Object\n"
        @erlang_str = "%  @res_param {Object[]} [obj.data] data of Object\n"
        @elixir_str = "  @res_param  [obj.data.val=0] A value\n"
        @ruby_str = "  @res_param {Number[]=2,3,4} num_z=3 Number Z\n"
      end

      it "in java" do
        hash = Restwoods::LineParser.new(@java_str, :java).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :param
        expect(hash[:data][:group].nil?).to be_truthy
        expect(hash[:data][:type]).to eq "Boolean"
        expect(hash[:data][:name]).to eq "is"
        expect(hash[:data][:summary]).to eq "A boolean value"
        expect(hash[:data][:required]).to be_truthy
        expect(hash[:data][:array]).not_to be_truthy
        expect(hash[:data][:parent].nil?).to be_truthy
        expect(hash[:data][:default].nil?).to be_truthy
        expect(hash[:data][:options].nil?).to be_truthy
      end

      it "in coffee" do
        hash = Restwoods::LineParser.new(@coffee_str, :coffee).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :param
        expect(hash[:data][:group].nil?).to be_truthy
        expect(hash[:data][:type]).to eq "String"
        expect(hash[:data][:name]).to eq "str"
        expect(hash[:data][:summary]).to eq "Allowed values"
        expect(hash[:data][:required]).not_to be_truthy
        expect(hash[:data][:array]).not_to be_truthy
        expect(hash[:data][:parent].nil?).to be_truthy
        expect(hash[:data][:default]).to eq "b"
        expect(hash[:data][:options]).to match_array ["a", "b", "c"]
      end

      it "in elixir" do
        hash = Restwoods::LineParser.new(@elixir_str, :elixir).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :param
        expect(hash[:data][:group].nil?).to be_truthy
        expect(hash[:data][:type].nil?).to be_truthy
        expect(hash[:data][:name]).to eq "val"
        expect(hash[:data][:summary]).to eq "A value"
        expect(hash[:data][:required]).not_to be_truthy
        expect(hash[:data][:array]).not_to be_truthy
        expect(hash[:data][:parent]).to match_array ["obj", "data"]
        expect(hash[:data][:default]).to eq "0"
        expect(hash[:data][:options].nil?).to be_truthy
      end

      it "in erlang" do
        hash = Restwoods::LineParser.new(@erlang_str, :erlang).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :param
        expect(hash[:data][:group].nil?).to be_truthy
        expect(hash[:data][:type]).to eq "Object"
        expect(hash[:data][:name]).to eq "data"
        expect(hash[:data][:summary]).to eq "data of Object"
        expect(hash[:data][:required]).not_to be_truthy
        expect(hash[:data][:array]).to be_truthy
        expect(hash[:data][:parent]).to eq ["obj"]
        expect(hash[:data][:default].nil?).to be_truthy
        expect(hash[:data][:options].nil?).to be_truthy
      end

      it "in perl" do
        hash = Restwoods::LineParser.new(@perl_str, :perl).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :param
        expect(hash[:data][:group]).to eq "group1"
        expect(hash[:data][:type]).to eq "Object"
        expect(hash[:data][:name]).to eq "obj"
        expect(hash[:data][:summary]).to eq "An Object value"
        expect(hash[:data][:required]).to be_truthy
        expect(hash[:data][:array]).not_to be_truthy
        expect(hash[:data][:parent].nil?).to be_truthy
        expect(hash[:data][:default].nil?).to be_truthy
        expect(hash[:data][:options].nil?).to be_truthy
      end

      it "in python" do
        hash = Restwoods::LineParser.new(@python_str, :python).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :param
        expect(hash[:data][:group]).to eq "group1"
        expect(hash[:data][:type]).to eq "String"
        expect(hash[:data][:name]).to eq "name"
        expect(hash[:data][:summary]).to eq "name of Object"
        expect(hash[:data][:required]).to be_truthy
        expect(hash[:data][:array]).not_to be_truthy
        expect(hash[:data][:parent]).to eq ["obj"]
        expect(hash[:data][:default].nil?).to be_truthy
        expect(hash[:data][:options].nil?).to be_truthy
      end

      it "in ruby" do
        hash = Restwoods::LineParser.new(@ruby_str, :ruby).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :param
        expect(hash[:data][:group].nil?).to be_truthy
        expect(hash[:data][:type]).to eq "Number"
        expect(hash[:data][:name]).to eq "num_z"
        expect(hash[:data][:summary]).to eq "Number Z"
        expect(hash[:data][:required]).to be_truthy
        expect(hash[:data][:array]).to be_truthy
        expect(hash[:data][:parent].nil?).to be_truthy
        expect(hash[:data][:default]).to eq "3"
        expect(hash[:data][:options]).to match_array ["2", "3", "4"]
      end
    end

    context "Parse resource command @res_header" do
      before(:each) do
        @java_str = "*  @res_header {Boolean} is A boolean value\n"
        @coffee_str = "  @res_header {String=a,b,c} [str=b] Allowed values\n"
        @perl_str = "#  @res_header (group1) {Object} obj An Object value\n"
        @python_str = "  @res_header (group1) {String} obj.name name of Object\n"
        @erlang_str = "%  @res_header {Number[]} [obj.num] num of Object\n"
        @elixir_str = "  @res_header  [obj.val=0] A value\n"
        @ruby_str = "  @res_header {Number[]=2,3,4} num_z=3 Number Z\n"
      end

      it "in java" do
        hash = Restwoods::LineParser.new(@java_str, :java).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :header
        expect(hash[:data][:group].nil?).to be_truthy
        expect(hash[:data][:type]).to eq "Boolean"
        expect(hash[:data][:name]).to eq "is"
        expect(hash[:data][:summary]).to eq "A boolean value"
        expect(hash[:data][:required]).to be_truthy
        expect(hash[:data][:array]).not_to be_truthy
        expect(hash[:data][:parent].nil?).to be_truthy
        expect(hash[:data][:default].nil?).to be_truthy
        expect(hash[:data][:options].nil?).to be_truthy
      end

      it "in coffee" do
        hash = Restwoods::LineParser.new(@coffee_str, :coffee).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :header
        expect(hash[:data][:group].nil?).to be_truthy
        expect(hash[:data][:type]).to eq "String"
        expect(hash[:data][:name]).to eq "str"
        expect(hash[:data][:summary]).to eq "Allowed values"
        expect(hash[:data][:required]).not_to be_truthy
        expect(hash[:data][:array]).not_to be_truthy
        expect(hash[:data][:parent].nil?).to be_truthy
        expect(hash[:data][:default]).to eq "b"
        expect(hash[:data][:options]).to match_array ["a", "b", "c"]
      end

      it "in elixir" do
        hash = Restwoods::LineParser.new(@elixir_str, :elixir).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :header
        expect(hash[:data][:group].nil?).to be_truthy
        expect(hash[:data][:type].nil?).to be_truthy
        expect(hash[:data][:name]).to eq "val"
        expect(hash[:data][:summary]).to eq "A value"
        expect(hash[:data][:required]).not_to be_truthy
        expect(hash[:data][:array]).not_to be_truthy
        expect(hash[:data][:parent]).to eq ["obj"]
        expect(hash[:data][:default]).to eq "0"
        expect(hash[:data][:options].nil?).to be_truthy
      end

      it "in erlang" do
        hash = Restwoods::LineParser.new(@erlang_str, :erlang).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :header
        expect(hash[:data][:group].nil?).to be_truthy
        expect(hash[:data][:type]).to eq "Number"
        expect(hash[:data][:name]).to eq "num"
        expect(hash[:data][:summary]).to eq "num of Object"
        expect(hash[:data][:required]).not_to be_truthy
        expect(hash[:data][:array]).to be_truthy
        expect(hash[:data][:parent]).to eq ["obj"]
        expect(hash[:data][:default].nil?).to be_truthy
        expect(hash[:data][:options].nil?).to be_truthy
      end

      it "in perl" do
        hash = Restwoods::LineParser.new(@perl_str, :perl).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :header
        expect(hash[:data][:group]).to eq "group1"
        expect(hash[:data][:type]).to eq "Object"
        expect(hash[:data][:name]).to eq "obj"
        expect(hash[:data][:summary]).to eq "An Object value"
        expect(hash[:data][:required]).to be_truthy
        expect(hash[:data][:array]).not_to be_truthy
        expect(hash[:data][:parent].nil?).to be_truthy
        expect(hash[:data][:default].nil?).to be_truthy
        expect(hash[:data][:options].nil?).to be_truthy
      end

      it "in python" do
        hash = Restwoods::LineParser.new(@python_str, :python).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :header
        expect(hash[:data][:group]).to eq "group1"
        expect(hash[:data][:type]).to eq "String"
        expect(hash[:data][:name]).to eq "name"
        expect(hash[:data][:summary]).to eq "name of Object"
        expect(hash[:data][:required]).to be_truthy
        expect(hash[:data][:array]).not_to be_truthy
        expect(hash[:data][:parent]).to eq ["obj"]
        expect(hash[:data][:default].nil?).to be_truthy
        expect(hash[:data][:options].nil?).to be_truthy
      end

      it "in ruby" do
        hash = Restwoods::LineParser.new(@ruby_str, :ruby).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :header
        expect(hash[:data][:group].nil?).to be_truthy
        expect(hash[:data][:type]).to eq "Number"
        expect(hash[:data][:name]).to eq "num_z"
        expect(hash[:data][:summary]).to eq "Number Z"
        expect(hash[:data][:required]).to be_truthy
        expect(hash[:data][:array]).to be_truthy
        expect(hash[:data][:parent].nil?).to be_truthy
        expect(hash[:data][:default]).to eq "3"
        expect(hash[:data][:options]).to match_array ["2", "3", "4"]
      end
    end

    context "Parse command @doc_state and @res_state" do
      before(:each) do
        @java_str = "*  @doc_state coming Coming Soon\n"
        @coffee_str = "  @res_state deprecated Deprecated\n"
      end

      it "in java" do
        hash = Restwoods::LineParser.new(@java_str, :java).parse
        expect(hash[:type]).to eq :doc
        expect(hash[:part]).to eq :state
        expect(hash[:data][:name]).to eq "coming"
        expect(hash[:data][:summary]).to eq "Coming Soon"
      end

      it "in coffee" do
        hash = Restwoods::LineParser.new(@coffee_str, :coffee).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :state
        expect(hash[:data][:name]).to eq "deprecated"
        expect(hash[:data][:summary]).to eq "Deprecated"
      end
    end

    context "Parse resource command @res_bind" do
      before(:each) do
        @java_str = "*  @res_bind (param) least num_a,num_b,num_c 1\n"
        @coffee_str = "  @res_bind only num_a,num_b,num_c 2\n"
      end

      it "in java" do
        hash = Restwoods::LineParser.new(@java_str, :java).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :bind
        expect(hash[:data][:scope]).to eq "param"
        expect(hash[:data][:command]).to eq "least"
        expect(hash[:data][:vars]).to eq ["num_a,num_b,num_c", "1"]
      end

      it "in coffee" do
        hash = Restwoods::LineParser.new(@coffee_str, :coffee).parse
        expect(hash[:type]).to eq :res
        expect(hash[:part]).to eq :bind
        expect(hash[:data][:scope].nil?).to be_truthy
        expect(hash[:data][:command]).to eq "only"
        expect(hash[:data][:vars]).to eq ["num_a,num_b,num_c", "2"]
      end
    end

    context "Parse command @cmd_def and @cmd_use" do
      before(:each) do
        @java_str = "*  @cmd_def order\n"
        @coffee_str = "  @cmd_use items\n"
      end

      it "in java" do
        hash = Restwoods::LineParser.new(@java_str, :java).parse
        expect(hash[:type]).to eq :cmd
        expect(hash[:part]).to eq :def
        expect(hash[:data][:name]).to eq "order"
      end

      it "in coffee" do
        hash = Restwoods::LineParser.new(@coffee_str, :coffee).parse
        expect(hash[:type]).to eq :cmd
        expect(hash[:part]).to eq :use
        expect(hash[:data][:name]).to eq "items"
      end
    end

  end
end
