



--Wait(1000)

local bunkerClosedDoorObjectModel = GetHashKey("gr_prop_gr_bunkeddoor_f")
local bunkerDoorTopModel = GetHashKey("gr_prop_gr_doorpart_f")
local bunkerDoorBottomModel = GetHashKey("gr_prop_gr_basepart_f")

local bunkerInteriorCoords = vector3(885.982, -3245.716, -98.278)

local isRun_01 = false



print("Begining of sript local variables loaded")

-- Function to load bunker IPLs
function LoadBunkerIPLs()
    -- List of IPLs to load, replace 'bunkerIPLName' with actual IPL names
    local bunkerIPLs = {

        "gr_case0_bunkerclosed", -- 848.6175, 2996.567, 45.81612
        "gr_case1_bunkerclosed", -- 2126.785, 3335.04, 48.21422
        "gr_case2_bunkerclosed", -- 2493.654, 3140.399, 51.28789
        "gr_case3_bunkerclosed", -- 481.0465, 2995.135, 43.96672
        "gr_case4_bunkerclosed", -- -391.3216, 4363.728, 58.65862
        "gr_case5_bunkerclosed", -- 1823.961, 4708.14, 42.4991
        "gr_case6_bunkerclosed", -- 1570.372, 2254.549, 78.89397
        "gr_case7_bunkerclosed", -- -783.0755, 5934.686, 24.31475
        "gr_case8_bunkerclosed", 
        "gr_case9_bunkerclosed", -- 24.43542, 2959.705, 58.35517
        "gr_case10_bunkerclosed", -- -3058.714, 3329.19, 12.5844
        "gr_case11_bunkerclosed", -- -3180.466, 1374.192, 19.9597  
        "gr_entrance_placement"
        -- Add more IPLs as needed
    }
    -- Load each IPL
    for i, ipl in pairs(bunkerIPLs) do
        RequestIpl(ipl) -- This function loads the IPL
        print("ipls loaded "..ipl)
    end
    
end


-- dunxtion for displaying stuff to player via notification system
function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end


-- table holding the bunker marker coords
local bunkerMarkerCoords = {
        { x = -3156.372, y = 1376.653, z = 16.123, active = false},
        { x = 850.382, y = 3026.168, z = 41.27, active = false },
        { x = 2126.785, y = 3335.04, z = 48.21422, active = false },
        { x = 2493.654, y = 3140.399, z = 51.28789, active = false },
        { x = 481.0465, y = 2995.135, z = 43.96672, active = false },
        { x = -388.239, y = 4333.197, z = 54.636, active = false },
        { x = 1793.181, y = 4705.138, z = 39.3, active = false },
        { x = 1572.405, y = 2218.4121, z = 77.609, active = false },
        { x = -748.903, y = 5945.7529, z = 18.5, active = false },
        { x = 42.668, y = 2924.00, z = 54.5, active = false },
        { x = -3027.569, y = 3334.229, z = 10.032, active = false },
        -- Add more bunker coordinates as needed
    }
    print("marker coords loaded")


-- table holding the bunker blip coords
    local bunkerBlips = {
        { x = -3180.466, y = 1374.192, z = 19.9597 },
        { x = 848.6175, y = 2996.567, z = 45.81612 },
        { x = 2126.785, y = 3335.04, z = 48.21422 },
        { x = 2493.654, y = 3140.399, z = 51.28789 },
        { x = 481.0465, y = 2995.135, z = 43.96672 },
        { x = -391.3216, y = 4336.728, z = 58.65862 },
        { x = 1823.961, y = 4708.14, z = 42.4991 },
        { x = 1570.372, y = 2254.549, z = 78.89397 },
        { x = -783.0755, y = 5934.686, z = 24.31475 },
        { x = 24.43542, y = 2959.705, z = 58.35517 },
        { x = -3058.714, y = 3329.19, z = 12.5844 }
        -- Add more bunker coordinates as needed
    }
    print("blips coords loaded")

-- this function adds the blips to the blip system for drawing to map
function CreateBunkerBlips()
    for i, location in pairs(bunkerBlips) do
        local blip = AddBlipForCoord(location.x, location.y, location.z)
        SetBlipSprite(blip, 557) -- 557 is the sprite ID for bunkers, change as needed
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.9)
        SetBlipColour(blip, 2) -- 2 is for green color, change as needed
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Bunker") -- Name of the blip
        EndTextCommandSetBlipName(blip)
        print("create bunker blip "..i)
    end
    
end

