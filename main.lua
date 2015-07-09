-----------------------------------------------------------------------------------------
--
-- Falling balloon and bomb game
-- Written by Gary Sims for Android Authority
--
-----------------------------------------------------------------------------------------

-- Start the physics engine
local physics = require( "physics" )
physics.start()

-- Calculate half the screen width and height
halfW = display.contentWidth*0.5
halfH = display.contentHeight*0.5

-- Set the background
local bkg = display.newImage( "night_sky.png", halfW, halfH )

-- Score
score = 0
scoreText = display.newText(score, halfW, 10)


-- Called when the balloon is tapped by the player
-- Increase score by 1
local function balloonTouched(event)
	if ( event.phase == "began" ) then
		Runtime:removeEventListener( "enterFrame", event.self )
        event.target:removeSelf()
		score = score + 1
		scoreText.text = score
    end
end

-- Called when the bomb is tapped by the player
-- Half the score as a penalty
local function bombTouched(event)
	if ( event.phase == "began" ) then
		Runtime:removeEventListener( "enterFrame", event.self )
        event.target:removeSelf()
		score = math.floor(score * 0.5)
		scoreText.text = score
    end
end

-- Delete objects which has fallen off the bottom of the screen
local function offscreen(self, event)
	if(self.y == nil) then
		return
	end
	if(self.y > display.contentHeight + 50) then
		Runtime:removeEventListener( "enterFrame", self )
		self:removeSelf()
	end
end

-- Add a new falling balloon or bomb
local function addNewBalloonOrBomb()
	-- You can find red_ballon.png and bomb.png in the GitHub repo
	local startX = math.random(display.contentWidth*0.1,display.contentWidth*0.9)
	if(math.random(1,5)==1) then
		-- BOMB!
		local bomb = display.newImage( "bomb.png", startX, -300)
		physics.addBody( bomb )
		bomb.enterFrame = offscreen
		Runtime:addEventListener( "enterFrame", bomb )
		bomb:addEventListener( "touch", bombTouched )
	else
		-- Balloon
		local balloon = display.newImage( "red_balloon.png", startX, -300)
		physics.addBody( balloon )
		balloon.enterFrame = offscreen
		Runtime:addEventListener( "enterFrame", balloon )
		balloon:addEventListener( "touch", balloonTouched )
	end
end

-- Add a new balloon or bomb now
addNewBalloonOrBomb()

-- Keep adding a new balloon or bomb every 0.5 seconds
timer.performWithDelay( 500, addNewBalloonOrBomb, 0 )

