local State  = require("src.game.state")
local Input  = require("src.systems.input")
local Render = require("src.systems.render")

function love.load()
  love.window.setTitle("Blackjack")
  love.math.setRandomSeed(os.time())
  State.loadAssets("assets/images")
  State.resetRound()  -- creates deck, shuffles, deals
end

function love.update(dt)
  -- keep empty for now (animations/timers later)
end

function love.draw()
	
  Render.draw(State)
end

function love.keypressed(key)
  Input.keypressed(State, key)
end

function love.mousereleased(x, y, button)
  Input.mousereleased(State, x, y, button)
end
