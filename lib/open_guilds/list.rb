module OpenGuilds
  class List
    attr_reader :url, :has_more, :page, :data

    def initialize(params)
      @url = params[:url]
      @has_more = params[:has_more]
      @page = params[:page]
      @data = params[:data].map { |datum| Util.object_from(datum) }
    end
  end
end
