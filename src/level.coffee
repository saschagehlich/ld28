define (require, exports, module) ->
  LDFW = require "ldfw"
  Platform = require "level/platform"
  Ladder = require "level/ladder"

  class Level
    @GRID_SIZE: 20
    floorHeight: 40
    constructor: (@app, @game) ->
      @gravity = new LDFW.Vector2 0, 5000
      @platforms = []
      @ladders = []

      @scroll = new LDFW.Vector2

      @platforms.push new Platform @app, @game, {
        position: new LDFW.Vector2 4, 10
        width: 13
      }
      @platforms.push new Platform @app, @game, {
        position: new LDFW.Vector2 10, 17
        width: 8
      }
      @platforms.push new Platform @app, @game, {
        position: new LDFW.Vector2 20, 21
        width: 8
      }

      @ladders.push new Ladder @app, @game, {
        position: new LDFW.Vector2 9, 3
        height: 7
      }
      @ladders.push new Ladder @app, @game, {
        position: new LDFW.Vector2 14, 10
        height: 7
      }

    update: -> debug

    isMobTouchingLadder: (mob) ->
      for ladder in @ladders
        ladderPosition = ladder.position
          .clone()
          .multiply Level.GRID_SIZE
        ladderHeight = ladder.height * Level.GRID_SIZE
        ladderWidth = Level.GRID_SIZE * 2

        # Horizontal check
        minCoverage = 0.3 * Level.GRID_SIZE
        unless (mob.position.x + mob.width < ladderPosition.x + minCoverage or
          mob.position.x > ladderPosition.x + ladderWidth - minCoverage)

            # Vertical check
            ladderY = (@app.getHeight() - ladderPosition.y - ladderHeight)
            unless (mob.position.y <= ladderY or
              mob.position.y - mob.height >= ladderY + ladderHeight)
                intersection = true
                return true

      return false

    getBoundariesForObject: (obj) ->
      boundaries =
        x:
          min: 0
          max: 1000
          object: null
        y:
          min: 0
          max: @app.getHeight() - @floorHeight
          object: null

      # Check for platform collisions
      for platform in @platforms
        platformPosition = platform.position
          .clone()
          .multiply Level.GRID_SIZE
        platformWidth = platform.width * Level.GRID_SIZE

        # Horizontal check
        if obj.position.x + obj.width > platformPosition.x and
          obj.position.x < platformPosition.x + platformWidth

            # Vertical check
            platformY = (@app.getHeight() - platformPosition.y)
            if obj.position.y <= platformY <= boundaries.y.max
              boundaries.y.max = platformY

      return boundaries

  module.exports = Level
