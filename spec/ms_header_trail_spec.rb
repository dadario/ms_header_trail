# frozen_string_literal: true

RSpec.describe MsHeaderTrail do
  it "has a version number" do
    expect(MsHeaderTrail::VERSION).not_to be nil
  end

  context "when information are collected" do
    let(:data) do
      {
        user_id: "123",
        user_type: "employee"
      }
    end

    before do
      described_class.collect(data)
    end

    it "verify if included for later usage" do
      expect(described_class.retrieve).to include(data)
    end
  end
end
