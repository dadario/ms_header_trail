# frozen_string_literal: true

RSpec.describe Rack::MsHeaderTrail do
  let(:app) { ->(_) { [200, {}, "body"] } }

  let(:env) do
    {
      HTTP_X_MSHT_USER_ID: "12356",
      HTTP_X_MSHT_USER_TYPE: "employee"
    }
  end

  before do
    ::MsHeaderTrail.configure do |config|
      config.rack_header_response = true
    end
  end

  context "Extract attributes from request headers" do
    let(:expect_data) do
      {
        user_id: "12356",
        user_type: "employee"
      }
    end

    it "information available into local process" do
      described_class.new(app).call(env)
      expect(::MsHeaderTrail.retrieve).to include(expect_data)
    end
  end

  context "Includes attributes into response headers" do
    let(:expect_data) do
      {
        "X-Msht-User-Id" => "12356",
        "X-Msht-User-Type" => "employee"
      }
    end

    it "information available into local process" do
      _status, headers, _body = described_class.new(app).call(env)
      expect(headers).to include(expect_data)
    end
  end
end
