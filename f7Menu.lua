
local debugWindowTextureDict = "shared"
local debugWindowTexture = "bggradient"
local debugWindowXPos = 0.85
local debugWindowYPos = 0.41
local debugWindowSizeX = 0.28
local debugWindowSizeY = 0.71
local debugWindowHeading = 0.0
local debugWindowColorR = 0
local debugWindowColorG = 0
local debugWindowColorB = 0
local debugWindowTranparency = 200
local showInfo = false
local lastSpawnedObject = nil  -- Variable to store the last spawned object's details

-- Key bindings for FiveM
local KEY_NUMPAD8 = 127 -- Numpad 8
local KEY_NUMPAD5 = 126 -- Numpad 5
local KEY_NUMPAD4 = 124 -- Numpad 4
local KEY_NUMPAD6 = 125 -- Numpad 6
local KEY_NUMPAD7 = 117 -- Numpad 7
local KEY_NUMPAD9 = 118 -- Numpad 9

local KEY_NUMPAD_PLUS = 96 -- Numpad +
local KEY_NUMPAD_MINUS = 97 -- Numpad -
local KEY_SHIFT = 21    -- Shift key





-- Import the NativeUI library
--local NativeUI = require('NativeUI')
local bunkerLocations = {
    { name = "bunker_01", x = -3156.372, y = 1376.653, z = 16.123 }
    -- Add more bunker coordinates as needed
}
-- Create a new menu pool
local menuPool = NativeUI.CreatePool()

-- Create a new menu
local mainMenu = NativeUI.CreateMenu("Dev Menu", "Select an option")
menuPool:Add(mainMenu)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- Function to add a menu item
function addMenuItem(menu, text, func)
    local item = NativeUI.CreateItem(text, "")
    item.Activated = function(sender, item)
        if item == item then
            func()
        end
    end
    menu:AddItem(item)
end

-- Function to teleport player to waypoint
function TeleportToWaypoint()
    local waypointBlip = GetFirstBlipInfoId(8) -- 8 is the blip id for waypoint
    if DoesBlipExist(waypointBlip) then
        local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector()) -- GetBlipInfoIdCoord
        local groundZ = GetGroundZFor_3dCoord(coord.x, coord.y, coord.z+5)
        SetEntityCoords(PlayerPedId(), coord.x, coord.y, groundZ)
    else
        print("No waypoint set!")
    end
end
-- Function to teleport player
function TeleportPlayer(coords)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
end

