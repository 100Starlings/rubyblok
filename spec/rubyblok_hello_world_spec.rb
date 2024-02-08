require_relative '../lib/rubyblok/hello_world'

describe Rubyblok::Hello do
  let(:rubyblok) { described_class.new }

  it "say_hello" do
    expect(rubyblok.say_hello).to eql("hello world")
  end
end
