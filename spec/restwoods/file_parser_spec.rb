require 'spec_helper'

describe Restwoods::FileParser do
  before(:each) do
    @rb_parser = Restwoods::FileParser.new("./spec/support/example.rb")
    @txt_parser = Restwoods::FileParser.new("./spec/support/example.txt")
  end

  describe ".current_class" do
    context "When the parser initialize a file that can't be support" do
      it "Should be returns nil" do
        expect(@txt_parser.current_class.nil?).to be_truthy
      end
    end

    context "When the parser initialize a file that can be support" do
      it "Should be returns support class" do
        expect(@rb_parser.current_class).to eq :ruby
      end
    end
  end

  describe ".parse" do

    context "when open a file that the parser can't support" do
      it "Should be returns a array of without element" do
        expect(@txt_parser.parse.length).to eq 0
      end
    end

    context "" do
      it "" do
        @rb_parser.parse
      end
    end
  end
end