function DrawToPanel(text, posX, posY, textColor)
            -- Draw the player information
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.34)
            SetTextColour(textColor.r, textColor.g, textColor.b, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString(text)
            DrawText(posX, posY)  -- Adjust the position as needed
end




-- Function to toggle a translucent black window with player info
function ToggleInfoWindow()
    showInfo = not showInfo
    Citizen.CreateThread(function()
        while showInfo do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)
            local networkId = NetworkGetNetworkIdFromEntity(playerPed)

            local padding_A = 0.054
            local padding = 0.022

            local textColor_01 = {r=255, b=0, g=0}
            local textColor_02 = {r=0, g=0, b=255}

            -- Detecting the object player is aiming at
            local aimingAtEntity = nil
            local isAiming, aimingEntity = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if isAiming then
                aimingAtEntity = aimingEntity
            end
  
            -- Draw the translucent black window
            --DrawRect(0.88, 0.24, 0.20, 0.39, 0, 0, 0, 150)
            DrawSprite(debugWindowTextureDict,debugWindowTexture, debugWindowXPos, debugWindowYPos, debugWindowSizeX, debugWindowSizeY, debugWindowHeading, debugWindowColorR, debugWindowColorG, debugWindowColorB, debugWindowTranparency)
            DrawToPanel("player coords", debugWindowXPos-0.05, debugWindowYPos-debugWindowYPos+padding_A, textColor_01)
            DrawToPanel("X:    "..coords.x, debugWindowXPos-debugWindowSizeX/2, debugWindowYPos-debugWindowYPos+padding_A+padding, textColor_01)
            DrawToPanel("Y:    "..coords.y, debugWindowXPos-debugWindowSizeX/2, debugWindowYPos-debugWindowYPos+padding_A+(padding*2), textColor_01)
            DrawToPanel("Z:    "..coords.z, debugWindowXPos-debugWindowSizeX/2, debugWindowYPos-debugWindowYPos+padding_A+(padding*3), textColor_01)
            
            DrawToPanel("aimed entity", debugWindowXPos-0.05, debugWindowYPos-debugWindowYPos+padding_A+(padding*4), textColor_02)
            if lastSpawnedObject ~= nil and DoesEntityExist(lastSpawnedObject.object) then
                local textBaseY = debugWindowYPos-debugWindowYPos+padding_A+(padding*10)  -- Adjust Y position as needed
                DrawToPanel("Last Spawned Object", debugWindowXPos-0.05, textBaseY, textColor_02)
                local pos = GetEntityCoords(lastSpawnedObject.object)
                local heading = GetEntityHeading(lastSpawnedObject.object)

                DrawToPanel("Object ID: " .. lastSpawnedObject.object, debugWindowXPos-debugWindowSizeX/2, textBaseY+padding, textColor_02)
                DrawToPanel("X: " .. pos.x, debugWindowXPos-debugWindowSizeX/2, textBaseY+(padding*2), textColor_02)
                DrawToPanel("Y: " .. pos.y, debugWindowXPos-debugWindowSizeX/2, textBaseY+(padding*3), textColor_02)
                DrawToPanel("Z: " .. pos.z, debugWindowXPos-debugWindowSizeX/2, textBaseY+(padding*4), textColor_02)
                DrawToPanel("heading: " .. pos.z, debugWindowXPos-debugWindowSizeX/2, textBaseY+(padding*5), textColor_02)
            end
         
            

            -- Draw the aimed entity information
            if aimingAtEntity ~= nil then
                local aimedEntityCoords = GetEntityCoords(aimingAtEntity)
                local aimedEntityRot = GetEntityRotation(aimingAtEntity)
                local aimedEntityModel = GetEntityModel(aimingAtEntity)
                local aimedEntityHeading = GetEntityHeading(aimingAtEntity)
    
                
                DrawToPanel("Entity model: " .. aimedEntityModel, debugWindowXPos-debugWindowSizeX/2, debugWindowYPos-debugWindowYPos+padding_A+(padding*5), textColor_02)
               
                DrawToPanel("X:    " .. aimedEntityCoords.x, debugWindowXPos-debugWindowSizeX/2, debugWindowYPos-debugWindowYPos+padding_A+(padding*6), textColor_02)
                DrawToPanel("Y:    " .. aimedEntityCoords.y, debugWindowXPos-debugWindowSizeX/2, debugWindowYPos-debugWindowYPos+padding_A+(padding*7), textColor_02)
                DrawToPanel("Z:    " .. aimedEntityCoords.z, debugWindowXPos-debugWindowSizeX/2, debugWindowYPos-debugWindowYPos+padding_A+(padding*8), textColor_02)
                DrawToPanel("Heading:    " .. aimedEntityHeading, debugWindowXPos-debugWindowSizeX/2, debugWindowYPos-debugWindowYPos+padding_A+(padding*9), textColor_02)
            end
        end
    end)
end




-- Function to spawn a weapon pickup
function SpawnWeaponPickup()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local pickupPos = coords + GetEntityForwardVector(playerPed) * 2.0 -- calculate the position in front of the player

    -- create the weapon pickup
    -- replace "weapon_pistol" and 10 with the weapon hash and ammo count you want
    local pickup = CreatePickupRotate(GetHashKey("PICKUP_WEAPON_PISTOL"), pickupPos.x, pickupPos.y, pickupPos.z, 0, 0, 0, 2, 50, 2, true, 0x3656C8C1)
    Notify("Weapon pickup spawned!")
end

-- Function to spawn a money pickup
function SpawnMoneyPickup()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local pickupPos = coords + GetEntityForwardVector(playerPed) * 2.0 -- calculate the position in front of the player
    local model = GetHashKey("prop_anim_cash_note")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    -- create the money pickup
    local pickup = CreatePickup("PICKUP_MONEY_DEP_BAG", pickupPos.x, pickupPos.y, pickupPos.z, 0, 200, true, model)
    Notify("Money pickup spawned!")
end

-- Function to spawn a vehicle
function SpawnVehicle(vehicleModel)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local spawnPos = coords + GetEntityForwardVector(playerPed) * 5.0 -- calculate the position in front of the player

    local vehicleHash = GetHashKey(vehicleModel)
    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do
        Wait(1)
    end
    local vehicle = CreateVehicle(vehicleHash, spawnPos.x, spawnPos.y, spawnPos.z, GetEntityHeading(playerPed), true, false)

    -- set the player into the vehicle
    SetPedIntoVehicle(playerPed, vehicle, -1)

    Notify(vehicleModel .. " spawned!")
end

Offsetx = 0.0
Offsety = 0.0
-- Function to spawn an object
function SpawnObject()
    playerPed = PlayerPedId()
    coords = GetEntityCoords(playerPed)
    spawnPos = coords + GetEntityForwardVector(playerPed) * 2.0 -- Adjust the offset as needed
    heading = GetEntityHeading(playerPed)
    local objectToSpawn = GetHashKey("xm_prop_x17_avengerchair_02")
    RequestModel(objectToSpawn)
  

    while not HasModelLoaded(objectToSpawn) do
        Wait(0.0)
    end
    SpawnedObject = CreateObject(objectToSpawn, spawnPos.x+2+Offsetx, spawnPos.y+2+Offsety, spawnPos.z, true, true, false)
    lastSpawnedObject = { object = SpawnedObject, x = spawnPos.x+2+Offsetx, y = spawnPos.y+2+Offsety, z = spawnPos.z }
    PlaceObjectOnGroundProperly(lastSpawnedObject.object)

  

    -- Optionally set the object in a specific orientation or do additional setup here
