require "spec_helper"

RSpec.describe "Compose rails host" do
  ComposeHelper.rails_app_services.each do |service_name, service|
    it "#{service_name} allows connections from the host machine" do
      expect(service["environment"]["BINDING"]).to_not be_empty
    end

    it "#{service_name} exposes the port to the host machine" do
      expect(service["expose"]).to eq(%w[3000])
    end
  end
end
