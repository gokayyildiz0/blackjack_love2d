local UI = {}

function UI.Button(x, y, w, h, text, tx, ty)
  return { x=x, y=y, width=w, height=h, text=text, textOffsetX=tx or 8, textOffsetY=ty or 6 }
end

function UI.isHover(button, mx, my)
  return mx >= button.x and mx < button.x + button.width and
         my >= button.y and my < button.y + button.height
end

return UI
