module OpenGuilds
  class List
    attr_reader :url, :has_more, :data

    def initialize(params)
      @url = params[:url]
      @has_more = params[:has_more]
      @data = params[:data].map { |datum| Util.object_from(datum) }
    end
  end
end
