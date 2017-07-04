require "spec_helper"

describe DocDigger::Config do

  describe ".init" do
    it "Should get error when the provided access_key or secret_key types are incorrect" do
      expect {
        DocDigger::Config.init(access_key: 123, secret_key: "def")
      }.to raise_error(DocDigger::ArgumentTypeError)

      expect {
        DocDigger::Config.init(access_key: "abc", secret_key: 456)
      }.to raise_error(DocDigger::ArgumentTypeError)
    end

    it "Should not be get error when the provided access_key and secret_key types are ok" do
      expect {
        DocDigger::Config.init(access_key: "abc", secret_key: "def")
      }.not_to raise_error
    end
  end

end
