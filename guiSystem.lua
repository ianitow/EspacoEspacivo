Gui = {
	["bars"] = {}
}
	

local screenWidth,screenHeight = love.graphics.getDimensions()

Gui.__index = Gui

function Gui.new()
	local gui = {}
	setmetatable(gui,Gui)
	
	--Init instace
	gui.bars= {}
	return gui
end



function Gui:createBar(id,x,y,minValue,maxValue,hexCodeFill,hexCodeLine,largura)
	if(id ~= nil)then
		Gui.bars[id] = {
			currentValue = maxValue,
			x=x,
			y=y,
			maxValue = maxValue,
			minValue = minValue,
			hexCodeFill = hexCodeFill,
			hexCodeLine = hexCodeLine,
			height = largura

		}
		return Gui.bars[id]
	end
end

function Gui:drawBar(idBar)
	local bar = Gui.bars[idBar]
	if(bar ~= nil) then
		local r,g,b,a = toRGBA(bar.hexCodeFill)
		love.graphics.setColor(r,g,b,a)	
		if(bar.currentValue*2 <=0) then
			bar.currentValue = 0
		end

		love.graphics.rectangle("fill",bar.x, bar.y, bar.currentValue*2, bar.height/35)
		r,g,b,a = toRGBA(bar.hexCodeLine)
		love.graphics.setColor(r,g,b,a)
		love.graphics.rectangle("line",bar.x, bar.y, bar.maxValue*2, bar.height/35)
	end	
end

function Gui:updateBar(id,currentValue)
	if(Gui.bars[id]) then
		Gui.bars[id].currentValue = currentValue
	end
end

function Gui:createText(text,x,y,height)
	local font = love.graphics.newFont(height)
	love.graphics.setFont(font)
	love.graphics.print(text, x, y)
end


function toRGBA(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)), tonumber("0x"..hex:sub(7,8))
end

