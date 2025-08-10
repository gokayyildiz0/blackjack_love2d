local Deck  = require("src.game.deck")
local Rules = require("src.game.rules")
local UI    = require("src.util.ui")

local State = {
  deck = nil,
  playerHand = {},
  dealerHand = {},
  roundOver = false,
  images = {},
  ui = {
    hit   = UI.Button(10, 230, 53, 25, "Hit!",   16, 6),
    stand = UI.Button(70, 230, 53, 25, "Stand",   8, 6),
    again = UI.Button(10, 230,113, 25, "Play again", 24, 6),
  }
}

function State.loadAssets(path)
  local names = {
    1,2,3,4,5,6,7,8,9,10,11,12,13,
    "pip_heart","pip_diamond","pip_club","pip_spade",
    "mini_heart","mini_diamond","mini_club","mini_spade",
    "card","card_face_down","face_jack","face_queen","face_king",
  }
  for _, n in ipairs(names) do
    State.images[n] = love.graphics.newImage(("%s/%s.png"):format(path, n))
  end
end

function State.resetRound()
  State.playerHand, State.dealerHand = {}, {}
  State.roundOver = false
  State.deck = Deck()
  State.deck.seed(os.time())
  State.deck.build()
  State.deck.shuffle()
  State.deck.draw(State.playerHand, 2)
  State.deck.draw(State.dealerHand, 2)
end

function State.endMessage()
  return Rules.endRound(State.playerHand, State.dealerHand)
end

return State
