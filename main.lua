local Deck = require("lib/deck")
local deck = nil
local playerHand = {}
local dealerHand = {}
local roundOver = false
local images = {}

local function getTotal(hand)
	local total, aces = 0, 0
	for _, card in ipairs(hand) do
		local r = card.rank
		if r == 1 then
			aces = aces + 1 -- count Aces first
			total = total + 1
		elseif r >= 11 then
			total = total + 10 -- J,Q,K
		else
			total = total + r
		end
	end
	-- promote as many aces to 11 as possible
	while aces > 0 and total <= 11 do
		total = total + 10
		aces = aces - 1
	end
	return total
end
local function loadImages()
	local img = {}
	for _, name in ipairs({
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12,
		13,
		"pip_heart",
		"pip_diamond",
		"pip_club",
		"pip_spade",
		"mini_heart",
		"mini_diamond",
		"mini_club",
		"mini_spade",
		"card",
		"card_face_down",
		"face_jack",
		"face_queen",
		"face_king",
	}) do
		img[name] = love.graphics.newImage("images/" .. name .. ".png")
	end
	return img
end
local function endRound()
	local p = getTotal(playerHand)
	local d = getTotal(dealerHand)

	if p > 21 and d > 21 then
		return "Both bust! Dealer wins by house rules."
	elseif p > 21 then
		return "Dealer wins!"
	elseif d > 21 then
		return "Player wins!"
	elseif p > d then
		return "Player wins!"
	elseif d > p then
		return "Dealer wins!"
	else
		return "It's a tie!"
	end
end
local function resetGame()
	playerHand, dealerHand = {}, {}
	roundOver = false
	deck = Deck() -- fresh object prevents duplication
	deck.build()
	deck.shuffle()
	deck.draw(playerHand, 2)
	deck.draw(dealerHand, 2)
end

local function dealerPlay()
	-- Dealer hits to 17 (change to <=16 if you prefer)
	while getTotal(dealerHand) < 17 do
		if deck ~= nil then
			deck.draw(dealerHand, 1)
		end
	end
end

--Love Load Function
function love.load()
	love.window.setTitle("Blackjack Game")
  love.math.setRandomSeed(os.time())
  images = loadImages()
  resetGame()
end

-- Love Draw Function
function love.draw()
	local output = {}

	table.insert(output, "Player Hand: ")
	for _, card in ipairs(playerHand) do
		table.insert(output, "suit: " .. card.suit .. ", rank: " .. card.rank)
	end
	table.insert(output, "Total: " .. getTotal(playerHand))
	table.insert(output, "")
	table.insert(output, "Dealer Hand: ")
	for _, card in ipairs(dealerHand) do
		table.insert(output, "suit: " .. card.suit .. ", rank: " .. card.rank)
	end
	table.insert(output, "Total: " .. getTotal(dealerHand))
	table.insert(output, "")
	if roundOver then
		table.insert(output, endRound())
	else
		table.insert(output, "Press 'h' to hit or 's' to stand.")
	end

	love.graphics.print(table.concat(output, "\n"), 15, 15)
end

-- Love Keypressed Function
function love.keypressed(key)
	if roundOver then
		resetGame()
		return
	end
	if key == 'h' then
		if deck ~= nil then
			deck.draw(playerHand, 1)
		end
		local p = getTotal(playerHand)
		if p > 21 then
			-- player busts: end round immediately, no dealer draw
			roundOver = true
		end
	elseif key == 's' then
		dealerPlay()
		roundOver = true
	end
end
