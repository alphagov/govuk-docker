require "spec_helper"

RSpec.describe GovukDocker::Paths do
  describe "govuk_root_dir" do
    subject { described_class.govuk_root_dir }

    context "when GOVUK_ROOT_DIR is not set" do
      it "uses HOME environment variable" do
        ClimateControl.modify GOVUK_ROOT_DIR: nil, HOME: "/home/test" do
          expect(subject).to eq("/home/test/govuk")
        end
      end
    end

    context "when GOVUK_ROOT_DIR is set" do
      it "uses the environment variable" do
        ClimateControl.modify GOVUK_ROOT_DIR: "/govuk" do
          expect(subject).to eq("/govuk")
        end
      end
    end
  end

  describe "govuk_docker_dir" do
    subject { described_class.govuk_docker_dir }

    context "when GOVUK_DOCKER_DIR is not set" do
      it "uses govuk_root_dir" do
        ClimateControl.modify GOVUK_DOCKER_DIR: nil do
          expect(described_class).to receive(:govuk_root_dir).and_return("/home/test/govuk")
          expect(subject).to eq("/home/test/govuk/govuk-docker")
        end
      end
    end

    context "when GOVUK_DOCKER_DIR is set" do
      it "uses the environment variable" do
        ClimateControl.modify GOVUK_DOCKER_DIR: "/govuk/govuk-docker" do
          expect(subject).to eq("/govuk/govuk-docker")
        end
      end
    end
  end
end
