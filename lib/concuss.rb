# frozen_string_literal: true

class Concuss
  class Error < StandardError; end
end

require_relative "concuss/version"
require_relative "concuss/headers"
require_relative "concuss/runner"
