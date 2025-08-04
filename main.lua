local deck = {}
local playerHand = {}
local dealerHand = {}
local roundOver = false
local function buildDeck()
	d = {}
	for _, suit in ipairs({ "club", "heart", "spade", "diamond" }) do
		for rank = 1, 13 do
			table.insert(d, { suit = suit, rank = rank })
		end
	end
	return d
end

local function shuffle()
	for i = #deck, 2, -1 do
		local j = love.math.random(i)
		deck[i], deck[j] = deck[j], deck[i]
	end
end

local function drawCards(deck, hand, amount)
	for i = 1, amount do
		if #deck == 0 then
			break
		end
		table.insert(hand, table.remove(deck))
	end
end

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
--Love Load Function
function love.load()
	deck = buildDeck()
	shuffle(deck)
	drawCards(deck, playerHand, 2)
	drawCards(deck, dealerHand, 2)
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

	love.graphics.print(table.concat(output, "\n"), 15, 15)
end
-- Love Keypressed Function
function love.keypressed(key)
	if key == "h" then
		if #deck > 0 then
			drawCards(deck, playerHand, 1)
		end
	elseif key == "s" then
		roundOver = true
	end
end
