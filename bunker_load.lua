



-- Initialization of constants and variables
-- Models and coordinates for various game objects and locations are defined here.
local bunkerClosedDoorObjectModel = joaat("gr_prop_gr_bunkeddoor_f")
local bunkerDoorTopModel = joaat("gr_prop_gr_doorpart_f")
local bunkerDoorBottomModel = joaat("gr_prop_gr_basepart_f")
local bunkerInteriorCoords = vector3(885.982, -3245.716, -98.278)


-- these variables are supposed to control the entire script and should be set with a server DB query
local ownsBunker = true
local ownedBunkerNumber = 1
local firstRun = false
IsInCutscene = false
local securityUpgrade = false
local bunkerStyle = {"Bunker_Style_A", "Bunker_Style_B", "Bunker_Style_C"}
local ownsMOC = false
local gunRangeUpgrade = false
local officeRoomUpgrade = true
local gunlockerUppgrade = true
local officeChair = 2
local transportUpgrade = false
local staffUpgrade = false
local isBunkerBusinessSetUP = false
local bunkerBusinessLaptop = "gr_bunker_laptop_01a"
local disruptionLogisticsScreen = "Prop_Screen_GR_Disruption"
local disruptScreen = false




-- Function to load the IPLs for bunkers in the game.
-- IPLs are used to load interior and exterior building models and props.
function LoadBunkerIPLs()
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
        
    end
    print("ipls loaded")
end

-- function for displaying stuff to player via notification system
function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- Coordinates for markers at bunker entrances.
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

-- Coordinates for bunker blips on the game map.
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
        
    end
    print("create bunker blips")
end

-- Function to control the rotation and animation of the bunker door top part.
function RotateTopEntity(top, topRot, bunkerCam_01)
    
    
    local doorLimitSoundPlayed = false
          print("Start Door rotation")
          Notify("Start Door rotation")
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

        RenderScriptCams(false, true, 1000, true, false)
        SetCamActive(bunkerCam_01, false)

        local cam2Attributes = getCameraAttributes(2, top)
        SetupCameraForBunker(bunkerCam_01, cam2Attributes)
        SetCamActive(bunkerCam_01, true)
        RenderScriptCams(true, false, 600, true, false)
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


-- Function to setup camera attributes for different views around the bunker.
function SetupCameraForBunker(camera, cameraAttributes)
    SetCamParams(camera, cameraAttributes.position.x, cameraAttributes.position.y, cameraAttributes.position.z, cameraAttributes.rotation.x, cameraAttributes.rotation.y, cameraAttributes.rotation.z, cameraAttributes.fov, 0, 1, 1, 2)
    SetGameplayCamRelativeHeading(cameraAttributes.gameplayHeadingOffset)
    return camera -- Return the camera object for further manipulation or cleanup
end

local exitDoor = vector3(896.376, -3245.798, -98.243)
function DrawBunkerEntranceMarkers ()
    local renderdistance = 5
    local playerPed = GetPlayerPed(PlayerId())
    local playerCoords = GetEntityCoords(playerPed)
    for _, marker in pairs(bunkerMarkerCoords) do
        local distance = #(playerCoords - marker)
        if distance <= renderdistance and marker.active == false then
            marker.active = true
        elseif not distance == nil or distance >= renderdistance and marker.active == true then
            marker.active = false
            
        end
        -- Check if player is within a specified range (e.g., 100 meters)
        if marker.active then
            
            RequestStreamedScript("Door_Open_Long")
	        LoadStream("Door_Open_Long", "DLC_GR_Bunker_Door_Sounds")
            DrawMarker(1, marker.x, marker.y, marker.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.55, 1.5, 3.0, 255, 175, 0, 100, false, true, 2, false, nil, nil, false)
            if distance <= 2.0 and  IsControlPressed(0, 38)then

                DoorBottom = SpawnBunkerDoorBottomPart(GetBunkerCloseToPlayer())
                Notify("bottom part ID = "..DoorBottom)
                DoorTop = SpawnBunkerDoorTopPart(GetBunkerCloseToPlayer())
                SetBunkerClosedDoorAttributes(GetBunkerCloseToPlayer(),  0, false)
                Notify("top part ID = "..DoorTop)
                PlayStreamFrontend()
                PlaySoundFrontend(-1, "Door_Open_Long", "DLC_GR_Bunker_Door_Sounds", true)
                OpenDoor(DoorTop, DoorBottom)
 

            end
        elseif marker.active and distance >= 3.0 then
            ResetBunkerDoor(GetBunkerCloseToPlayer(), DoorTop, DoorBottom)
        end
    end
    local distanceToExitDoor = #(playerCoords - exitDoor)
    if distanceToExitDoor <1.0 and IsControlPressed(0, 38) then
        SetEntityCoords(PlayerPedId(), exitDoor.x, exitDoor.y, exitDoor.z, true, false, false, false)
    end
