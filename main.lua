require("player")
require("wave")
require("guiSystem")
require("monster")

function love.load()

	width, height = love.graphics.getDimensions( )
	love.window.setFullscreen(true)


	--Propriedades do monstro

	--Load do mapa
	wave = Wave.new(1,"CHUVA DE FOGO")
	wave:startWave()

	--Load do player
	spaceShip = Player.new(680,680,100,100)
	
	--Load de GUI
	guiInfo = Gui.new()
	
	--"#FF0F00FF"
	local healthBar = guiInfo:createBar("health",(width-220),5,1,100,"#FF0000EE","#ff0f00FF",600)
	local energyBar = guiInfo:createBar("energy",(width-220),25,1,100,"#0000FFFFF","#0000FFFFF",250)

	
end

function love.update(dt)	
	
	--Update do player
	spaceShip:update(dt)
	updateCollision(wave,spaceShip)
	guiInfo:updateBar("energy",spaceShip:getEnergy())
	guiInfo:updateBar("health",spaceShip:getHealth())
	
	--Update das posições
	x,y = spaceShip:getPositions()
	love.timer.sleep(0.01)

	--Update do mapa
	wave:update(dt)
	updateMonsterCollision(wave,spaceShip)



end
 

function love.draw()
	love.graphics.setColor(255, 255, 255,255)
    
	guiInfo:createText("Score:"..Wave.score,0,0,20)

	guiInfo:createText("Fase: "..wave:getName(),0,20,20)

	if(spaceShip:isDead())then
		guiInfo:createText("GAME OVER",400,height/2.5,100)
	end

   	 --Propriedades do mapa
    	wave:draw()
	
	--Propriedades do player:
	spaceShip:draw()

	--Propriedades do monstro
	--Propriedades do gui
	guiInfo:drawBar("health")
	guiInfo:drawBar("energy")
	
end

function love.keypressed(key)
	if(key == "lctrl") then
		spaceShip:attack(spaceShip.currentWeapon)
	end
	if(key == "escape") then
		love.event.quit()
	end
end

function updateCollision(wave,spaceShip)
	if(wave) then
		for index, value in pairs (wave:getMonsters()) do
			spaceShip:updateBulletsCollision(value:getInstance())
		end
	end
end

function updateMonsterCollision(wave,player)
	if(wave) then
		for index, value in pairs (wave:getMonsters()) do
			value:updateBulletsCollision(player:getInstance())
		end
	end
end
