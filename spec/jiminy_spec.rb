# frozen_string_literal: true

RSpec.describe Jiminy do
  it "has a version number" do
    expect(Jiminy::VERSION).not_to be nil
  end

  it "has a configuration" do
    expect(Jiminy).to be_configured
  end

  describe "sub-module loading" do
    it "loads Recording if Rails is defined" do
      Rails = Object.new unless defined?(Rails)
      load "jiminy.rb"
      expect(Jiminy.constants).to include(:Recording)
    end

    it "doesn't load Recording if Rails is not defined" do
      Object.send(:remove_const, :Rails)
      Jiminy.send(:remove_const, :Recording)
      load "jiminy.rb"
      expect(Jiminy.constants).not_to include(:Recording)
    end

    it "doesn't load Reporting by default" do
      Rails = Object.new unless defined?(Rails)
      load "jiminy.rb"
      expect(Jiminy.constants).not_to include(:Reporting)
    end
  end
end