function RotateTopEntity(top, topRot)
    local soundId = GetSoundId()
    --Wait(100)
    local doorLimitSoundPlayed = false
--
    for i = 1, 20 do
        Wait(120)
        SetEntityRotation(top, topRot.x, topRot.y - i, topRot.z, 2, true)

        if i >= 18 and not doorLimitSoundPlayed then
            doorLimitSoundPlayed = true
        StopStream()
		Wait(10)
	    RequestStreamedScript("Door_Open_Limit", "DLC_GR_Bunker_Door_Sounds")
	    LoadStream("Door_Open_Limit", "DLC_GR_Bunker_Door_Sounds")
		PlayStreamFrontend()
        PlaySoundFrontend(-1, "Door_Open_Limit", "DLC_GR_Bunker_Door_Sounds", 1)  
        end
    end
    --

    -- Cleanup
    if doorLimitSoundPlayed then
        -- Unload the sound bank
        --ReleaseNamedScriptAudioBank("DLC_GR_Bunker_Door_Sounds")
    else
        -- If the limit sound wasn't played, just release the initial sound ID
        --StopSound(soundId)
        --ReleaseSoundId(soundId)
    end
end

function SetupCameraForBunker(camera, cameraAttributes)
    

    SetCamParams(camera, cameraAttributes.position.x, cameraAttributes.position.y, cameraAttributes.position.z, cameraAttributes.rotation.x, cameraAttributes.rotation.y, cameraAttributes.rotation.z, cameraAttributes.fov, 0, 1, 1, 2)
    SetGameplayCamRelativeHeading(cameraAttributes.gameplayHeadingOffset)
    

    return camera -- Return the camera object for further manipulation or cleanup
end

function DrawBunkerEntranceMarkers ()
    local renderdistance = 5
    local playerPed = GetPlayerPed(PlayerId())
    local playerCoords = GetEntityCoords(playerPed)
    for _, marker in pairs(bunkerMarkerCoords) do
        local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, marker.x, marker.y, marker.z)
        if distance <= renderdistance and marker.active == false then
            marker.active = true
        elseif not distance == nil or distance >= renderdistance and marker.active == true then
            marker.active = false
            
        end
        -- Check if player is within a specified range (e.g., 100 meters)
        if marker.active then
            --bunkerDoorOBJ = GetBunkerCloseToPlayer()    
            RequestStreamedScript("Door_Open_Long")
	        LoadStream("Door_Open_Long", "DLC_GR_Bunker_Door_Sounds")
            DrawMarker(1, marker.x, marker.y, marker.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.55, 1.5, 3.0, 255, 175, 0, 100, false, true, 2, false, nil, nil, false)
            if distance <= 2.0 and  IsControlPressed(0, 38)then
                --RequestCutscene("BUNK_INT", 491, 8)
                RequestCutsceneWithPlaybackList("BUNK_INT", 501, 8)
                print("triggered "..GetBunkerCloseToPlayer())
                Notify("triggered "..GetBunkerCloseToPlayer())

                local doorBottom = SpawnBunkerDoorBottomPart(GetBunkerCloseToPlayer())
                Notify("bottom part ID = "..doorBottom)
                local doorTop = SpawnBunkerDoorTopPart(GetBunkerCloseToPlayer())
                Notify("top part ID = "..doorTop)
                PlayStreamFrontend()
                PlaySoundFrontend(-1, "Door_Open_Long", "DLC_GR_Bunker_Door_Sounds", true)
                openDoor(doorTop, doorBottom)
 
                 while not HasCutsceneLoaded() do 
                   Wait(0.0)
                 end
                 if HasCutsceneLoaded() then
                    RegisterEntityForCutscene(GetPlayerPed(-1), "MP_1", 0, GetEntityModel(GetHashKey(GetPlayerPed(-1))), 64)
                  
                    StartCutscene(1)
                 end
            end
        else 
            --ResetBunkerDoor(GetBunkerCloseToPlayer(), top, doorBottom)    
        end
    end
end

