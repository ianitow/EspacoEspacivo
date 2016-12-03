Monster = {
["image"] = "resources/enemy.png",
["bulletImage"] = "resources/bullet1.png",
["bulletsName"] = {"Classic","Two weapons", "Third weapons"}
}
Monster.__index = Monster

width, height = love.graphics.getDimensions( )
	
local random = love.math.random()
local r,g,b,a = 255,255,255,255

function Monster.new(x,y,life,state)
	local tblmonster = {}
	setmetatable(tblmonster,Monster)
	tblmonster.x = x
	tblmonster.y  = y
	tblmonster.life = life
	tblmonster.speed = 220
	tblmonster.drawable = true
	tblmonster.type = type
	tblmonster.state = state
	tblmonster.currentWeapon = Monster.bulletsName[3]
	tblmonster.bulletImage = love.graphics.newImage(Monster.bulletImage)
	tblmonster.image = love.graphics.newImage(Monster.image)
	tblmonster.bullets = {}
	return tblmonster
end


----------------------------------------CALLBACK FUNCTIONS--------------------------------
function Monster:update(dt)
	self:updateMovements(dt)
	self:updateBullets()
	self:whenAttack(dt)
end

function Monster:draw()
	self:drawMonster()
	self:drawAttack()
end

-----------------------------------------------UPDATE METHODS------------------------------
function Monster:updateBullets()
	for index,bullets in pairs(self.bullets) do
		bullets.y = bullets.y +10
		if(bullets.y > (height+100)) then
			self.bullets[index] = nil
		end
	end
end
function Monster:updateMovements(dt)
	if(self.state) then
		local position = self:move('right',dt)
		if((position + self.image:getWidth()) >= width) then
			self.state = false
		end
	else
		local position = self:move('left',dt)
		if((position ) <= 0)then
			self.state = true
		end
	end
end

local elapsed = 0
function Monster:whenAttack(dt)
	elapsed = elapsed + dt
	if(elapsed >= 1) then
		self:attack(self.currentWeapon)	
		elapsed = 0
	end
end

-----------------------------------------------DRAW METHODS--------------------------------

function Monster:drawMonster()
	if(self.drawable)then
		return love.graphics.draw(self.image, self.x,self.y)
	end
end

function Monster:drawAttack()
	for index,bullets in pairs(self.bullets) do
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.bulletImage, bullets.x,bullets.y )
	end
end


----------------------------------Simply getters and setters methods-----------------------

function Monster:getPositions()
	local posX,posY,width,height = self.x,self.y,self.image:getDimensions()
	return posX,posY,width,height
end

function Monster:getInstance()
	return self
end

function Monster:setBullet(index)
	if(index and index <= #Monster.bulletsName)then
		self.currentWeapon = Monster.bulletsName[index]
	end
end
function Monster:isDead()
	if(self.life <= 0 )then
		return true
	end
	return false
end

--------------------------------------- OTHERS METHODS ----------------------------------


function Monster:move(side,dt)
	if(side == 'left') then
		self.x = self.x - self.speed * dt
		return self.x
	end
	if(side == 'right') then
		self.x = self.x + self.speed * dt
		return self.x
	end
end


function Monster:attack(name)
	if name == nil then
		return nil
	end 	
	if(self.drawable)then
		local bullet_sound = love.audio.newSource("resources/bullet.wav", "static")
		local bulletOne = {i=3,x = self.x+35,y = self.y+8,damage=15}
		local bulletTwo = {i=2,x = self.x + 60, y = self.y+20,damage=25}
		local bulletThird = {i=1,x = self.x+ 10, y = self.y+20,damage=30}
		if(name == "Classic") then
			table.insert(self.bullets,bulletOne)
		elseif(name == "Two weapons") then
			table.insert(self.bullets,bulletOne)
			table.insert(self.bullets, bulletTwo)
		elseif(name == "Third weapons") then
			table.insert(self.bullets,bulletOne)
			table.insert(self.bullets, bulletTwo)
			table.insert(self.bullets,bulletThird)
		end
	end
end


function Monster:updateBulletsCollision(instance)
	local posX,posY,width,height = instance:getPositions()
	for index, bullets in pairs(self.bullets) do
		local bX,bY = bullets.x,bullets.y
		if(bX >= posX and bX<=(posX+height))then
			if(bY>=posY and bY <=(posY+width))then
				self:onBulletCollideImage(index,instance)
				return bullets,instance
			end
		end
	end
end

----------------------------------------------EVENTS-------------------------------------

function Monster:onDamaged(damageValue)
	if(damageValue)then
		self.life = self.life - damageValue
	end
end


function Monster:onBulletCollideImage(indexBullet,instance)
	if(indexBullet and instance) then
		instance:onDamaged(self.bullets[indexBullet].damage)
		self.bullets[indexBullet] = nil
		return true
	end
end