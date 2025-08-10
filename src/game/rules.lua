local Rules = {}

local function getTotal(hand)
  local total, aces = 0, 0
  for _, c in ipairs(hand) do
    if c.rank == 1 then aces = aces + 1; total = total + 1
    elseif c.rank >= 11 then total = total + 10
    else total = total + c.rank end
  end
  while aces > 0 and total <= 11 do total = total + 10; aces = aces - 1 end
  return total
end

function Rules.playerTotal(hand) return getTotal(hand) end
function Rules.dealerTotal(hand) return getTotal(hand) end

function Rules.dealerPlay(deck, dealerHand, soft17Hits)
  while true do
    local d = getTotal(dealerHand)
    local soft = (function()
      local t, a = 0, 0
      for _, c in ipairs(dealerHand) do
        if c.rank == 1 then a = a + 1; t = t + 1
        elseif c.rank >= 11 then t = t + 10
        else t = t + c.rank end
      end
      return a > 0 and t <= 11
    end)()
    local hit = (d < 17) or (soft17Hits and d == 17 and soft)
    if not hit then break end
    if deck.size() == 0 then deck.reset() end
    deck.draw(dealerHand, 1)
  end
end

function Rules.endRound(playerHand, dealerHand)
  local p, d = getTotal(playerHand), getTotal(dealerHand)
  if p > 21 and d > 21 then return "Both bust! Dealer wins by house rules."
  elseif p > 21 then return "Dealer wins!"
  elseif d > 21 then return "Player wins!"
  elseif p > d   then return "Player wins!"
  elseif d > p   then return "Dealer wins!"
  else return "It's a tie!" end
end

return Rules
