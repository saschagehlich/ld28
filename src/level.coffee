define (require, exports, module) ->
  LDFW = require "ldfw"

  class Level
    constructor: (@app, @game) ->
      @gravity = new LDFW.Vector2 0, 1200

    update: (delta) ->
      return

  module.exports = Level