-- Function to animate the opening of the bunker door
function openDoor(doorTop, doorBottom)
    if doorTop and doorBottom then
        local topRot = GetEntityRotation(doorTop, 2)
        
        local bunkerCam_01 = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
        --local cam1Attributes = getCameraAttributes(1, doorBottom)
        local cam1Attributes = GetCameraAttributesUsingFiveMNative(bunkerCam_01, doorBottom)

        SetupCameraForBunker(bunkerCam_01, cam1Attributes)
        SetCamActive(bunkerCam_01, true)
        RenderScriptCams(true, false, 600, true, false)
    
        RotateTopEntity(doorTop, topRot)
        
        RenderScriptCams(false, true, 1000, true, false)
        SetCamActive(bunkerCam_01, true)

        local cam2Attributes = getCameraAttributes(2, doorBottom)
        SetupCameraForBunker(bunkerCam_01, cam2Attributes)
        SetCamActive(bunkerCam_01, true)
        RenderScriptCams(true, false, 600, true, false)

        Wait(8000)
        if IsPedInVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), false) then
            SetEntityCoords(GetVehiclePedIsIn(PlayerPedId(), false), bunkerInteriorCoords.x, bunkerInteriorCoords.y, bunkerInteriorCoords.z, true, false, false, false)
            RenderScriptCams(false, false, 3000, true, false)
        else
             --TaskGoStraightToCoord(PlayerPedId(), -3188.031, 1373.702, 16.806, 1.0, 8000, 88.617, 0.0)
            SetEntityCoords(PlayerPedId(), 894.797, -3244.699, -96.258, true, false, false, false)

            
           DestroyCam(bunkerCam_01, false)
           RenderScriptCams(false, false, 0, true, true)
        end

        -- Optional: Add any cleanup or additional steps here

    else
        Notify("Door parts are missing.")
    end
    
end

-- Function to animate the closing of the bunker door and turn off the camera
function closeDoor(doorTop, doorBottom, bunkerCam)
    if doorTop and doorBottom then
        local topRot = GetEntityRotation(doorTop, 2)
        
        -- If a camera is provided, activate and render it
        if bunkerCam then
            SetCamActive(bunkerCam, true)
            RenderScriptCams(true, false, 600, true, false)
        end

        -- Rotate the top part of the door to close it
        for i = 1, 20 do
            Wait(120)
            SetEntityRotation(doorTop, topRot.x, topRot.y - 20 + i, topRot.z, 2, true)

            -- Play sound effects or trigger other events as needed
        end

        -- Turn off the camera after the door closes
        if bunkerCam then
            RenderScriptCams(false, true, 1000, true, false)
            DestroyCam(bunkerCam, false)
        end

        -- Notify the player or trigger other in-game events
        Notify("Bunker door closed.")

    else
        Notify("Door parts are missing.")
    end
end


function LoadBunkerModels()
    RequestModel(GetHashKey("gr_prop_gr_basepart_f"))
    RequestModel(GetHashKey("gr_prop_gr_doorpart_f"))
    local gg = false
    print("load bunker models")
    Notify("load bunker models")
    while not HasModelLoaded(GetHashKey("gr_prop_gr_basepart_f")) and not HasModelLoaded(GetHashKey("gr_prop_gr_doorpart_f")) do
       if not gg then 
        print("load bunker models - WAIT")
        Notify("load bunker models - WAIT")
        gg = true
       end
        Wait(0)
    end
    print("bunker models loaded")
    Notify("bunker models loaded")
end


-- this function returns the entity ID of the closest bunker door to player
function GetBunkerCloseToPlayer()
    local playerPed = GetPlayerPed(PlayerId())
    local playerCoords = GetEntityCoords(playerPed)
   if DoesObjectOfTypeExistAtCoords(playerCoords.x, playerCoords.y, playerCoords.z, 25.0, bunkerClosedDoorObjectModel, true) or DoesObjectOfTypeExistAtCoords(playerCoords.x, playerCoords.y, playerCoords.z, 25.0, (-877963371), true) then 
       BunkerClosedDoor = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 25.0, bunkerClosedDoorObjectModel , false, true, true)
       --print("GetBunkerCloseToPlayer="..tostring(BunkerClosedDoor))
       return BunkerClosedDoor
   elseif DoesObjectOfTypeExistAtCoords(playerCoords.x, playerCoords.y, playerCoords.z, 25.0, bunkerClosedDoorObjectModel, true) then 
    BunkerClosedDoor = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 25.0, (-877963371) , false, true, true)
    --print("GetBunkerCloseToPlayer="..tostring(BunkerClosedDoor))
    return BunkerClosedDoor
   
   end
end

function GetBunkerClosedDoorAttributes(bunkerClosedDoorOBJ_ID)
    local pos = GetEntityCoords(bunkerClosedDoorOBJ_ID)
    local rot = GetEntityRotation(bunkerClosedDoorOBJ_ID, 2)
    local alpha = GetEntityAlpha(bunkerClosedDoorOBJ_ID)
    local collision = GetEntityCollisionDisabled(bunkerClosedDoorOBJ_ID)
    local heading = GetEntityHeading(bunkerClosedDoorOBJ_ID)
    local id = bunkerClosedDoorOBJ_ID 
    local h = {id = id, pos = pos, rot = rot, heading = heading, alpha = alpha, collision = collision}
    return h
