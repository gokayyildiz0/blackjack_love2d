local Rules                        = require("src.game.rules")
local UI                           = require("src.util.ui")

local R                            = {}

local COLOR_BCK                   = { 0.95, 0.95, 0.95 }
local COLOR_TEXT                   = { 0, 0, 0 }
local COLOR_BTN                    = { 1, .5, .2 }
local COLOR_BTN_HOVER              = { 1, .8, .3 }
local COLOR_RED                    = { .89, .06, .39 }
local COLOR_BLACK                  = { .2, .2, .2 }

local CARD_W, CARD_H               = 53, 73
local CARD_SPACING                 = 60
local MARGIN_X                     = 10
local X_LEFT, X_MID                = 11, 21
local Y_TOP, Y_THIRD, Y_QTR, Y_MID = 7, 19, 23, 31

local function drawCard(images, card, x, y)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(images.card, x, y)
    love.graphics.setColor((card.suit == "heart" or card.suit == "diamond") and COLOR_RED or COLOR_BLACK)

    local function corner(img, ox, oy)
        love.graphics.draw(img, x + ox, y + oy)
        love.graphics.draw(img, x + CARD_W - ox, y + CARD_H - oy, 0, -1)
    end

    corner(images[card.rank], 3, 4)
    corner(images["mini_" .. card.suit], 3, 14)

    if card.rank > 10 then
        local face = (card.rank == 11 and images.face_jack) or (card.rank == 12 and images.face_queen) or
        images.face_king
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(face, x + 12, y + 11)
        return
    end

    local function pip(img, ox, oy, mx, my)
        local w = 11
        love.graphics.draw(img, x + ox, y + oy)
        if mx then love.graphics.draw(img, x + CARD_W - ox - w, y + oy) end
        if my then love.graphics.draw(img, x + ox + w, y + CARD_H - oy, 0, -1) end
        if mx and my then love.graphics.draw(img, x + CARD_W - ox, y + CARD_H - oy, 0, -1) end
    end
    local pimg = images["pip_" .. card.suit]

    if card.rank == 1 then
        pip(pimg, X_MID, Y_MID)
    elseif card.rank == 2 then
        pip(pimg, X_MID, Y_TOP, false, true)
    elseif card.rank == 3 then
        pip(pimg, X_MID, Y_TOP, false, true); pip(pimg, X_MID, Y_MID)
    elseif card.rank == 4 then
        pip(pimg, X_LEFT, Y_TOP, true, true)
    elseif card.rank == 5 then
        pip(pimg, X_LEFT, Y_TOP, true, true); pip(pimg, X_MID, Y_MID)
    elseif card.rank == 6 then
        pip(pimg, X_LEFT, Y_TOP, true, true); pip(pimg, X_LEFT, Y_MID, true)
    elseif card.rank == 7 then
        pip(pimg, X_LEFT, Y_TOP, true, true); pip(pimg, X_LEFT, Y_MID, true); pip(pimg, X_MID, Y_THIRD)
    elseif card.rank == 8 then
        pip(pimg, X_LEFT, Y_TOP, true, true); pip(pimg, X_LEFT, Y_MID, true); pip(pimg, X_MID, Y_THIRD, false, true)
    elseif card.rank == 9 then
        pip(pimg, X_LEFT, Y_TOP, true, true); pip(pimg, X_LEFT, Y_QTR, true, true); pip(pimg, X_MID, Y_MID)
    elseif card.rank == 10 then
        pip(pimg, X_LEFT, Y_TOP, true, true); pip(pimg, X_LEFT, Y_QTR, true, true); pip(pimg, X_MID, 16, false, true)
    end
end

local function drawButton(btn)
    local mx, my = love.mouse.getPosition()
    love.graphics.setColor(UI.isHover(btn, mx, my) and COLOR_BTN_HOVER or COLOR_BTN)
    love.graphics.rectangle("fill", btn.x, btn.y, btn.width, btn.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(btn.text, btn.x + btn.textOffsetX, btn.y + btn.textOffsetY)
end

function R.draw(State)
    local images = State.images
    local pTotal = Rules.playerTotal(State.playerHand)
    local dTotal = Rules.dealerTotal(State.dealerHand)
    -- Set background color
    love.graphics.clear(COLOR_BCK)
    -- Dealer row
    for i, card in ipairs(State.dealerHand) do
        local x = ((i - 1) * CARD_SPACING) + MARGIN_X
        local y = 30
        if not State.roundOver and i == 1 then
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(images.card_face_down, x, y)
        else
            drawCard(images, card, x, y)
        end
    end

    -- Player row
    for i, card in ipairs(State.playerHand) do
        local x = ((i - 1) * CARD_SPACING) + MARGIN_X
        drawCard(images, card, x, 140)
    end

    love.graphics.setColor(COLOR_TEXT)
    love.graphics.print(State.roundOver and ("Total: " .. dTotal) or "Total: ?", MARGIN_X, 10)
    love.graphics.print("Total: " .. pTotal, MARGIN_X, 120)

    if State.roundOver then
        drawButton(State.ui.again)
        love.graphics.setColor(COLOR_TEXT)
        love.graphics.print(State.endMessage(), MARGIN_X, 270)
    else
        drawButton(State.ui.hit)
        drawButton(State.ui.stand)
    end
end

return R
