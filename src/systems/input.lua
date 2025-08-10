local Rules = require("src.game.rules")
local UI    = require("src.util.ui")

local SOFT_17_DEALER_HITS = false

local Input = {}

local function playerHit(State)
  State.deck.draw(State.playerHand, 1)
  if Rules.playerTotal(State.playerHand) > 21 then
    -- player busts, round ends immediately
    State.roundOver = true
  end
end

local function playerStand(State)
  Rules.dealerPlay(State.deck, State.dealerHand, SOFT_17_DEALER_HITS)
  State.roundOver = true
end

function Input.keypressed(State, key)
  if State.roundOver then
    State.resetRound(); return
  end
  if key == "h" then playerHit(State)
  elseif key == "s" then playerStand(State) end
end

function Input.mousereleased(State, x, y, button)
  if State.roundOver then
    if UI.isHover(State.ui.again, x, y) then State.resetRound() end
    return
  end

  if UI.isHover(State.ui.hit, x, y) then
    playerHit(State)
  elseif UI.isHover(State.ui.stand, x, y) then
    playerStand(State)
  end
end

return Input
