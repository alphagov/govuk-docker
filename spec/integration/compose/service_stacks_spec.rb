require "spec_helper"

RSpec.describe "Compose service stacks" do
  ServicesHelper.names.each do |service_name|
    it "configures #{service_name} with a lite or app stack" do
      service_stacks = ComposeHelper.services(service_name)

      expect(service_stacks.keys).to include(/lite/)
        .or include(/app(-\w+)?$/)
    end
  end

  ComposeHelper.app_services.each_pair do |service_name, service|
    it "configures #{service_name} with a default command" do
      expect(service["command"]).to_not be_nil
    end
  end

  ComposeHelper.lite_services.each_pair do |service_name, service|
    it "configures #{service_name} without a default command" do
      expect(service["command"]).to be_nil
    end
  end
end
