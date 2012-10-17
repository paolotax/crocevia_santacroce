require "spec_helper"

describe Notifier do
  describe "vendita_added" do
    let(:mail) { Notifier.vendita_added }

    it "renders the headers" do
      mail.subject.should eq("Vendita added")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