end



-- Function to animate the opening of the bunker door
function OpenDoor(doorTop, doorBottom)
    if doorTop and doorBottom then
        local topRot = GetEntityRotation(doorTop, 2)
        
        local bunkerCam_01 = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
        print("create camera")
        Notify("create camera")
        local cam1Attributes = getCameraAttributes(1, doorBottom)
        

        SetupCameraForBunker(bunkerCam_01, cam1Attributes)
        SetCamActive(bunkerCam_01, true)
        RenderScriptCams(true, false, 600, true, false)
        local door = GetBunkerCloseToPlayer()
        local doorCoords = GetEntityCoords(door)
            RotateTopEntity(doorTop, topRot, bunkerCam_01)
        local playerPed = PlayerPedId()
        if IsPedInVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), false) then
            
            Wait(500)
            ResetBunkerDoor(GetBunkerCloseToPlayer(), DoorTop, DoorBottom)
            SetEntityCoords(GetVehiclePedIsIn(playerPed, false), bunkerInteriorCoords.x, bunkerInteriorCoords.y, bunkerInteriorCoords.z, true, false, false, false)
        else
            TaskGoStraightToCoord(playerPed, doorCoords.x, doorCoords.y, doorCoords.z, 1.0, 8000, 88.617, 0.0)
            Wait(500)
            if not firstRun then
                RequestCutsceneWithPlaybackList("BUNK_INT", 501, 8)
                while not HasCutsceneLoaded() do
                   Wait(0.0)
                end
                DoScreenFadeOut(1500)
                Wait(1500)
                ResetBunkerDoor(GetBunkerCloseToPlayer(), DoorTop, DoorBottom)
                SetEntityCoords(playerPed, bunkerInteriorCoords.x, bunkerInteriorCoords.y, bunkerInteriorCoords.z, true, false, false, false)
                
            else
                DoScreenFadeOut(1500)
                Wait(1500)
                ResetBunkerDoor(GetBunkerCloseToPlayer(), DoorTop, DoorBottom)
                SetCamActive(bunkerCam_01, false)
                RenderScriptCams(false, false, 600, true, false)
                DestroyCam(bunkerCam_01, true)
                SetEntityCoords(playerPed, bunkerInteriorCoords.x, bunkerInteriorCoords.y, bunkerInteriorCoords.z, true, false, false, false)
                SetUpDisruptionLogisticsLaptop()
                DoScreenFadeIn(1500)
            end

        
            if HasCutsceneLoaded() and not firstRun then
                Wait(3500)
                SetCamActive(bunkerCam_01, false)
                RenderScriptCams(false, false, 600, true, false)
                DestroyCam(bunkerCam_01, true)
                
                
                CreateModelHide(897.0294, -3248.4165, -99.29, 5.0, joaat("gr_prop_gr_tunnel_gate"), true)
                RegisterEntityForCutscene(playerPed, "MP_1", 0, GetEntityModel(playerPed), 64)
                Wait(2000)
                DoScreenFadeIn(1000)
                StartCutscene(0)
                IsInCutscene = true
                firstRun = true
            end

        end

    else
        Notify("Door parts are missing.")
    end
end

-- Function to animate the closing of the bunker door and turn off the camera
function CloseDoor(doorTop, doorBottom, bunkerCam)
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
    RequestModel(joaat("gr_prop_gr_basepart_f"))
    RequestModel(joaat("gr_prop_gr_doorpart_f"))
    local gg = false
    print("load bunker models")
    Notify("load bunker models")
    while not HasModelLoaded(joaat("gr_prop_gr_basepart_f")) and not HasModelLoaded(joaat("gr_prop_gr_doorpart_f")) do
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
    
    local doorBottomPart = CreateObjectNoOffset(bunkerDoorBottomModel, ClosedDoorAtributes.pos.x, ClosedDoorAtributes.pos.y, ClosedDoorAtributes.pos.z, true, true, true)
    
    SetEntityHeading(doorBottomPart, ClosedDoorAtributes.heading)
    SetEntityRotation(doorBottomPart, ClosedDoorAtributes.rot.x, ClosedDoorAtributes.rot.y, ClosedDoorAtributes.rot.z, 2, true)
    SetEntityCollision(doorBottomPart, true, true)
    --Wait(0.1)
    return doorBottomPart