end

function SetBunkerClosedDoorAttributes(bunkerClosedDoorOBJ_ID,  alpha, collision)
    SetEntityAlpha(bunkerClosedDoorOBJ_ID,  alpha, true)
    FreezeEntityPosition(bunkerClosedDoorOBJ_ID, true)
    SetEntityCollision(bunkerClosedDoorOBJ_ID, collision, true)
    

end


function SpawnBunkerDoorBottomPart(bunkerClosedDoor)
    local ClosedDoorAtributes = GetBunkerClosedDoorAttributes(bunkerClosedDoor)
    SetBunkerClosedDoorAttributes(bunkerClosedDoor,  0, false)
    local doorBottomPart = CreateObjectNoOffset(bunkerDoorBottomModel, ClosedDoorAtributes.pos.x, ClosedDoorAtributes.pos.y, ClosedDoorAtributes.pos.z, true, true, true)
    
    SetEntityHeading(doorBottomPart, ClosedDoorAtributes.heading)
    SetEntityRotation(doorBottomPart, ClosedDoorAtributes.rot.x, ClosedDoorAtributes.rot.y, ClosedDoorAtributes.rot.z, 2, true)
    SetEntityCollision(doorBottomPart, true, true)
    --Wait(0.1)
    return doorBottomPart
end

function SpawnBunkerDoorTopPart(bunkerClosedDoor)
    local ClosedDoorAtributes = GetBunkerClosedDoorAttributes(bunkerClosedDoor)
    SetBunkerClosedDoorAttributes(bunkerClosedDoor,  0, false)
    Wait(0.1)
    local doorTopPartPosition  = CalculateDoorTopPartPosition(bunkerClosedDoor, -8.68, 0.0, 0.0)
    local doorTopPart = CreateObjectNoOffset(bunkerDoorTopModel, doorTopPartPosition.x, doorTopPartPosition.y, doorTopPartPosition.z, true, true, true)
    
    SetEntityHeading(doorTopPart, ClosedDoorAtributes.heading)
    SetEntityRotation(doorTopPart, ClosedDoorAtributes.rot.x, ClosedDoorAtributes.rot.y+20, ClosedDoorAtributes.rot.z, 2, true)
    return doorTopPart
end

function ResetBunkerDoor(closedDoor, top, bottm)
   DeleteEntity(top)
   DeleteEntity(bottm)
   SetBunkerClosedDoorAttributes(closedDoor,  255, true)
   
end


function CalculateDoorTopPartPosition(bunkerClosedDoor, xOffset, yOffset, zOffset)
    local closedDoorAttributes = GetBunkerClosedDoorAttributes(bunkerClosedDoor)
    local radianHeading = math.rad(closedDoorAttributes.heading)

    -- Apply the heading to calculate the world position offset
    local worldXOffset = xOffset * math.cos(radianHeading) - yOffset * math.sin(radianHeading)
    local worldYOffset = xOffset * math.sin(radianHeading) + yOffset * math.cos(radianHeading)

    -- Calculate the new world position for the door top part
    local doorTopPartPosition = {
        x = closedDoorAttributes.pos.x + worldXOffset,
        y = closedDoorAttributes.pos.y + worldYOffset,
        z = closedDoorAttributes.pos.z + zOffset -- Now includes z-offset
    }

    return doorTopPartPosition
end


