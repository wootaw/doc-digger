require 'spec_helper'

describe Restwoods::LineParser do

  describe ".start_space" do
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
        parser = Restwoods::LineParser.new(@c_str, :c)
        expect(parser.start_space).to eq 2
      end

      it "Should be returns 2 in coffee" do
        parser = Restwoods::LineParser.new(@coffee_str, :coffee)
        expect(parser.start_space).to eq 2
      end

      it "Should be returns 2 in elixir" do
        parser = Restwoods::LineParser.new(@elixir_str, :elixir)
        expect(parser.start_space).to eq 2
      end

      it "Should be returns 2 in erlang" do
        parser = Restwoods::LineParser.new(@erlang_str, :erlang)
        expect(parser.start_space).to eq 2
      end

      it "Should be returns 2 in perl" do
        parser = Restwoods::LineParser.new(@perl_str, :perl)
        expect(parser.start_space).to eq 2
      end

      it "Should be returns 2 in python" do
        parser = Restwoods::LineParser.new(@python_str, :python)
        expect(parser.start_space).to eq 2
      end

      it "Should be returns 2 in ruby" do
        parser = Restwoods::LineParser.new(@ruby_str, :ruby)
        expect(parser.start_space).to eq 2
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

      it "Should be returns zero in c" do
        parser = Restwoods::LineParser.new(@c_str, :c)
        expect(parser.start_space).to eq 0
      end

      it "Should be returns zero in coffee" do
        parser = Restwoods::LineParser.new(@coffee_str, :coffee)
        expect(parser.start_space).to eq 0
      end

      it "Should be returns zero in elixir" do
        parser = Restwoods::LineParser.new(@elixir_str, :elixir)
        expect(parser.start_space).to eq 0
      end

      it "Should be returns zero in erlang" do
        parser = Restwoods::LineParser.new(@erlang_str, :erlang)
        expect(parser.start_space).to eq 0
      end

      it "Should be returns zero in perl" do
        parser = Restwoods::LineParser.new(@perl_str, :perl)
        expect(parser.start_space).to eq 0
      end

      it "Should be returns zero in python" do
        parser = Restwoods::LineParser.new(@python_str, :python)
        expect(parser.start_space).to eq 0
      end

      it "Should be returns zero in ruby" do
        parser = Restwoods::LineParser.new(@ruby_str, :ruby)
        expect(parser.start_space).to eq 0
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
        hash = Restwoods::LineParser.new(@c_str, :c).parse
        expect(hash[:type]).to eq :document
        expect(hash[:part]).to eq :main
        expect(hash[:data][:name]).to eq "document1"
        expect(hash[:data][:summary]).to eq "Document One"
      end

      it "in coffee" do
        hash = Restwoods::LineParser.new(@coffee_str, :coffee).parse
        expect(hash[:type]).to eq :document
        expect(hash[:part]).to eq :main
        expect(hash[:data][:name].nil?).to be_truthy
        expect(hash[:data][:summary]).to eq "Document One"
      end

      it "in elixir" do
        hash = Restwoods::LineParser.new(@elixir_str, :elixir).parse
        expect(hash[:type]).to eq :document
        expect(hash[:part]).to eq :main
        expect(hash[:data][:name]).to eq "document1"
        expect(hash[:data][:summary]).to eq "Document One"
      end

      it "in erlang" do
        hash = Restwoods::LineParser.new(@erlang_str, :erlang).parse
        expect(hash[:type]).to eq :document
        expect(hash[:part]).to eq :main
        expect(hash[:data][:name]).to eq "document1"
        expect(hash[:data][:summary]).to eq "Document One"
      end

      it "in perl" do
        hash = Restwoods::LineParser.new(@perl_str, :perl).parse
        expect(hash[:type]).to eq :document
        expect(hash[:part]).to eq :main
        expect(hash[:data][:name].nil?).to be_truthy
        expect(hash[:data][:summary]).to eq "Document One"
      end

      it "in python" do
        hash = Restwoods::LineParser.new(@python_str, :python).parse
        expect(hash[:type]).to eq :document
        expect(hash[:part]).to eq :main
        expect(hash[:data][:name]).to eq "document1"
        expect(hash[:data][:summary]).to eq "Document One"
      end

      it "in ruby" do
        hash = Restwoods::LineParser.new(@ruby_str, :ruby).parse
        expect(hash[:type]).to eq :document
        expect(hash[:part]).to eq :main
        expect(hash[:data][:name]).to eq "document1"
        expect(hash[:data][:summary]).to eq "Document One"
      end
    end

    context "Parse document command @doc_desc" do
      before(:each) do
        @c_str = "*  @doc_desc Detail:\n"
        @coffee_str = "@doc_desc\n"
        @elixir_str = "  @doc_desc Detail:\n"
        @erlang_str = "%@doc_desc Detail:\n"
        @perl_str = "#  @doc_desc See more:\n"
        @python_str = "  @doc_desc See  more:\n"
        @ruby_str = "  @doc_desc \n"
      end

      it "in c" do
        hash = Restwoods::LineParser.new(@c_str, :c).parse
        expect(hash[:type]).to eq :document
        expect(hash[:part]).to eq :description
        expect(hash[:data][:text]).to eq "Detail:"
      end

      it "in coffee" do
        hash = Restwoods::LineParser.new(@coffee_str, :coffee).parse
        expect(hash[:type]).to eq :document
        expect(hash[:part]).to eq :description
        expect(hash[:data][:text].nil?).to be_truthy
      end

      it "in elixir" do
        hash = Restwoods::LineParser.new(@elixir_str, :elixir).parse
        expect(hash[:type]).to eq :document
        expect(hash[:part]).to eq :description
        expect(hash[:data][:text]).to eq("Detail:")
      end

      it "in erlang" do
        hash = Restwoods::LineParser.new(@erlang_str, :erlang).parse
        expect(hash[:type]).to eq :document
        expect(hash[:part]).to eq :description
        expect(hash[:data][:text]).to eq("Detail:")
      end

      it "in perl" do
        hash = Restwoods::LineParser.new(@perl_str, :perl).parse
        expect(hash[:type]).to eq :document
        expect(hash[:part]).to eq :description
        expect(hash[:data][:text]).to eq("See more:")
      end

      it "in python" do
        hash = Restwoods::LineParser.new(@python_str, :python).parse
        expect(hash[:type]).to eq :document
        expect(hash[:part]).to eq :description
        expect(hash[:data][:text]).to eq("See more:")
      end

      it "in ruby" do
        hash = Restwoods::LineParser.new(@ruby_str, :ruby).parse
        expect(hash[:type]).to eq :document
        expect(hash[:part]).to eq :description
        expect(hash[:data][:text].nil?).to be_truthy
      end
    end

  end
end
