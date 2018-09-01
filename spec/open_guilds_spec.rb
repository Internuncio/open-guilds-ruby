RSpec.describe OpenGuilds do
  it "has a version number" do
    expect(OpenGuilds::VERSION).not_to be nil
  end

  it "has a base api path" do
    expect(OpenGuilds.api_base).not_to be nil
  end

  it "can set an api key" do
    OpenGuilds.api_key = "xxx-xxx-xxx"
    expect(OpenGuilds.api_key).to eq "xxx-xxx-xxx"
  end
end
