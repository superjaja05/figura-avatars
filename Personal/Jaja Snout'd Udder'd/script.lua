-- Auto generated script file --

local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

local function clamp(x,min,max) if x > max then return max elseif x < min then return min else return x end end
vanilla_model.PLAYER:setVisible(false)

local debug_state = false

local dprint = function (...)
    if debug_state then
        print(...)
    end
end


local eartag_state = false

local nosering_state = true

local nerd_state = false

local blush_state = false
local blush_val = 0


local tail_sway = 0

local debugText = models:newText("myCoolTextName")
debugText:setAlignment("CENTER")

function events.entity_init()
    animations.model.nerd_off:play()
    models.model.root.Head.Blush:setOpacity(0)
    models.model.root.Head.EarRight.Eartag:setVisible(eartag_state)
    models.model.root.Head.Nosering:setVisible(nosering_state)
end

local function toggleActionColor(action,state)
    if state then
       action:hoverColor(0, 1, 0):setColor(0, 0.25, 0)
    else
        action:hoverColor(1, 0, 0):setColor(0.25, 0, 0)
    end
end

local debug_action
debug_action = mainPage:newAction()
    :title("Toggle Debug")
    :item("minecraft:barrier")
    :setColor(0.25, 0, 0)
    :hoverColor(1, 0, 0)
    :onLeftClick(function()
        debug_state = not debug_state
        toggleActionColor(debug_action, debug_state)
        print("Debug set to "..tostring(debug_state))
        debugText:setVisible(debug_state)
    end)

--Moo Action; Makes a moo noise and plays mooing animation
function pings.mooAction()
    animations.model.moo:play()
end
local moo_action
moo_action = mainPage:newAction()
    :title("MOO")
    :item("minecraft:wheat")
    :hoverColor(1, 0, 1)
    :onLeftClick(pings.mooAction)

--Nerd Toggle; Puts glasses on head
function pings.nerdToggle(state)
    nerd_state = state
    if state then
        animations.model.nerd_off:stop()
        animations.model.nerd_on:play()
    else
        animations.model.nerd_on:stop()
        animations.model.nerd_off:play()
    end
end
local nerd_action
nerd_action = mainPage:newAction()
    :title("Toggle Nerd")
    :item("minecraft:book")
    :setColor(0.25, 0, 0)
    :hoverColor(1, 0, 0)
    :onLeftClick(function()
        nerd_state = not nerd_state
        toggleActionColor(nerd_action, nerd_state)
        pings.nerdToggle(nerd_state)
    end)

--Blush Toggle; Toggles the fade-in/fade-out of the blush (controlled in the tick function)
function pings.blushToggle(state)
    blush_state = state
end
local blush_action
blush_action = mainPage:newAction()
    :title("Toggle Blush")
    :item("minecraft:poppy")
    :setColor(0.25, 0, 0)
    :hoverColor(1, 0, 0)
    :onLeftClick(function()
        blush_state = not blush_state
        toggleActionColor(blush_action, blush_state)
        pings.blushToggle(blush_state)
    end)

--Eartag Toggle; Toggles whether or not the eartag is visible
function pings.eartagToggle(state)
    eartag_state = state
    models.model.root.Head.EarRight.Eartag:setVisible(eartag_state)
end
local eartag_action
eartag_action = mainPage:newAction()
    :title("Toggle Eartag")
    :item("minecraft:name_tag")
    :setColor(0.25, 0, 0)
    :hoverColor(1, 0, 0)
    :onLeftClick(function()
        eartag_state = not eartag_state
        toggleActionColor(eartag_action, eartag_state)
        pings.eartagToggle(eartag_state)
    end)

--Nosering Toggle; Toggles whether or not the ring is visible
function pings.noseringToggle(state)
    nosering_state = state
    models.model.root.Head.Nosering:setVisible(nosering_state)
