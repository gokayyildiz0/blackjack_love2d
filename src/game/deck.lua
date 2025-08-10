local function Deck(initialContents)
  local self = { contents = initialContents or {} }
  local rng  = love.math.newRandomGenerator()

  local function seed(s) rng:setSeed(s) end
  local function build(opts)
    opts = opts or {}; local n = opts.decks or 1
    self.contents = {}
    for _=1,n do
      for _, suit in ipairs({"club","heart","spade","diamond"}) do
        for rank=1,13 do
          self.contents[#self.contents+1] = { suit=suit, rank=rank }
        end
      end
    end
  end
  local function shuffle()
    for i=#self.contents, 2, -1 do
      local j = rng:random(i)
      self.contents[i], self.contents[j] = self.contents[j], self.contents[i]
    end
  end
  local function draw(hand, amount)
    amount = tonumber(amount) or 1
    local drawn = {}
    for _=1,amount do
      if #self.contents == 0 then break end
      local c = table.remove(self.contents)
      drawn[#drawn+1] = c; if hand then hand[#hand+1] = c end
    end
    return drawn
  end
  local function size() return #self.contents end
  local function reset(opts) build(opts); shuffle() end

  return { seed=seed, build=build, shuffle=shuffle, draw=draw, size=size, reset=reset }
end

return Deck
