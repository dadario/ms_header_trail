# frozen_string_literal: true

require "faraday/ms_header_trail"

RSpec.describe Faraday::MsHeaderTrail do
  let(:app) { double("app", call: nil) }
  let(:middleware) { described_class.new(app) }

  describe ".call" do
    context "when attributes are set" do
      let(:data) do
        {
          user_id: "123",
          user_type: "employee"
        }
      end

      let(:expected_data) do
        {
          "X-Msht-User-Id" => "123",
          "X-Msht-User-Type" => "employee"
        }
      end

      before do
        ::MsHeaderTrail.collect(data)
      end

      it "adds the attributes to header" do
        env = { request_headers: {} }
        middleware.call(env)
        expect(env[:request_headers]).to include(expected_data)
      end
    end
  end
end
