define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"

  class PlayerActor extends LDFW.Actor
    constructor: (@app, @game) ->
      super @game

      @player = @game.player

      @width = 32
      @height = 64

    update: ->
      super
      @position.set @player.position

    draw: (context) ->
      context.fillStyle = "red"
      context.fillRect @position.x, @position.y - @height, @width, @height

  module.exports = PlayerActor
