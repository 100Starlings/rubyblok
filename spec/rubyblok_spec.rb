require_relative '../lib/rubyblok/cli'

describe Rubyblok::CLI do
  let(:rubyblok) { described_class.new }
  let(:task) { "fake_command"}

  it "Setup" do
    expect(rubyblok.setup).to eql("Setting up Rubyblok environment...")
  end

  it "Console" do
    expect(rubyblok.console).to eql("Opening Rubyblok console...")
  end

  it "Rails" do
    expect(rubyblok.rails(task)).to eql("Executing Rails task: #{task}...")
  end
end
