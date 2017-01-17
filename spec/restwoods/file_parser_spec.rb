require 'spec_helper'

describe Restwoods::FileParser do
  before(:each) do
    @rb_parser = Restwoods::FileParser.new("./spec/support/example.rb")
    @txt_parser = Restwoods::FileParser.new("./spec/support/example.txt")
  end

  describe ".lang" do
    context "When the parser initialize a file that can't be support" do
      it "Should be returns nil" do
        expect(@txt_parser.lang.nil?).to be_truthy
      end
    end

    context "When the parser initialize a file that can be support" do
      it "Should be returns support class" do
        expect(@rb_parser.lang).to eq :ruby
      end
    end
  end

  describe ".parse" do

    before(:each) do
      @txt_hash = @txt_parser.parse
      @ruby_hash = @rb_parser.parse
    end

    context "When open a file that the parser can't support" do
      it "Should be returns a array of without element" do
        expect(@txt_hash.length).to eq 0
        ap @ruby_hash
      end
    end

    context "When open a file that includes multipule classes" do
      it "Should be returns 3 documents" do
        expect(@ruby_hash.length).to eq 3
      end

      it "The description of first document should have 3 part" do
        expect(@ruby_hash[0][:descriptions].length).to eq 3
      end

      it "The first document should have two resources" do
        expect(@ruby_hash[0][:resources].length).to eq 2
      end

      it "The description of first resource should have 3 part" do
        expect(@ruby_hash[0][:resources][0][:descriptions].length).to eq 3
      end

      it "The first resource should have 21 parameters" do
        expect(@ruby_hash[0][:resources][0][:parameters].length).to eq 21
      end

      it "The second resource should have 6 headers" do
        expect(@ruby_hash[0][:resources][1][:headers].length).to eq 6
      end

      it "The second resource should have 3 success fields" do
        expect(@ruby_hash[0][:resources][1][:returns].length).to eq 3
      end

      it "The second resource should have 2 error fields" do
        expect(@ruby_hash[0][:resources][1][:errors].length).to eq 2
      end

      it "The description of the second success field of the second resource should have 8 part" do
        expect(@ruby_hash[0][:resources][1][:returns][1][:descriptions].length).to eq 8
      end

      it "The description of the second error field of the second resource should have 7 part" do
        expect(@ruby_hash[0][:resources][1][:errors][1][:descriptions].length).to eq 7
      end
    end

  end
end
