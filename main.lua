-----------game window size-------
window_width=1300
window_length=800
game_width=900
game_length=750
--------main character-----------
player={}
player.width=60
player.height=60
player.x=300
player.y=600
player.speed=500
player.health=10
player.max_health=10

state="menu"
---------bullet-----------
all_bullets={}
function createbullet()
    local bullet={}
    bullet.width=5
    bullet.height=10
    bullet.x=player.x+(player.width)/2-bullet.width/2
    bullet.y=player.y-bullet.height
    bullet.speed=300
    return (bullet)
end
---------enemy------------
all_enemy={}
math.randomseed(os.time())
function create_enemy()
    local enemy={}
    enemy.width=60
    enemy.height=60
    enemy.x=math.random(0,800)
    enemy.y=-enemy.height
    enemy.speed=200
    return (enemy)
end
----------collision-----------
function collision(v,k)
    return v.x<k.x+k.width and
           v.x+v.width>k.x and
           v.y<k.y+k.height and
           v.y+v.height>k.y
end

function player_render()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(player_image,player.x,player.y)
    love.graphics.setColor(1,1,1)
    
    for keys,values in pairs(all_bullets) do
        love.graphics.rectangle("fill",values.x,values.y,values.width,values.height,50)
    end
    
    
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill",1001,101+136,20*player.health,20)
    love.graphics.print(score,1001+85,101+136+275)
    love.graphics.setColor(1,1,1)
end
function enemy_render()
    for keys,values in pairs(all_enemy) do
        love.graphics.draw(enemy_image,values.x,values.y)
    end

end
function love.load()
    love.window.setMode(window_width,window_length)
    timer=0
    enemy_timer=0
    score=0
    background=love.graphics.newImage('bg_final.jpg')
    enemy_image=love.graphics.newImage('Zombie_final.png')
    player_image=love.graphics.newImage('canon_final.png')
    right_menu=love.graphics.newImage('menu.jpg')
    main_menu=love.graphics.newImage('main_menu.jpg')
    exit_image=love.graphics.newImage('end.jpg')
end
function love.update(dt)
    if(state=="play")then
        timer=timer+dt
        enemy_timer=enemy_timer+dt
        if(love.keyboard.isDown('a')) then-----------move character left----------
            player.x=player.x-player.speed*dt
        end
        if(love.keyboard.isDown('d')) then-----------move character right---------
            player.x=player.x+player.speed*dt
        end
        if(player.x<0) then------------limit left movement-------
            player.x=0
        end
        if(player.x>window_width-player.width) then------------limit right movement-----------
            player.x=window_width-player.width
        end
        if (timer>0.2) then----------------------------spawn bullet----------------
            table.insert(all_bullets,createbullet())
            timer=0
        end
        if (enemy_timer>0.3) then----------------spawn enemy-----------------
            table.insert(all_enemy,create_enemy())
            enemy_timer=0
        end
        ---------------bullet update--------------------
        for k,v in pairs(all_bullets) do 
            v.y=v.y-v.speed*dt
        end
        for k,v in pairs(all_bullets) do 
            if(v.y<-v.height)then
                table.remove(all_bullets,k)
            end
        end
     --------------------enemy update----------------
        for k,v in pairs(all_enemy) do 
            v.y=v.y+v.speed*dt
        end
        
        for k,v in pairs(all_enemy) do 
            if(v.y>player.y+50)then
            table.remove(all_enemy,k)
            end
        end
    ----------------killing of ennmy----------------
        for k,v in pairs(all_bullets)do
            for keys,values in pairs(all_enemy)do
                if(collision(v,values))then
                    table.remove(all_enemy,keys)
                    table.remove(all_bullets,k)
                    score=score+1
                end
            end
        end
    -------------when the enemy hit u---------------
        for k,v in pairs(all_enemy) do
            if(collision(player,v))then
                player.health=player.health-1
                table.remove(all_enemy,k)
            end
        end
        if(player.health<=0)then
            state="end"
        end
    elseif(state=="end")then
        all_bullet={}
        all_enemy={}
        player.health=player.max_health
    elseif(state=="menu")then
        player.health=player.max_health
        score=0
    end
end
function love.keypressed(key)

    if (key=='escape') then
        love.event.quit()
    end
    if(state=="menu" and key=="return")then
      state="play"
    end

    if (state=="end" and key == "return") then
      state="menu"
    end 

end

function love.draw()
    if (state=="menu") then 
        love.graphics.draw(main_menu,0,0)
    elseif state == "end" then 
        love.graphics.draw(exit_image,0,0)
        love.graphics.setColor(0,0,0)
        love.graphics.print("Score :"..score,window_width/2-150,window_length/2-150)
        love.graphics.print("Press ESC to QUIT",window_width/2-250,window_length/2-50)
        love.graphics.print("Press Enter to Play",window_width/2-250,window_length/2+50)
    else 
        love.graphics.draw(background,0,0)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(right_menu,900,0)
        enemy_render()
        player_render()
    end 
    love.graphics.setColor(1,1,1)
    
end