function getCameraAttributes(cameraNumber, bunkerDoor)
    -- Get bunker door position, heading, and rotation
    local doorPosition = GetEntityCoords(bunkerDoor)
    local doorHeading = GetEntityHeading(bunkerDoor)
    local doorRotation = GetEntityRotation(bunkerDoor, 2) -- Using the 2nd rotation order

    -- Camera offsets and rotations relative to the bunker door
    local cameraOffset = {
        {x = 13.124, y = 0.55544, z = 0.300, rotX = -0.6113692, rotY = -0.7532815, rotZ = 75.632, fov = 50.0, gameplayHeadingOffset = -140.1253},
        {x = -8.0, y = -8.05, z = 2.546, rotX = 0, rotY = 0, rotZ = 318.0, fov = 50.0, gameplayHeadingOffset = 54.000}
    }

    -- Calculate camera position based on bunker door position, heading, and rotation
    local function calculatePosition(offset, doorPos, doorHead, doorRot)
        local rad = math.rad(doorHead)
        local cosRad = math.cos(rad)
        local sinRad = math.sin(rad)

        -- Adjust position for heading
        local newX = doorPos.x + offset.x * cosRad - offset.y * sinRad
        local newY = doorPos.y + offset.x * sinRad + offset.y * cosRad
        local newZ = doorPos.z + offset.z

        -- Apply additional rotation adjustments if necessary
        -- Note: This is a simplified example. You may need more complex math for accurate rotation adjustments.
        newX = newX + doorRot.x * 0.01 -- Adjust these multipliers as necessary
        newY = newY + doorRot.y * 0.01
        newZ = newZ + doorRot.z * 0.01

        return {x = newX, y = newY, z = newZ}
    end

    local selectedCamera = cameraOffset[cameraNumber]
    local cameraPos = calculatePosition(selectedCamera, doorPosition, doorHeading, doorRotation)

    return {
        position = cameraPos,
        rotation = {x = selectedCamera.rotX, y = selectedCamera.rotY, z = selectedCamera.rotZ},
        fov = selectedCamera.fov,
        gameplayHeadingOffset = selectedCamera.gameplayHeadingOffset
    }
end

function GetCameraAttributesUsingFiveMNative(cameraNumber, bunkerDoor)
    -- Get bunker door position and heading
    local doorPosition = GetEntityCoords(bunkerDoor)
    local doorHeading = GetEntityHeading(bunkerDoor)

    -- Camera offsets and rotations relative to the bunker door
    local cameraOffset = {
        {x = 13.124, y = 0.55544, z = 0.300, rotX = -0.6113692, rotY = -0.7532815, rotZ = 75.632, fov = 50.0, gameplayHeadingOffset = -140.1253},
        {x = -8.0, y = -8.05, z = 2.546, rotX = 0, rotY = 0, rotZ = 318.0, fov = 50.0, gameplayHeadingOffset = 54.000}
    }

    -- Select the camera offset based on camera number
    local selectedCamera = cameraOffset[cameraNumber]

    -- Calculate the world coordinates for the camera
    local worldX, worldY, worldZ = GetOffsetFromEntityGivenWorldCoords(bunkerDoor, selectedCamera.x, selectedCamera.y, selectedCamera.z)

    return {
        position = {x = worldX, y = worldY, z = worldZ},
        rotation = {x = selectedCamera.rotX, y = selectedCamera.rotY, z = selectedCamera.rotZ},
        fov = selectedCamera.fov,
        gameplayHeadingOffset = selectedCamera.gameplayHeadingOffset
    }
end


function activateSecuritySet()
    ActivateInteriorEntitySet(258561, "security_upgrade")
    DeactivateInteriorEntitySet(258561, "standard_security_set")
    print("activateSecuritySet")
end

function activateUpgradeSet()    
    local officeChar = "bkr_prop_clubhouse_offchair_01a"
    RequestModel(officeChar)
    while not HasModelLoaded(officeChar) do
        Wait(0)
    end
    ActivateInteriorEntitySet(258561, "upgrade_bunker_set") --new machines
    DeactivateInteriorEntitySet(258561, "standard_bunker_set") --used machines
    ActivateInteriorEntitySet(258561, "Gun_schematic_set")
    ActivateInteriorEntitySet(258561, "Office_Upgrade_set")-- adds room with bed
 
    local officeChairOBJ = CreateObjectNoOffset(GetHashKey(officeChar), 908.370, -3206.994, -97.187, true, true, false)
    
    PlaceObjectOnGroundProperly(officeChairOBJ)
    Wait(0.1)
    FreezeEntityPosition(officeChairOBJ, true)
    --SetObjectAsNoLongerNeeded(officeChairOBJ)
    
end

function activateStyleA()
    ActivateInteriorEntitySet(258561, "Bunker_Style_A")
    DeactivateInteriorEntitySet(258561, "Bunker_Style_B")
    DeactivateInteriorEntitySet(258561, "Bunker_Style_C")
    
end



-- Main execution
Citizen.CreateThread(function()
    CreateBunkerBlips()
    LoadBunkerIPLs()
    activateSecuritySet()
    activateUpgradeSet()
    activateStyleA()
    RefreshInterior(258561)
     
    LoadBunkerModels()


    while true do
    
        DrawBunkerEntranceMarkers ()
        

        Wait(0)
       
    end
    
end)
print("End of sript - "..tostring(GetPlayerPed(PlayerId())))
