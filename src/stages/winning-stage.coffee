define (require, exports, module) ->
  ###
   * Module dependencies
  ###
  LDFW = require "ldfw"
  ExitActor = require "actors/exit-actor"
  PackageActor = require "actors/package-actor"

  ###
   * WinningStage definition
  ###
  class WinningStage extends LDFW.Stage
    constructor: (@app, @game) ->
      super @game

      {@fontsSheet} = @app

      @exitActor = new ExitActor @app, @game
      @packageActor = new PackageActor @app, @game

      @keyboard = new LDFW.Keyboard

      @smallWhiteFont = new LDFW.BitmapFont(
        @app.preloader.get("assets/fonts/pixel-8.fnt"),
        @fontsSheet.findRegion("pixel-8-white.png"),
      )
      @smallGreyFont = new LDFW.BitmapFont(
        @app.preloader.get("assets/fonts/pixel-8.fnt"),
        @fontsSheet.findRegion("pixel-8-grey.png"),
      )
      @biggerGreenFont = new LDFW.BitmapFont(
        @app.preloader.get("assets/fonts/pixel-16.fnt"),
        @fontsSheet.findRegion("pixel-16-green.png"),
      )

    update: (delta) ->
      super
      @game.winner.onGround = false
      @game.winner.direction = 1
      @game.package.detach()
      @game.winner.actor.update delta

      if @keyboard.pressed(@keyboard.Keys.ENTER) and @app.hasNextLevel()
        @app.nextLevel()
      else if @keyboard.pressed(@keyboard.Keys.ESC)
        @app.switchToSplashScreen()

    draw: (context) ->
      {width, height} = context.canvas

      context.fillStyle = "rgba(0, 0, 0, 0.92)"
      context.fillRect 0, 0, width, height

      @_drawText context
      @_drawWinner context

    _drawWinner: (context) ->
      @exitActor.draw context,
        @app.getWidth() / 2 - @exitActor.width / 2,
        100,
        true

      @packageActor.draw context,
        @app.getWidth() / 2 - @packageActor.width / 2,
        184

      winnerActor = @game.winner.actor
      winnerActor.draw context,
        @app.getWidth() / 2 - winnerActor.width / 2,
        156

    _drawText: (context) ->
      # HEADLINE
      if @app.hasNextLevel()
        text = "LEVEL PASSED"
      else
        text = "YOU DID IT!"

      bounds = @biggerGreenFont.getBounds text
      @biggerGreenFont.drawText context, text, @app.getWidth() / 2 - bounds.width / 2, 220

      # HELL YEAH - HAVE FUN...
      if @app.hasNextLevel()
        text = "HELL YEAH!"
      else
        text = "YOU MASTERED ALL LEVELS"

      bounds = @smallWhiteFont.getBounds text
      @smallWhiteFont.drawText context, text, @app.getWidth() / 2 - bounds.width / 2, 260

      if @app.hasNextLevel()
        text = "HAVE FUN WITH YOUR CONSOLE!"
      else
        text = "NOW GO PLAY WITH YOUR PLAYSTATION 4"
      bounds = @smallWhiteFont.getBounds text
      @smallWhiteFont.drawText context, text, @app.getWidth() / 2 - bounds.width / 2, 275

      # YOUR SCORE
      text = "YOUR SCORE:"
      bounds = @smallWhiteFont.getBounds text
      @smallWhiteFont.drawText context, text, @app.getWidth() / 2 - bounds.width / 2, 320

      # SCORE
      if @app.hasNextLevel()
        text = "I DON'T KNOW!!"
      else
        text = "I STILL DON'T KNOW!"

      bounds = @biggerGreenFont.getBounds text
      @biggerGreenFont.drawText context, text, @app.getWidth() / 2 - bounds.width / 2, 335

      # PRESS ENTER TO PLAY NEXT LEVEL
      if @app.hasNextLevel()
        text = "PRESS "
        buttonText = "ENTER"
        restText = " TO PLAY THE NEXT LEVEL"
      else
        text = "PRESS "
        buttonText = "ESC"
        restText = " TO RETURN TO THE MAIN MENU"

      textBounds = @smallWhiteFont.getBounds text
      buttonBounds = @smallWhiteFont.getBounds buttonText
      restBounds = @smallWhiteFont.getBounds restText

      totalWidth = textBounds.width + buttonBounds.width + restBounds.width

      startX = @app.getWidth() / 2 - totalWidth / 2
      y = 424
      usedWidth = 0

      @smallWhiteFont.drawText context, text, startX + usedWidth, y
      usedWidth += textBounds.width

      @smallGreyFont.drawText context, buttonText, startX + usedWidth, y
      usedWidth += buttonBounds.width

      @smallWhiteFont.drawText context, restText, startX + usedWidth, y


  ###
   * Expose WinningStage
  ###
  module.exports = WinningStage
