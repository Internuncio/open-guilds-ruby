RSpec.describe Openguilds do
  it "has a version number" do
    expect(Openguilds::VERSION).not_to be nil
  end

  it "has a base api path" do
    expect(Openguilds.api_base).not_to be nil
  end

  it "can set an api key" do
    Openguilds.api_key = "xxx-xxx-xxx"
    expect(Openguilds.api_key).to eq "xxx-xxx-xxx"
  end
end