end

function SpawnBunkerDoorTopPart(bunkerClosedDoor)
    local ClosedDoorAtributes = GetBunkerClosedDoorAttributes(bunkerClosedDoor)
    
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
    ActivateInteriorEntitySet(258561, "standard_security_set")
    DeactivateInteriorEntitySet(258561, "security_upgrade")
end

function activateUpgradeSet()
    if officeChair ==1 then
        OfficeChar = "bkr_prop_clubhouse_offchair_01a"
    elseif officeChair ==2 then
        OfficeChar = "sm_prop_smug_offchair_01a"
    end
    RequestModel(OfficeChar)
    while not HasModelLoaded(OfficeChar) do
        Wait(0)
    end
    ActivateInteriorEntitySet(258561, "upgrade_bunker_set") --new machines
    DeactivateInteriorEntitySet(258561, "standard_bunker_set") --used machines
    ActivateInteriorEntitySet(258561, "Gun_schematic_set")
    ActivateInteriorEntitySet(258561, "Office_Upgrade_set")-- adds room with bed
    RefreshInterior(258561)
    local officeChairOBJ = CreateObjectNoOffset(joaat(OfficeChar), 908.370, -3206.994, -96.187, true, true, false)
    ForceRoomForEntity(officeChairOBJ, 258561, -995755633)
    PlaceObjectOnGroundProperly(officeChairOBJ)
    Wait(0.1)
    FreezeEntityPosition(officeChairOBJ, true)
    --SetObjectAsNoLongerNeeded(officeChairOBJ)
    
end

function ActivateStyleA()
    ActivateInteriorEntitySet(258561, bunkerStyle[1])
    DeactivateInteriorEntitySet(258561, bunkerStyle[2])
    DeactivateInteriorEntitySet(258561, bunkerStyle[3]) 
end
function ActivateStyleB()
    ActivateInteriorEntitySet(258561, bunkerStyle[2])
    DeactivateInteriorEntitySet(258561, bunkerStyle[1])
    DeactivateInteriorEntitySet(258561, bunkerStyle[3]) 
end
function ActivateStyleC()
    ActivateInteriorEntitySet(258561, bunkerStyle[3])
    DeactivateInteriorEntitySet(258561, bunkerStyle[1])
    DeactivateInteriorEntitySet(258561, bunkerStyle[2]) 
end

function Create_GR_crate(crateName, posx, posy, posz)
    Crate = CreateObject(crateName, posx, posy, posz, false, false, true)
    SetEntityCoordsNoOffset(Crate, posx, posy, posz, false, false, false)
    SetEntityHeading(Crate, 180.0)
    return Crate
    
end

