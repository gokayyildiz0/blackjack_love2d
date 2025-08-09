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
local function endRound()
	local function hasHandWon(hand1, hand2)
	return getTotal(hand1) <= 21 
		and (getTotal(hand2) > 21 
		or getTotal(hand1) > getTotal(hand2))
	end

	if hasHandWon(playerHand, dealerHand) then
		return("Player wins!")
	elseif hasHandWon(dealerHand, playerHand) then
		return("Dealer wins!")
	else
		return("It's a tie!")
	end
end
local function resetGame()
	playerHand = {}
	dealerHand = {}
	roundOver = false
	if deck then
		deck.build()
		deck.shuffle()	
		deck.draw(playerHand, 2)
	deck.draw(dealerHand, 2)
	end
	
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
		table.insert(output, endRound())
	else
		table.insert(output, "Press 'h' to hit or 's' to stand.")
	end

	love.graphics.print(table.concat(output, "\n"), 15, 15)
end

-- Love Keypressed Function
function love.keypressed(key)
	if not roundOver then
	if key == "h" then
		if deck ~= nil then
			if deck.size() > 0 then
				deck.draw(playerHand, 1)
			end
		end
	elseif key == "s" then
		roundOver = true
	end
else
	resetGame()
end
end
