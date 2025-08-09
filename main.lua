local Deck = require("src.game.deck")
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
			aces = aces + 1
			total = total + 1
		elseif r >= 11 then
			total = total + 10
		else
			total = total + r
		end
	end
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
	deck = Deck()
	deck.build()
	deck.shuffle()
	deck.draw(playerHand, 2)
	deck.draw(dealerHand, 2)
end

local function dealerPlay()
	while getTotal(dealerHand) < 17 do
		if deck ~= nil then
			deck.draw(dealerHand, 1)
		end
	end
end

--Love Load Function
function love.load()
	love.window.setTitle("Blackjack Game")
	love.graphics.setBackgroundColor(1, 1, 1)
	love.math.setRandomSeed(os.time())
	images = loadImages()
	resetGame()
end

-- Love Draw Function
function love.draw()
	local cardWidth = 53
	local cardHeight = 73
	local xLeft = 11
	local xMid = 21
	local yTop = 7
	local yThird = 19
	local yQtr = 23
	local yMid = 31
	local cardSpacing = 60
	local marginX = 10





	local function drawCard(card, x, y)
		love.graphics.setColor(1, 1, 1)
		love.graphics.draw(images.card, x, y)

		if card.suit == 'heart' or card.suit == 'diamond' then
			love.graphics.setColor(.89, .06, .39)
		else
			love.graphics.setColor(.2, .2, .2)
		end




		local function drawCorner(image, offsetX, offsetY)
			love.graphics.draw(
				image,
				x + offsetX,
				y + offsetY
			)
			love.graphics.draw(
				image,
				x + cardWidth - offsetX,
				y + cardHeight - offsetY,
				0,
				-1
			)
		end

		drawCorner(images[card.rank], 3, 4)
		drawCorner(images['mini_' .. card.suit], 3, 14)
		if card.rank > 10 then
			local faceImage

			if card.rank == 11 then
				faceImage = images.face_jack
			elseif card.rank == 12 then
				faceImage = images.face_queen
			elseif card.rank == 13 then
				faceImage = images.face_king
			end

			love.graphics.setColor(1, 1, 1)
			love.graphics.draw(faceImage, x + 12, y + 11)
		else
			local function drawPip(offsetX, offsetY, mirrorX, mirrorY)
				local pipImage = images['pip_' .. card.suit]
				local pipWidth = 11

				love.graphics.draw(
					pipImage,
					x + offsetX,
					y + offsetY
				)
				if mirrorX then
					love.graphics.draw(
						pipImage,
						x + cardWidth - offsetX - pipWidth,
						y + offsetY
					)
				end
				if mirrorY then
					love.graphics.draw(
						pipImage,
						x + offsetX + pipWidth,
						y + cardHeight - offsetY,
						0,
						-1
					)
				end
				if mirrorX and mirrorY then
					love.graphics.draw(
						pipImage,
						x + cardWidth - offsetX,
						y + cardHeight - offsetY,
						0,
						-1
					)
				end
			end



			if card.rank == 1 then
				drawPip(xMid, yMid)
			elseif card.rank == 2 then
				drawPip(xMid, yTop, false, true)
			elseif card.rank == 3 then
				drawPip(xMid, yTop, false, true)
				drawPip(xMid, yMid)
			elseif card.rank == 4 then
				drawPip(xLeft, yTop, true, true)
			elseif card.rank == 5 then
				drawPip(xLeft, yTop, true, true)
				drawPip(xMid, yMid)
			elseif card.rank == 6 then
				drawPip(xLeft, yTop, true, true)
				drawPip(xLeft, yMid, true)
			elseif card.rank == 7 then
				drawPip(xLeft, yTop, true, true)
				drawPip(xLeft, yMid, true)
				drawPip(xMid, yThird)
			elseif card.rank == 8 then
				drawPip(xLeft, yTop, true, true)
				drawPip(xLeft, yMid, true)
				drawPip(xMid, yThird, false, true)
			elseif card.rank == 9 then
				drawPip(xLeft, yTop, true, true)
				drawPip(xLeft, yQtr, true, true)
				drawPip(xMid, yMid)
			elseif card.rank == 10 then
				drawPip(xLeft, yTop, true, true)
				drawPip(xLeft, yQtr, true, true)
				drawPip(xMid, 16, false, true)
			end
		end
	end



	for cardIndex, card in ipairs(dealerHand) do
		local dealerMarginY = 30
		if not roundOver and cardIndex == 1 then
			love.graphics.setColor(1, 1, 1)
			love.graphics.draw(images.card_face_down, marginX, dealerMarginY)
		else
			drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, dealerMarginY)
		end
	end

	for cardIndex, card in ipairs(playerHand) do
		drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 140)
	end

	love.graphics.setColor(0, 0, 0)

	if roundOver then
		love.graphics.print('Total: ' .. getTotal(dealerHand), marginX, 10)
	else
		love.graphics.print('Total: ?', marginX, 10)
	end

	love.graphics.print('Total: ' .. getTotal(playerHand), marginX, 120)

	if roundOver then
		local resultMessage = endRound()

		love.graphics.print(resultMessage, marginX, 268)
		love.graphics.print("Press any key to reset the game.", marginX, 298)
		return
	end
	local function drawButton(text, buttonX, buttonWidth, textOffsetX)
        local buttonY = 230
        local buttonHeight = 25

        if love.mouse.getX() >= buttonX
        and love.mouse.getX() < buttonX + buttonWidth
        and love.mouse.getY() >= buttonY
        and love.mouse.getY() < buttonY + buttonHeight then
            love.graphics.setColor(1, .8, .3)
        else
            love.graphics.setColor(1, .5, .2)
        end
        love.graphics.rectangle('fill', buttonX, buttonY, buttonWidth, buttonHeight)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(text, buttonX + textOffsetX, buttonY + 6)
    end

	drawButton('Hit!', 10, 53, 16)
	drawButton('Stand', 70, 53, 8)
	-- drawButton('Play again', 10, 113, 24)
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
			roundOver = true
		end
	elseif key == 's' then
		dealerPlay()
		roundOver = true
	end
end