function CutsceneCheck()
    if IsCutsceneActive() and IsCutscenePlaying() and IsInCutscene then

            if not DoesEntityExist(Crate_01) then
                RequestModel("gr_prop_gr_crates_rifles_03a")
                RequestModel("gr_prop_gr_crates_rifles_01a")

                RequestModel("gr_prop_gr_crates_rifles_04a")
                RequestModel("gr_prop_gr_crates_pistols_01a")
                RequestModel("gr_prop_gr_crates_weapon_mix_01b")
                RequestModel("gr_prop_gr_cratespile_01a")

                while not HasModelLoaded("gr_prop_gr_crates_rifles_03a") do
                    Wait(0.0)
                end
                Crate_01 = Create_GR_crate("gr_prop_gr_crates_rifles_03a", 918.0762, -3233.553, -99.29)
                PlaceObjectOnGroundProperly(Crate_01)
                SetEntityHeading(Crate_01, 180.0)

                Crate_02 = Create_GR_crate("gr_prop_gr_crates_rifles_01a", 917.455, -3231.86, -99.29)
                PlaceObjectOnGroundProperly(Crate_02)
                SetEntityHeading(Crate_04, 180.0)

                --Crate_03 = CreateObject("gr_prop_gr_crates_rifles_01a", 917.8137, -3221.559, -99.29, false, false, true)
                --PlaceObjectOnGroundProperly(Crate_03)
                --SetEntityHeading(Crate_04, 180.0)

                Crate_04 = CreateObject("gr_prop_gr_crates_rifles_04a", 916.6675, -3228.079, -99.29, false, false, true)
                SetEntityHeading(Crate_04, 180.0)
                PlaceObjectOnGroundProperly(Crate_04)

                --Crate_05 = CreateObject("gr_prop_gr_crates_pistols_01a", 916.424, -3222.085, -99.29, false, false, true)
                --SetEntityHeading(Crate_05, 180.0)
                --PlaceObjectOnGroundProperly(Crate_05)

            end
        end
        if HasCutsceneFinished() and DoesEntityExist(Crate_01) and IsInCutscene then
                IsInCutscene = false
                DeleteEntity(Crate_01)
                DeleteEntity(Crate_02)
                --DeleteEntity(Crate_03)
                DeleteEntity(Crate_04)
                --DeleteEntity(Crate_05)
                RemoveModelHide(897.0294, -3248.4165, -99.29, 5.0, joaat("gr_prop_gr_tunnel_gate"), false)
                SetUpDisruptionLogisticsLaptop()
        end
end

-- Sets up the display for the laptop inside the bunker.
function SetUpDisruptionLogisticsLaptop()
    -- Retrieve the player's character.
    local playerPed = GetPlayerPed(PlayerId())
    
    -- Check if the player is inside the bunker and if the laptop screen is not already set.
    if GetInteriorFromEntity(playerPed) == 258561 and disruptScreen == false then
        -- Request the texture for the laptop screen.
        RequestStreamedTextureDict("Prop_Screen_GR_Disruption", 0)
        
        -- If the texture is loaded, proceed with setting up the screen.
        if HasStreamedTextureDictLoaded("Prop_Screen_GR_Disruption") then
            -- Register a render target (screen) if it's not already registered.
            if not IsNamedRendertargetRegistered("gr_bunker_laptop_01a") then
                RegisterNamedRendertarget("gr_bunker_laptop_01a", 0)
            end
            -- Link the laptop's screen to the render target if not already linked.
            if not IsNamedRendertargetLinked(-424277613) then
                LinkNamedRendertarget(-424277613)
                disruptScreen = true -- Indicate that the laptop screen is now set up.
            end
        end
    end

    -- Print whether the render target is linked (for debugging).
    print(tostring(IsNamedRendertargetLinked(-424277613)))
end

-- Draws the Disruption Logistics screen on the laptop in the bunker.
function DrawDisruptLogistics()
    -- Retrieve the player's character.
    local playerPed = GetPlayerPed(PlayerId())
    
    -- Check if the player is inside the bunker and if the laptop screen is set up.
    if GetInteriorFromEntity(playerPed) == 258561 and disruptScreen == true then
        -- Get the render target ID for the laptop.
        local bunkerLaptopRenderTargetId = GetNamedRendertargetRenderId("gr_bunker_laptop_01a")
        
        -- Set the current render target to the laptop screen for drawing.
        SetTextRenderId(bunkerLaptopRenderTargetId)
        -- Set up the position and order for drawing the screen.
        SetScreenDrawPosition(73, 73)
        SetScriptGfxDrawOrder(4)
        SetScriptGfxDrawBehindPausemenu(true)
        -- Draw the Disruption Logistics screen on the laptop.
        DrawSprite("Prop_Screen_GR_Disruption", "Prop_Screen_GR_Disruption", 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
        -- Reset the render target to default after drawing.
        ScreenDrawPositionEnd()
        SetTextRenderId(GetDefaultScriptRendertargetRenderId())
    end
end


-- Main execution
Citizen.CreateThread(function()
    CreateBunkerBlips()
    LoadBunkerIPLs()
    
    activateUpgradeSet()
    ActivateStyleB()
    activateSecuritySet()
     
    LoadBunkerModels()

     
    while true do
        DrawBunkerEntranceMarkers ()
        CutsceneCheck()
        --SetUpDisruptionLogisticsLaptop ()
        DrawDisruptLogistics()
        Wait(0.0)

    end
    
end)
