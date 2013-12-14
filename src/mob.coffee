define (require, exports, module) ->
  LDFW = require "ldfw"
  PhysicsObject = require "physics-object"

  class Mob extends PhysicsObject
    minPackageInteractionDelay: 300
    constructor: ->
      super

      {@package} = @game
      @speed = new LDFW.Vector2 500, 500
      @lastPackageInteraction = Date.now()

    canInteractWithPackage: ->
      return Date.now() - @lastPackageInteraction > @minPackageInteractionDelay

  module.exports = Mob
