require "spec_helper"

describe Notifier do
  describe "vendita_added" do
    let(:mail) { Notifier.vendita_added(FactoryGirl.create(:documento)) }

    it "renders the headers" do
      mail.subject.should eq("Si sboccia!")
      mail.to.should eq(["paolo.tassinari@gmail.com"])
      mail.from.should eq(["crocevia.santacroce@gmail.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Si sboccia")
    end
  end

end
