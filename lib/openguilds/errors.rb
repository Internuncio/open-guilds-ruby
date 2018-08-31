module Openguild
  class MissingParametersError < StandardError
  end

  class APIKeyNotSet < StandardError
  end

  class APIKeyIncorrect < StandardError
  end
end
