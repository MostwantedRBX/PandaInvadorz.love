--initilization
screenSizeX, screenSizeY = love.window.getMode()
gameover = false
love.graphics.setDefaultFilter("nearest","nearest")
--Enemy init
enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage("panda.png")
--Player init
player = {}
player.score = 0
player.x = screenSizeX/2-25
player.y = 500
player.width = 50
player.height = 50
player.bullets = {}
player.cooldown = 20
player.image = love.graphics.newImage("pc.png")
player.fire_sound1 = love.audio.newSource("lazer2.wav","static")
--misc image init
g_background1 = love.graphics.newImage("bg1.png")
g_go = love.graphics.newImage("go.png")
-- end of initilization

function checkCollisions(enemies,bullets,px)
	for __,e in pairs(enemies) do
		for _,b in pairs(bullets) do
			--[[I found a better algorithm then I could come up with. lol
			if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
				table.remove(enemies,__)
				table.remove(bullets,_)
				player.score = player.score + 50
			elseif e.y >= 655 then
				table.remove(enemies,__)
			end]]
			if b.x < e.x + e.width and b.x + b.width > e.x and b.y < e.y + e.height and b.height + b.y > e.y then
				table.remove(enemies,__)
				table.remove(bullets,_)
				player.score = player.score + 50
			elseif e.y >= 655 then
				table.remove(enemies,__)
			end
		end
	end
	for __,e in pairs(enemies) do
--	if e.y == 500-e.height then 
		if player.x < e.x + e.width and player.x + player.width > e.x and player.y < e.y + e.height and player.height + player.y > e.y then	
			return false
		end
	end
	return true
end

function love.load()
	player.fire = function()
    if player.cooldown <= 0 and gameover ~= true then
			love.audio.play(player.fire_sound1)
      player.cooldown = 20
      bullet = {}
      bullet.x = player.x+((50/2)-3)
      bullet.y = 500
			bullet.width = 6
			bullet.height = 11
      table.insert(player.bullets,bullet)
    end
	end
end

function enemies_controller:spawnEnemy(x,y)
	if #enemies_controller.enemies <= 3 then
		enemy = {}
		enemy.x=x
		enemy.y=y
		enemy.width=50
		enemy.height=50
		enemy.bullets = {} 
		enemy.cooldown=20
		enemy.speed=math.random(1,5)
		table.insert(self.enemies, enemy)
	end
end

--[[ Enemy Fire function. I can't see myself using this in this game, though.
function enemy:fire()
  if self.cooldown <= 0 then
    self.cooldown = 20
    bullet = {}
    bullet.x = player.x+((50/2)-3)
    bullet.y = 500
    table.insert(self.bullets,bullet)
  end
end
]]

function love.update(dt)
	player.cooldown = player.cooldown - 1
	math.randomseed(love.timer.getTime())
	enemies_controller:spawnEnemy(math.random(10, 550),-100)
	
	if love.keyboard.isDown("right") or love.keyboard.isDown("d") and player.x < screenSizeX - 56 then
		player.x=player.x+6
	elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") and player.x > 6 then
		player.x=player.x-6
	end
	
	if love.keyboard.isDown("space") then
		player.fire()
	end
	
  for _,e in pairs(enemies_controller.enemies) do
    e.y = e.y + e.speed
  end
  
	for _,b in pairs(player.bullets) do
		if b.y < -10 then
			table.remove(player.bullets,_)
		end
		b.y=b.y-10
	end
	 if checkCollisions(enemies_controller.enemies, player.bullets, player.x) == false then gameover = true end
end

function love.draw()
  love.graphics.setColor(255,255,255)
	if gameover == true then
		love.graphics.draw(g_go)
		return
	end
	love.graphics.draw(g_background1)
	love.graphics.draw(player.image,player.x,500)
  
  for _,v in pairs(player.bullets) do
		love.graphics.rectangle("fill",v.x,v.y,6,11)
	end
  
  for _,e in pairs(enemies_controller.enemies) do
    love.graphics.draw(enemies_controller.image,e.x,e.y,0)
  end
	screenSizeX, screenSizeY = love.window.getMode()
	love.graphics.print("Score: " .. player.score, 10,580)
end