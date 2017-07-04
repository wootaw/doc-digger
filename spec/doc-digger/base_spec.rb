require "spec_helper"

describe DocDigger do

  describe ".connect!" do
    it "Should get error when not provide access_key or secret_key" do
      expect { DocDigger.connect!(access_key: "abc") }.to raise_error(DocDigger::MissingArgumentsError)
      expect { DocDigger.connect!(secret_key: "abc") }.to raise_error(DocDigger::MissingArgumentsError)
    end

    it "Should not get error when access_key and secret_key are provided" do
      expect {
        DocDigger.connect!(access_key: "abc", secret_key: "def")
      }.not_to raise_error
    end
  end

end
