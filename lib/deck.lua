local function Deck(initialContents)
	local self = {
		contents = initialContents or {},
	}

	local function build()
		if #self.contents == 0 then
			for _, suit in ipairs({ "club", "heart", "spade", "diamond" }) do
				for rank = 1, 13 do
					table.insert(self.contents, { suit = suit, rank = rank })
				end
			end
		end
	end

	local function shuffle()
		for i = #self.contents, 2, -1 do
			local j = love.math.random(i)
			self.contents[i], self.contents[j] = self.contents[j], self.contents[i]
		end
	end

	local function draw(hand, amount)
		for i = 1, amount do
			if #self.contents == 0 then
				break
			end
			table.insert(hand, table.remove(self.contents))
		end
	end

	local function size()
		return #self.contents
	end
	local function reset()
		self.contents = {}
		build()
	end

	return {
		build = build,
		shuffle = shuffle,
		draw = draw,
		reset = reset,
		size = size,
		getContents = function()
			return self.contents
		end,
	}
end

return Deck
