require("monster")
Wave = {
	--["staticBackground"] = love.graphics.newImage("resources/background.png"),
	["max_stars"] = 600,
	["score"] = 0
}

Wave.__index = Wave

function Wave.new(idWave,waveName,typeMonsters,numberOfMonsters)
	local wavetbl = {}
	setmetatable(wavetbl, Wave)
	screenWidth,screenHeight = love.graphics.getDimensions()
	wavetbl.monsters = {}
	wavetbl.stars = {}
	wavetbl.velocity = 100
	wavetbl.id = idWave
	wavetbl.waveName = waveName

	for i=1, Wave.max_stars do   -- generate the coords of our stars
      local posX = love.math.random(5,screenWidth-5)   -- generate a "random" number for the x coord of this star
      local posY = love.math.random(5, screenHeight-5)   -- both coords are limited to the screen size, minus 5 pixels of padding
    	wavetbl.stars[i] = {x = posX, y=posY} 
    end

	return wavetbl
end


---------------------------------------------CALLBACK METHODS--------------------------------------------
function Wave:update(dt)
	self:backgroundUpdate(dt)
	self:monstersUpdate(dt)
	self:waveUpdate(dt)
end

function Wave:draw()
	self:drawBackground()
	self:drawMonsters()
end


-----------------------------------------------DRAW METHODS---------------------------------------------
--Desenha o background
function Wave:drawBackground()
	local table_stars = {}
	for index,value in pairs(self.stars)do
		table.insert(table_stars,index,{value.x,value.y})
	end
	return love.graphics.points(table_stars)  
end

function Wave:drawMonsters(dt)
	if(self.monsters)then
		for index, value in ipairs(self.monsters)do
			value:draw()
		end
	end
end

---------------------------------------------UPDATE METHODS----------------------------------------------

--Cria a ilusão de que a nave está viajando pelo espaço.
function Wave:backgroundUpdate(dt)
	for index, star in pairs(self.stars) do
		if not (star.y >= (screenHeight+5))then
			star.y = star.y + self.velocity*dt
		else
			table.remove(self.stars,index)
			table.insert(self.stars,{x =love.math.random(screenWidth-5),y=1})
		end
	end
end
local e = 0
function Wave:waveUpdate(dt)
	if(#self.monsters == 0) then
		self.id = self.id +1
		self:startWave()
	end
end

function Wave:monstersUpdate(dt)
	if(self.monsters)then
		for index, value in pairs (self.monsters) do
			if(value:isDead()) then
				value.drawable = false
			
				if(#value.bullets == 0) then
					table.remove(self.monsters,index)
					Wave.score = Wave.score + math.random(10)
				end	
			end
			value:update(dt)
		end
	end
end
------------------------------------Simply getters and setters methods-----------------------------------

function Wave:setName(name)
	if(name)then
		self.waveName = name
		return true
	end
end

function Wave:getName()
	return self.waveName
end

function Wave:setID(id)
	if(type(id) == "number") then
		self.id = id
		return true
	end
end

function Wave:getID()
	return self.id
end

function Wave:getMonsters()
	return self.monsters
end


----------------------------------------------OTHERS METHODS------------------------------------------------

function Wave:createMonsters(quantity)
	for i=1, quantity do
		local random  = (love.math.random(0,1) == 0 and true or false)
		local randomPosition = love.math.random(50,height)
		local randomBullet = love.math.random(1,3)
		local monster = Monster.new(randomPosition,10,100,random)
		monster:setBullet(randomBullet)
		table.insert(self.monsters, i, monster)
	end
end

function Wave:startWave()
	self.monsters = {}
	if(self.id == 1) then
		self:createMonsters(10)
	elseif(self.id == 2) then
		self:createMonsters(25)
	elseif(self.id == 3) then
		self:createMonsters(35)
	end
end
