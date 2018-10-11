RSpec.describe OpenGuilds::Util do
  describe '#object_from' do
    let(:result) { described_class.object_from(example_object_hash) }
    it 'should return the correct object' do
      expect(result).to be_a OpenGuilds::Batch
    end
  end

  describe "#encode_parameters" do
    it " should prepare parameters for an HTTP request" do
      params = {
        a: 3,
        b: "+foo?",
        c: "bar&baz",
        d: { a: "a", b: "b" },
        e: [0, 1],
        f: "",

        # note the empty hash won't even show up in the request
        g: [],
      }

      expect(
        OpenGuilds::Util.encode_parameters(params)
      ).to eq expected_encoded_params
    end
  end

  describe '#url_encode' do
    it "should prepare strings for HTTP" do
      expect(OpenGuilds::Util.url_encode("foo")).to eq "foo"
      expect(OpenGuilds::Util.url_encode(:foo)).to eq "foo"
      expect(OpenGuilds::Util.url_encode("foo+")).to eq "foo%2B"
      expect(OpenGuilds::Util.url_encode("foo&")).to eq "foo%26"
      expect(OpenGuilds::Util.url_encode("foo[bar]")).to eq "foo[bar]"
    end
  end

  describe '#flatten_params' do
    it "should encode parameters according to Rails convention" do
      params = [
        [:a, 3],
        [:b, "foo?"],
        [:c, "bar&baz"],
        [:d, { a: "a", b: "b" }],
        [:e, [0, 1]],
        [:f, [
          { foo: "1", ghi: "2" },
          { foo: "3", bar: "4" },
        ],],
      ]

      expect(
        OpenGuilds::Util.flatten_params(params)
      ).to eq params_array
    end
  end

  def expected_encoded_params
    "a=3&b=%2Bfoo%3F&c=bar%26baz&d[a]=a&d[b]=b&e[0]=0&e[1]=1&f="
  end

  def params_array
    [
      ["a", 3],
      ["b",        "foo?"],
      ["c",        "bar&baz"],
      ["d[a]",     "a"],
      ["d[b]",     "b"],
      ["e[0]",      0],
      ["e[1]",      1],

      # *The key here is the order*. In order to be properly interpreted as
      # an array of hashes on the server, everything from a single hash must
      # come in at once. A duplicate key in an array triggers a new element.
      ["f[0][foo]", "1"],
      ["f[0][ghi]", "2"],
      ["f[1][foo]", "3"],
      ["f[1][bar]", "4"],
    ]
  end

  def example_object_hash
{"object"=>"Batch", "id"=>1, "status"=>"Completed", "completed"=>true, "fraction_completed"=>"3/3", "data"=>[{"object"=>"Datum", "status"=>"completed", "parameters"=>{"data"=>"[{\"id\":0,\"text\":\"There be dragons\",\"start\":\"00:00\",\"end\":\"00:05\",\"subject\":\"Speaker 1\"}]"}, "contracts_count"=>1}, {"object"=>"Datum", "status"=>"completed", "parameters"=>{"data"=>"[{\"id\":0,\"text\":\"Where!?\",\"start\":\"00:05\",\"end\":\"00:07\",\"subject\":\"Speaker 2\"}]"}, "contracts_count"=>1}, {"object"=>"Datum", "status"=>"completed", "parameters"=>{"data"=>"[{\"id\":0,\"text\":\"In your kitchen.\",\"start\":\"00:08\",\"end\":\"00:10\",\"subject\":\"Speaker 1\"}]"}, "contracts_count"=>1}]}
  end
end