end

function DeletObject()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    DD = DoesObjectOfTypeExistAtCoords(playerCoords.x, playerCoords.y, playerCoords.z, 25, GetHashKey("gr_prop_gr_rsply_crate04b"), true)

    DeleteEntity(SpawnedObject)


    if DD then 
       local entity_11 =  GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 25.0, GetHashKey("gr_prop_gr_rsply_crate04b") , false, true, true)
       DeleteEntity(entity_11)
    end

end

-- Updated function for handling object movement
function HandleObjectMovement()
    if lastSpawnedObject ~= nil and DoesEntityExist(lastSpawnedObject.object) then
        local obj = lastSpawnedObject.object
        local x, y, z = table.unpack(GetEntityCoords(obj, false))
        local heading = GetEntityHeading(obj)

        local isShiftPressed = IsControlPressed(0, KEY_SHIFT)

        -- Movement speed factors
        local moveSpeed = isShiftPressed and 0.05 or 0.01
        local zMoveSpeed = isShiftPressed and 0.05 or 0.01
        local headingSpeed = isShiftPressed and 5 or 1

        -- Handle horizontal and vertical movement
        if IsControlPressed(0, KEY_NUMPAD4) then x = x - moveSpeed end
        if IsControlPressed(0, KEY_NUMPAD6) then x = x + moveSpeed end
        if IsControlPressed(0, KEY_NUMPAD8) then y = y + moveSpeed end
        if IsControlPressed(0, KEY_NUMPAD5) then y = y - moveSpeed end

        -- Handle Z-axis movement
        if IsControlPressed(0, KEY_NUMPAD_PLUS) then z = z + zMoveSpeed end
        if IsControlPressed(0, KEY_NUMPAD_MINUS) then z = z - zMoveSpeed end

        -- Handle heading change
        if IsControlPressed(0, KEY_NUMPAD7) then heading = heading - headingSpeed end
        if IsControlPressed(0, KEY_NUMPAD9) then heading = heading + headingSpeed end

        -- Apply the changes
        SetEntityCoordsNoOffset(obj, x, y, z, true, true, true)
        SetEntityHeading(obj, heading)
    end
end




-- Display the menu
menuPool:RefreshIndex()
mainMenu:Visible(false)



-- Create submenus
local playerOptions = menuPool:AddSubMenu(mainMenu, "Player Options")
    addMenuItem(playerOptions, "Toggle Info Window", ToggleInfoWindow)
local spawnOptions = menuPool:AddSubMenu(mainMenu, "Spawning Options")
    -- Add items to 'Spawning Options' submenu
    addMenuItem(spawnOptions, "Spawn Weapon Pickup", function() SpawnWeaponPickup() end)
    addMenuItem(spawnOptions, "Spawn Money Pickup", function() SpawnMoneyPickup() end)
    addMenuItem(spawnOptions, "Spawn Vehicle", function() SpawnVehicle("oppressor2") end) -- replace "adder" with desired vehicle model
    addMenuItem(spawnOptions, "Spawn Object", function() SpawnObject() end) -- replace with desired object model
    addMenuItem(spawnOptions, "delete Object", function() DeletObject() end) -- replace with desired object model

local teleportOptions = menuPool:AddSubMenu(mainMenu, "Teleportation")
    addMenuItem(teleportOptions, "Teleport to Waypoint", TeleportToWaypoint)
    local bunkersMenu = menuPool:AddSubMenu(teleportOptions, "Bunkers")
    for _, location in pairs(bunkerLocations) do
        addMenuItem(bunkersMenu, location.name, function() TeleportPlayer(location) end)
    end

local utilityOptions = menuPool:AddSubMenu(mainMenu, "Utilities")



-- This function will be called every frame to keep the menu updated
Citizen.CreateThread(function()
    --ToggleInfoWindow()
    playerPed = PlayerPedId()
    coords = GetEntityCoords(playerPed)
    spawnPos = coords + GetEntityForwardVector(playerPed) * 2.0 -- Adjust the offset as needed
    heading = GetEntityHeading(playerPed)
    while true do
        Citizen.Wait(0)
    
        menuPool:ProcessMenus()
        HandleObjectMovement()
        if IsControlJustReleased(0, 244) then -- INPUT_CELLPHONE_DOWN
            mainMenu:Visible(not mainMenu:Visible())
            SetCursorLocation(0.5, 0.5)
        
        end
     
    end
end)
