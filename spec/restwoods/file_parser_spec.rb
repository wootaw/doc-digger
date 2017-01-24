require 'spec_helper'

describe Restwoods::FileParser do
  before(:context) do
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

    before(:context) do
      @txt_hash = @txt_parser.results
      @ruby_hash = @rb_parser.results
    end

    context "When open a file that the parser can't support" do
      it "Should be returns a array of without element" do
        expect(@txt_hash.length).to eq 0
        ap @ruby_hash
        # p @ruby_hash

        # ap Base64.urlsafe_encode64(@ruby_hash.to_json)
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
        expect(@ruby_hash[0][:resources][0][:params].length).to eq 21
      end

      it "The first resource should have 4 binds" do
        expect(@ruby_hash[0][:resources][0][:binds].length).to eq 4
      end

      it "The first parameter of the first resource should have 6 attributes" do
        expect(@ruby_hash[0][:resources][0][:params][0].size).to eq 6
      end

      it "The last parameter of the first resource should have 8 attributes" do
        expect(@ruby_hash[0][:resources][0][:params].last.size).to eq 8
      end

      it "The second resource should have 6 headers" do
        expect(@ruby_hash[0][:resources][1][:headers].length).to eq 6
      end

      it "The second resource should have 3 success fields" do
        expect(@ruby_hash[0][:resources][1][:responses].length).to eq 5
      end

      # it "The second resource should have 2 error fields" do
      #   expect(@ruby_hash[0][:resources][1][:errors].length).to eq 2
      # end

      it "The description of the second success field of the second resource should have 8 part" do
        expect(@ruby_hash[0][:resources][1][:responses][1][:descriptions].length).to eq 8
      end

      # it "The description of the second error field of the second resource should have 7 part" do
      #   expect(@ruby_hash[0][:resources][1][:errors][1][:descriptions].length).to eq 7
      # end

      it "The state of the last document should be deprecated" do
        expect(@ruby_hash.last[:state][:name]).to eq "deprecated"
        expect(@ruby_hash.last[:state][:summary]).to eq ""
        expect(@ruby_hash.last[:state][:descriptions].length).to eq 2
      end

      it "The state of the third resource should be coming" do
        expect(@ruby_hash[1][:resources][0][:state][:name]).to eq "coming"
        expect(@ruby_hash[1][:resources][0][:state][:summary]).to eq "This resource will be coming soon"
        expect(@ruby_hash[1][:resources][0][:state][:descriptions].length).to eq 2
      end

    end

  end
end
