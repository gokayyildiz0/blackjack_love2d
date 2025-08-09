local Deck = require("lib/deck")
local deck = nil
local playerHand = {}
local dealerHand = {}
local roundOver = false
local images = {}

local function getTotal(hand)
	local total = 0
	local hasAce = false

	for _, card in ipairs(hand) do
		if card.rank > 10 then
			total = total + 10
		else
			total = total + card.rank
		end
	end
	if hasAce and total <= 11 then
		total = total + 10
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

--Love Load Function
function love.load()
	images = loadImages()
	deck = Deck()
	deck.build()
	deck.shuffle()
	deck.draw(playerHand, 2)
	deck.draw(dealerHand, 2)
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
		if getTotal(playerHand) <= 21 
		and (getTotal(dealerHand) > 21 
		or getTotal(playerHand) > getTotal(dealerHand)) then
			table.insert(output, "Player win!")
		elseif getTotal(dealerHand) <= 21 
		and (getTotal(playerHand) > 21 
		or getTotal(playerHand) < getTotal(dealerHand)) then
			table.insert(output, "Dealer win!")
		else
			table.insert(output, "It's a tie!")
		end
	else
		table.insert(output, "Press 'h' to hit or 's' to stand.")
	end

	love.graphics.print(table.concat(output, "\n"), 15, 15)
end

-- Love Keypressed Function
function love.keypressed(key)
	if key == "h" then
		if deck ~= nil then
			if deck.size() > 0 then
				deck.draw(playerHand, 1)
			end
		end
	elseif key == "s" then
		roundOver = true
	end
end
