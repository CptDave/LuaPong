--CODED BY CPT. DAVE
--SPECIAL THANKS TO LOVE2D.ORG FOR THEIR VERY USEFUL WIKI, AND BEING OPEN-SOURCE.

function love.load()
	world = love.physics.newWorld(0, 0, false)
	
	bg = love.graphics.newImage("background.png")
	
	--WINDOW SIZE
	width = 800
	height = 600
	
	--FONT
	font = love.graphics.newFont(20)
	
	--PLAYER TABLE
	player = {}
	
	player.body = love.physics.newBody(world, width/7, height/2, "dynamic")
	player.shape = love.physics.newRectangleShape(50, 120)
	player.fixture = love.physics.newFixture(player.body, player.shape, 1)
	
	--BOT TABLE
	bot = {}
	
	bot.body = love.physics.newBody(world, width - (width/6), height/2, "dynamic")
	bot.shape = love.physics.newRectangleShape(50, 120)
	bot.fixture = love.physics.newFixture(bot.body, bot.shape, 1)
	
	--BALL TABLE
	ball = {}
	
	ball.body = love.physics.newBody(world, width / 2, height / 2, "dynamic")
	ball.shape = love.physics.newCircleShape(7)
	ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1)
	ball.fixture:setRestitution(0.9)
	
	--WALL TABLE
	wall = {}
	
	--TOP WALL TABLE
	wall.top = {}
	
	wall.top.body = love.physics.newBody(world, width/2, 1, "static")
	wall.top.shape = love.physics.newRectangleShape(width, 10)
	wall.top.fixture = love.physics.newFixture(wall.top.body, wall.top.shape)
	
	--BOTTOM WALL TABLE
	wall.bottom = {}
	
	wall.bottom.body = love.physics.newBody(world, width / 2, height - 1, "static")
	wall.bottom.shape = love.physics.newRectangleShape(width, 10)
	wall.bottom.fixture = love.physics.newFixture(wall.bottom.body, wall.bottom.shape, 1)
	
	--BACKGROUND COLOR (ADD PICTURE?)
	love.graphics.setBackgroundColor(169, 169, 169)
	
	
	playerScore = 0
	botScore = 0

end

function love.update(dt)	
	world:update(dt)
	
	local power = 3000
	local randDir = {3000, -3000}
	
	--RESTART GAME
	if love.keyboard.isDown("r") then
		player.body:setPosition(width/7, height/2)
		player.body:setLinearVelocity(0,0)
		bot.body:setPosition(width - (width/6), height/2)
		bot.body:setLinearVelocity(0,0)
		ball.body:setPosition(width / 2, height / 2)
		ball.body:setLinearVelocity(0,0)
	end
	--START GAME
	function love.keypressed(key)
	
		LRChoice = math.random()
			
		if key == "s" and LRChoice <= .499 then --PUSH LEFT FIRST
			ball.body:applyForce(power*-1, randDir[math.random(1, #randDir)])
		end
		
		if key == "s" and LRChoice >= .5 then --PUSH RIGHT FIRST
			ball.body:applyForce(power, randDir[math.random(1, #randDir)])
		end	

		
	end
	
	--CHEACK TO SEE IF GOAL WAS MADE
	
	--BOTGOAL
	if ball.body:getX() < 0 then
		player.body:setPosition(width/7, height/2)
		player.body:setLinearVelocity(0,0)
		bot.body:setPosition(width - (width/6), height/2)
		bot.body:setLinearVelocity(0,0)
		ball.body:setPosition(width / 2, height / 2)
		ball.body:setLinearVelocity(0,0)
		
		--ADD SCORE
		botScore = botScore + 1
	--PLAYER GOAL
	elseif ball.body:getX() > width then
		player.body:setPosition(width/7, height/2)
		player.body:setLinearVelocity(0,0)
		bot.body:setPosition(width - (width/6), height/2)
		bot.body:setLinearVelocity(0,0)
		ball.body:setPosition(width / 2, height / 2)
		ball.body:setLinearVelocity(0,0)
	
		--ADD SCORE
		playerScore = playerScore + 1
	end
	
	--A QUICK AI FOR PLAYER BOT. FOR TESTING PURPOSES
	--bot.body:setPosition(bot.body:getX(), ball.body:getY()) --ALMOST IMPOSSIBLE TO BEAT AI
	-- if bot.body:getY() ~= ball.body then                           old
		-- if bot.body:getY() > ball.body:getY() then
			-- bot.body:applyForce(0, -550)
		-- end
		-- if bot.body:getY() < ball.body:getY() then
			-- bot.body:applyForce(0, 550)
		-- end
	-- end
	
	--test bot controlls
	if bot.body:getY() ~= ball.body:getY() then
		if bot.body:getY() > ball.body:getY() then
			bot.body:setPosition(bot.body:getX(), bot.body:getY() - 4)
		end
		if bot.body:getY() < ball.body:getY() then
			bot.body:setPosition(bot.body:getX(), bot.body:getY() + 4)
		end
	end
	
	
	
	--GIVES PLAYER CONTROLS                         OLD
	-- if love.keyboard.isDown("up") then
		-- player.body:applyForce(0, -10000)
	-- elseif love.keyboard.isDown("down") then
		-- player.body:applyForce(0, 10000)
	-- end
	
	--test controlls                              WORKING
	if love.keyboard.isDown("up") then
		player.body:setPosition(player.body:getX(), player.body:getY() - 8)
	elseif love.keyboard.isDown("down") then
		player.body:setPosition(player.body:getX(), player.body:getY() + 8)
	end
	
	--SETS BOTH PLAYERS TO A FIXED X VALUE AND A FIXED ANGLE
	player.body:setX(width/7)
	player.body:setAngle(math.rad(0))
	
	bot.body:setX(width - (width/6))
	bot.body:setAngle(math.rad(0))

end

function love.draw()
	--BACKGROUNF IMAGE
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(bg)

	--BALL
	love.graphics.setColor(245, 245, 245)
	love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())
	--PLAYER
	love.graphics.setColor(245, 200, 179)
	love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))
	--BOT
	love.graphics.setColor(245, 222, 179)
	love.graphics.polygon("fill", bot.body:getWorldPoints(bot.shape:getPoints()))
	--TOP BOUNDRY
	love.graphics.setColor(0, 0, 0)
	love.graphics.polygon("fill", wall.top.body:getWorldPoints(wall.top.shape:getPoints()))
	--BOTTOM BOUNDRY
	love.graphics.setColor(0, 0, 0)
	love.graphics.polygon("fill", wall.bottom.body:getWorldPoints(wall.bottom.shape:getPoints()))
	
	--SCORE TEXT
	love.graphics.setColor(0, 255, 0)
	love.graphics.setFont(font)
	love.graphics.print("Score: "..playerScore, 1, 10)
	
	love.graphics.setColor(0, 255, 0)
	love.graphics.setFont(font)
	love.graphics.print("BotScore: "..botScore, 100, 10)
	
end
