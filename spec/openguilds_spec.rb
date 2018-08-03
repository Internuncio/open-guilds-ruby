RSpec.describe Openguilds do
  it "has a version number" do
    expect(Openguilds::VERSION).not_to be nil
  end

  it "has a base api path" do
    expect(Openguilds.api_base).not_to be nil
  end
end