end
local nosering_action
nosering_action = mainPage:newAction()
    :title("Toggle Nose-Ring")
    :item("minecraft:gold_nugget")
    :setColor(0, 0.25, 0)
    :hoverColor(0, 1, 0)
    :onLeftClick(function()
        nosering_state = not nosering_state
        toggleActionColor(nosering_action, nosering_state)
        pings.noseringToggle(nosering_state)
    end)

--Milk Action; Makes milk bucket noise and sprays milk
function pings.milkAction()
    local pos = player:getPos()
    local eye_height = player:getEyeHeight()
    local eye_dir = player:getLookDir()
    sounds:playSound("entity.cow.milk", pos, 1, 1)
    for i1=1, 30 do
        local random_vel = math.random(10, 30)
        particles:newParticle("minecraft:snowflake", pos + vec(0, eye_height/1.75, 0), eye_dir*(random_vel/100))
    end
end
local milk_action
milk_action = mainPage:newAction()
    :title("Milk")
    :item("minecraft:milk_bucket")
    :hoverColor(1, 0, 1)
    :onLeftClick(pings.milkAction)

local tick_timer = 0

local sync_timer = 20*10
function events.tick()
    -- Calc Stuff
    local player_velocity = player:getVelocity()
    local player_velocity_xz = player_velocity.x_z
    local player_look_dir = player:getLookDir()
    local front_perc = player_velocity_xz:normalized():dot(player_look_dir.x_z:normalized())
    local side_perc = player_velocity_xz:normalized():dot(player_look_dir.x_z:normalized():cross(vec(0, 1, 0)))
    local general_speed = player_velocity_xz:length()

    local front_speed = front_perc*general_speed
    local side_speed = side_perc*general_speed

    tail_sway = tail_sway+(general_speed*2)
    
    --local walking = player:getVelocity().xz:length() > .01
    local vert_velocity = player_velocity.y
    --if walking then
    --    animations.model.tail_sway_walk:setSpeed(clamp(player:getVelocity().xz:length()*5, 0.25, 4))
    --    animations.model.tail_sway_walk:setPlaying(walking)
    --else
    --    animations.model.tail_sway_walk:stop()
    --end

    --Nosering movement
    if nosering_state then
        models.model.root.Head.Nosering:setRot(vec(clamp(-67.5 - (vert_velocity*32), -75, -45),0,0))
    end

    --Ears movement stuff
    models.model.root.Head.EarRight:setRot(vec(0,clamp(front_speed*-16, -45, 45),clamp(vert_velocity*-16, -22.5, 22.5)))
    models.model.root.Head.EarLeft:setRot(vec(0,clamp(front_speed*16, -45, 45),clamp(vert_velocity*16, -22.5, 22.5)))

    --Tail movement stuff
    models.model.root.Body.Tail:setRot(vec(-7.5 + clamp(vert_velocity*100 + front_speed*-75 + math.abs(side_speed)*-50, -80, 7.5), (math.sin(tail_sway)*22.5)*clamp(0.75-general_speed, 0.01, 1) + clamp(side_speed*-20, -20, 20), 0))

    --Tick stuff
    tick_timer = tick_timer+1
    if tick_timer > 20 then
        tick_timer = 0
    end

    sync_timer = sync_timer-1

    if sync_timer <= 0 then
        pings.nerdToggle(nerd_state)
        pings.blushToggle(blush_state)
        pings.eartagToggle(eartag_state)
        pings.noseringToggle(nosering_state)
        dprint("Sent sync pings")
        sync_timer = 20*10
    end

    --Blush Stuff
    if blush_state and blush_val < 1 then
        blush_val = clamp(blush_val+0.05, 0, 1)
        models.model.root.Head.Blush:setOpacity(blush_val)
    end
    if not blush_state and blush_val > 0 then
        blush_val = clamp(blush_val-0.05, 0, 1)
        models.model.root.Head.Blush:setOpacity(blush_val)
    end

    --Debug text
    if debug_state then
        debugText:setPos(vec(0,50,0))
        debugText:setRot(player_look_dir+vec(0,180,0))
        debugText:setText(string.format("%.1f, %.1f", clamp(-67.5 - (vert_velocity*32), -75, -45), vert_velocity))
    end
end