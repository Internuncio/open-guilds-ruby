RSpec.describe OpenGuilds do
  it "has a version number" do
    expect(OpenGuilds::VERSION).not_to be nil
  end

  it "has a base api path" do
    expect(OpenGuilds.api_base).not_to be nil
  end
end
