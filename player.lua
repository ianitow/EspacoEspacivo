--[[

	@Author: Iaan Mesquita
	@Since: 1.0
	@Description: Simples jogo de batalha no espaço
	
	Magic. Do not touch this.

]]
--Static attributes

Player = {
	["image"] = "resources/player01.png",
	["bulletImage"] = "resources/bullet.png",
	["bulletsName"] = {"Classic","Two weapons", "Third weapons"}
	
}

Player.__index = Player

function Player.new(posX,posY,lifes,energy)
	local ply = {}
	setmetatable(ply,Player)
	
	--Init instace
	
	ply.posX,ply.posY,ply.health,ply.energy = posX,posY,lifes,energy
	ply.playerImage = love.graphics.newImage(Player.image)
	ply.bulletImage = love.graphics.newImage(Player.bulletImage)
	ply.currentWeapon = Player.bulletsName[3]
	ply.bullets={}
	return ply
end

--CALLBACK FUNCTIONS

function Player:update(...)
	local args = unpack{...}
	self:updateBullets(args)
	self:updateKeys(args)
	self:updateEnergy(args)
	self:updateLife(args)
end

function Player:draw()
	self:drawPlayer()
	self:drawAttack()
end
-------------------------------------------DRAW METHODS---------------------------------------------
function Player:drawPlayer()
	if not (self:isDead()) then
		return love.graphics.draw(self.playerImage,self.posX,self.posY)
	end
end

function Player:drawAttack()
	for index,bullets in pairs(self.bullets) do
		if(self.currentWeapon == 'Classic')then
			love.graphics.setColor(255, 0, 0, 255)
			love.graphics.draw(self.bulletImage, bullets.x,bullets.y )
		elseif(self.currentWeapon == 'Two weapons') then
			love.graphics.setColor(0, 0, 255, 255)
			love.graphics.draw(self.bulletImage, bullets.x,bullets.y )
		elseif(self.currentWeapon == "Third weapons") then
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.draw(self.bulletImage, bullets.x,bullets.y )
		end
	end
end


----------------------------------------Update Methods-------------------------------------------
function Player:isDead()
	if(self.health <=0 ) then
		return true
	else
		return false
	end
end


function Player:updateEnergy()
	if(self.energy < 100) then
		self.energy = self.energy + 0.45
	end
end

function Player:updateLife()
	if(self.health <100) then
		self.health = self.health + 0.10
	end
end

function Player:updateBullets()
	for index,bullets in pairs(self.bullets) do
		bullets.y = bullets.y - 10
		if(bullets.y < -200) then
			self.bullets[index] = nil
		end
	end
end

function Player:updateKeys(dt)
	if(love.keyboard.isDown("left")) then
		if(self.posX >=0) then
			self:setPositions((self.posX - 500 *dt))
		end
	end

	if(love.keyboard.isDown("right")) then
		if((self.posX+ self.playerImage:getWidth()) <=width) then
			self:setPositions((self.posX + 500 * dt))
		end
	end

end
---------------------------------Simply getters and setters methods------------------------------

function Player:getEnergy()
	return self.energy
end


function Player:setLifes(number)
	if(number) then
		self.lifes = number
		return true
	end
end

function Player:setWeapon(weaponIndex)
	if(weaponIndex <= #Player.bulletsName) then
		self.currentWeapon = Player.bulletsName[weaponIndex]
	end
end

function Player:getWeapon()
	return self.currentWeapon
end



function Player:getInstance()
	return self
end

function Player:getHealth()
	return self.health
end
----------------------------------------OTHERS METHODS----------------------------------------------------


function Player:attack(name)
	if name == nil then
		return nil
	end 	
	if not self:isDead() then
		local bullet_sound = love.audio.newSource("resources/bullet.wav", "static")
		local bulletOne = {i=3,x = self.posX+35,y = self.posY+8,damage=10}
		local bulletTwo = {i=2,x = self.posX + 60, y = self.posY+20,damage=30}
		local bulletThird = {i=1,x = self.posX+ 10, y = self.posY+20,damage=50}
			
		if(self.energy <=15) then
			return;
		end
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
	self:onPlayerAttack(name)
	love.audio.play(bullet_sound)
	end
end



function Player:getPositions()
	local posX,posY,width,height = self.posX,self.posY,self.playerImage:getDimensions()
	return posX,posY,width,height
end

function Player:setPositions(posX,posY)
	if(posX or posY) then
		local x = posX or self.posX
		local y = posY or self.posY
		self.posX, self.posY = math.floor(x), math.floor(y)
		return true
	end
end



-----------------------------------------------EVENTS---------------------------------------------

function Player:onDamaged(damageValue)
	if(damageValue)then
		self.health = self.health - damageValue
	end
end


function Player:onPlayerAttack(typeAttack)
	if(self.currentWeapon == 'Classic') then
		self.energy = self.energy - 5
	elseif(self.currentWeapon == 'Two weapons')then
		self.energy = self.energy - 10
		elseif(self.currentWeapon == 'Third weapons')then
		self.energy = self.energy - 15
	end
end


function Player:onBulletCollideImage(indexBullet,instance)
	if(indexBullet and instance) then
		instance:onDamaged(self.bullets[indexBullet].damage)
		self.bullets[indexBullet] = nil
		return true
	end
end


-----------------------------------------OTHERS METHODS-----------------------------------------

function Player:updateBulletsCollision(instance)
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

