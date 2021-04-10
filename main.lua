function love.load()
    love.window.setMode(0, 0, {fullscreen=true, borderless=true})
    
    level = {}
    level.current = 1
    level.goal = 300 
    level.random = 30 

    sounds = {}
    sounds.background = love.audio.newSource("sounds/background1.ogg", "stream")
    sounds.background:setLooping(true)
    sounds.background:play()

    sounds.levelUp = love.audio.newSource("sounds/levelup.wav", "static")
    
    displayLevelUp = false 
    levelUpTimer = 30

    levelUpCounter = 0
    initialFontSize = 16
    flakes = {}
end


function createFlake()
    flake = {}
    flake.x = math.random(love.graphics.getWidth())
    flake.y = -math.random(50)
    flake.velocityX = (math.random(20)-20)/100 
    flake.velocityY = math.random(level.random)/100 
    flake.size = math.random(1,3)
    return flake
end


function makeFlakes(amount)
    for i=1, amount do 
        table.insert(flakes, createFlake())
    end
end 


function drawFlake(i)
  flake = flakes[i]  
  love.graphics.rectangle("fill", flake.x, flake.y, flake.size, flake.size)
  flake.y = flake.y + flake.velocityY
  flake.x = flake.x + flake.velocityX
  if flake.y > love.graphics.getHeight() then
    table.remove(flakes, i)  
  end
end


function drawHUD()
  love.graphics.setFont(love.graphics.newFont(20))

  if #flakes > 0 then  
      love.graphics.setColor(1,1,0)
      love.graphics.print("Level ".. level.current, 10, 10)
      love.graphics.printf(#flakes .. " / " .. level.goal,10, 10, love.graphics.getWidth()-30, "right")
      love.graphics.setColor(1,1,1)
    else
      love.graphics.setFont(love.graphics.newFont(40))
      if love.system.getOS() == 'iOS' or love.system.getOS() == 'Android' then
        info = "Touch anywhere to create flakes"
      else 
        info = "Click or press spacebar to create flakes. Press ESC to quit."
      end   
      love.graphics.printf(info, 0, 
        love.graphics.getHeight()/2-20, love.graphics.getWidth(), "center")
      love.graphics.setFont(love.graphics.newFont(initialFontSize))
  end   
  love.graphics.setFont(love.graphics.newFont(initialFontSize))
end


function drawLevelUp()
    if displayLevelUp then 
      love.graphics.setFont(love.graphics.newFont((levelUpCounter+1)*2))
      love.graphics.printf("Level Up!", 0, love.graphics.getHeight()/2-100, love.graphics.getWidth(), "center")
      love.graphics.setFont(love.graphics.newFont(initialFontSize))
    end 
end


function love.draw(dt)    
    drawLevelUp()
    for i=#flakes,1,-1 do 
      drawFlake(i)
    end
    drawHUD()
end 

function love.update()
  if #flakes >= level.goal then 
    level.goal = math.floor(level.goal * 1.5)
    level.random = math.floor(level.random * 1.3)    
    level.current = level.current + 1 
    displayLevelUp = true 
    love.audio.play(sounds.levelUp)
  end 

  if displayLevelUp then 
    levelUpCounter = levelUpCounter + 1
    if levelUpCounter >= levelUpTimer then 
      displayLevelUp = false 
      levelUpCounter = 0
    end 
  end 

end 


function love.mousepressed(x, y, button, istouch)
    makeFlakes(math.random(level.random))
end


function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
       love.event.quit()
    end

    if key == "space" then 
        makeFlakes(math.random(level.random))
    end 
end