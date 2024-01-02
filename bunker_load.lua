



-- Bunker Specific Configuration and State
local ownsBunker = true  -- Determines if the player owns a bunker.
local ownedBunkerNumber = 1  -- Identifier for the specific bunker owned by the player.
local firstRun = true  -- Flag to check if this is the first execution of the script for the player.
local isBunkerBusinessSetUP = false  -- Checks if the bunker's business setup is complete.

-- Bunker Upgrades and Customization
local securityUpgrade = false  -- Indicates whether the bunker has a security upgrade.
local bunkerStyle = {"Bunker_Style_A", "Bunker_Style_B", "Bunker_Style_C"}  -- Array of available bunker styles for customization.
local officeRoomUpgrade = true  -- Determines whether the office room in the bunker is upgraded.
local gunlockerUppgrade = true  -- States if the bunker has an upgraded gun locker.
local transportUpgrade = false  -- Identifies if the bunker has received a transport upgrade.
local staffUpgrade = false  -- Indicates whether the bunker has a staff upgrade.
local gunRangeUpgrade = true  -- Indicates if the bunker has a gun range upgrade.
local ownsMOC = false  -- Checks if the player owns a Mobile Operations Center.
local isSittingInBossChair = false



-- Bunker Interior and Equipment
local officeChair = 2  -- Specifies the type/model of the office chair inside the bunker.
local bunkerBusinessLaptop = "gr_bunker_laptop_01a"  -- Model identifier for the bunker's business laptop.
local disruptionLogisticsScreen = "Prop_Screen_GR_Disruption"  -- Model identifier for the disruption logistics screen.
local bunkerInterior = 258561

-- Bunker Manufacturing and Research
local researchActive = false  -- Indicates if research activities are currently underway in the bunker.
local manufacturingActive = false  -- Determines if the bunker is engaged in manufacturing.
local researchAndManufacturingActive = false  -- Checks if both research and manufacturing activities are active simultaneously.
local manufacturedProduct = "Gun_barrel_handgun_01"  -- Placeholder for the type of product being manufactured.

-- Bunker Inventory and Stock Management
local materialStockLevel = 0.0  -- The current level of materials stocked in the bunker.
local productStockLevel = 0.0  -- The current level of products stocked in the bunker.

-- Bunker Vehicle Management
local bunkerExtraVehicleSlots = 1  -- Number of extra vehicle slots in the bunker.
local vehicleInSlot = ""  -- Keeps track of the vehicle currently placed in the extra slot.

-- Security and Raid Management
local raidChanceMultiplier = 0  -- Affects the likelihood of a raid on the bunker.
local policeInformant = false -- Reduces chance of a raid and provides advanced notice.

-- Bunker Financial Management
local upkeepBasePrice = 1000  -- Base price for bunker maintenance.
local upkeepCostMultiplier = 0 -- Multiplier for upkeep cost (0 is free, 1 is base price, 2 is 2X base price, etc.)

-- Special Contracts and Engagements
local hasGovernmentContract = false -- Engages bunker in government contracts for manufacturing.

-- Bunker Emergency Situations
local isRaidInProgress = false  -- Indicates if a raid on the bunker is currently in progress.

-- Cutscene and Animation Management
IsInCutscene = false  -- Flag to indicate if a cutscene is currently playing.

-- Bunker Models and Coordinates
local bunkerClosedDoorObjectModel = GetHashKey("gr_prop_gr_bunkeddoor_f")  -- Hash key for the bunker's closed door model.
local bunkerDoorTopModel = GetHashKey("gr_prop_gr_doorpart_f")  -- Hash key for the top part of the bunker door model.
local bunkerDoorBottomModel = GetHashKey("gr_prop_gr_basepart_f")  -- Hash key for the bottom part of the bunker door model.
local bunkerInteriorCoords = vector3(885.982, -3245.716, -98.278)  -- Vector3 coordinates for the bunker interior.

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






Scaleform = RequestScaleformMovie("DISRUPTION_LOGISTICS")
Flag = false

while not HasScaleformMovieLoaded(Scaleform) do
   Wait(0.0)
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
    local distanceToExitDoor = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, 896.376, -3245.798, -98.243)
    if distanceToExitDoor <1.0 and IsControlPressed(0, 38) then
        SetEntityCoords(PlayerPedId(), -3151.440, 1377.317, 17.391, true, false, false, false)
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
        if IsPedInVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), false) then
            DoScreenFadeOut(1500)
            Wait(1500)
            ResetBunkerDoor(GetBunkerCloseToPlayer(), DoorTop, DoorBottom)
            SetCamActive(bunkerCam_01, false)
            RenderScriptCams(false, false, 600, true, false)
            DestroyCam(bunkerCam_01, true)
            SetEntityCoords(GetVehiclePedIsIn(PlayerPedId(), false), bunkerInteriorCoords.x, bunkerInteriorCoords.y, bunkerInteriorCoords.z, true, false, false, false)
            SetUpDisruptionLogisticsLaptop()
            Wait(100)
            SetUpDisruptionLogisticsLaptop()
            print("triggered")
            DisAbleControlActionSet()
            DoScreenFadeIn(1500)
            
        else
            TaskGoStraightToCoord(PlayerPedId(), doorCoords.x, doorCoords.y, doorCoords.z, 1.0, 8000, 88.617, 0.0)
            Wait(500)
            if not firstRun then
                if gunRangeUpgrade and ownsMOC then
                    RequestCutsceneWithPlaybackList("BUNK_INT", 491, 8)
                elseif gunRangeUpgrade and not ownsMOC then
                    RequestCutsceneWithPlaybackList("BUNK_INT", 493, 8)
                elseif ownsMOC and not gunRangeUpgrade then
                    RequestCutsceneWithPlaybackList("BUNK_INT", 499, 8)
                
                else
                    RequestCutsceneWithPlaybackList("BUNK_INT", 501, 8)
                end
                while not HasCutsceneLoaded() do
                   Wait(0.0)
                end
                DoScreenFadeOut(1500)
                Wait(1500)
                ResetBunkerDoor(GetBunkerCloseToPlayer(), DoorTop, DoorBottom)
                SetEntityCoords(PlayerPedId(), bunkerInteriorCoords.x, bunkerInteriorCoords.y, bunkerInteriorCoords.z, true, false, false, false)
                SetUpDisruptionLogisticsLaptop()
                Wait(100)
                SetUpDisruptionLogisticsLaptop()
                DisAbleControlActionSet()
                DoScreenFadeIn(1500)
            else
                DoScreenFadeOut(1500)
                Wait(1500)
                ResetBunkerDoor(GetBunkerCloseToPlayer(), DoorTop, DoorBottom)
                SetCamActive(bunkerCam_01, false)
                RenderScriptCams(false, false, 600, true, false)
                DestroyCam(bunkerCam_01, true)
                SetEntityCoords(PlayerPedId(), bunkerInteriorCoords.x, bunkerInteriorCoords.y, bunkerInteriorCoords.z, true, false, false, false)
                SetUpDisruptionLogisticsLaptop()
                Wait(100)
                SetUpDisruptionLogisticsLaptop()
                print("triggered")
                DisAbleControlActionSet()
                DoScreenFadeIn(1500)
                
                
            end

        
            if HasCutsceneLoaded() and not firstRun then
                Wait(3500)
                SetCamActive(bunkerCam_01, false)
                RenderScriptCams(false, false, 600, true, false)
                DestroyCam(bunkerCam_01, true)
                
                
                CreateModelHide(897.0294, -3248.4165, -99.29, 5.0, GetHashKey("gr_prop_gr_tunnel_gate"), true)
                RegisterEntityForCutscene(GetPlayerPed(-1), "MP_1", 0, GetEntityModel(GetPlayerPed(-1)), 64)
                Wait(2000)
                DoScreenFadeIn(1000)
                print("cutScene started")
                
                StartCutscene(0)
                IsInCutscene = true
                firstRun = true

            end

        end

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
    ActivateInteriorEntitySet(bunkerInterior, "standard_security_set")
    DeactivateInteriorEntitySet(bunkerInterior, "security_upgrade")
end

function activateUpgradeSet()
    if officeChair ==1 then
        OfficeChairModel = "bkr_prop_clubhouse_offchair_01a"
    elseif officeChair ==2 then
        OfficeChairModel = "sm_prop_smug_offchair_01a"
    end
    RequestModel(OfficeChairModel)
    while not HasModelLoaded(OfficeChairModel) do
        Wait(0)
    end
    DoesofficeChairExist = DoesObjectOfTypeExistAtCoords(908.670, -3206.994, -97.500, 1, GetHashKey(OfficeChairModel), true)

    ActivateInteriorEntitySet(bunkerInterior, "standard_bunker_set") --used machines
    ActivateInteriorEntitySet(bunkerInterior, "Gun_schematic_set")
    ActivateInteriorEntitySet(bunkerInterior, "Office_Upgrade_set")-- adds room with bed
    RefreshInterior(bunkerInterior)
    if DoesofficeChairExist then
      local oldChair = GetClosestObjectOfType(908.670, -3206.994, -97.500, 1, GetHashKey(OfficeChairModel), false, false, false)
      DeleteEntity(oldChair)
    end
    if not DoesEntityExist(OfficeChairOBJ) then
    OfficeChairOBJ = CreateObjectNoOffset(GetHashKey(OfficeChairModel), 908.670, -3206.994, -97.500, true, true, false)
    local rot = GetEntityRotation(OfficeChairOBJ, 2)
    SetEntityRotation(OfficeChairOBJ, rot.x, rot.y, rot.z+10.022, 2, false)
    ForceRoomForEntity(OfficeChairOBJ, bunkerInterior, -995755633)
    PlaceObjectOnGroundProperly(OfficeChairOBJ)
    Wait(0.1)
    FreezeEntityPosition(OfficeChairOBJ, true)

    --SetObjectAsNoLongerNeeded(OfficeChairOBJ)
    end    
end

function ActivateStyleA()
    ActivateInteriorEntitySet(bunkerInterior, bunkerStyle[1])
    DeactivateInteriorEntitySet(bunkerInterior, bunkerStyle[2])
    DeactivateInteriorEntitySet(bunkerInterior, bunkerStyle[3]) 
end
function ActivateStyleB()
    ActivateInteriorEntitySet(bunkerInterior, bunkerStyle[2])
    DeactivateInteriorEntitySet(bunkerInterior, bunkerStyle[1])
    DeactivateInteriorEntitySet(bunkerInterior, bunkerStyle[3]) 
end
function ActivateStyleC()
    ActivateInteriorEntitySet(bunkerInterior, bunkerStyle[3])
    DeactivateInteriorEntitySet(bunkerInterior, bunkerStyle[1])
    DeactivateInteriorEntitySet(bunkerInterior, bunkerStyle[2]) 
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
                RemoveModelHide(897.0294, -3248.4165, -99.29, 5.0, GetHashKey("gr_prop_gr_tunnel_gate"), false)
                SetUpDisruptionLogisticsLaptop()
                SetUpDisruptionLogisticsLaptop()
                
        end
end

-- Sets up the display for the laptop inside the bunker.
function SetUpDisruptionLogisticsLaptop()
    -- Retrieve the player's character.
    local playerPed = GetPlayerPed(PlayerId())
    
    -- Check if the player is inside the bunker and if the laptop screen is not already set.
    if GetInteriorFromEntity(playerPed) == bunkerInterior and disruptScreen == false then
        print("GetInteriorFromEntity(playerPed) == bunkerInterior "..tostring(GetInteriorFromEntity(playerPed) == bunkerInterior))
        -- Request the texture for the laptop screen.
        RequestStreamedTextureDict(disruptionLogisticsScreen, 0)
        while not HasStreamedTextureDictLoaded(disruptionLogisticsScreen) do
            Wait(0.0)
        end
        -- If the texture is loaded, proceed with setting up the screen.
        if HasStreamedTextureDictLoaded(disruptionLogisticsScreen) then
            -- Register a render target (screen) if it's not already registered.
            while not IsNamedRendertargetRegistered(bunkerBusinessLaptop) do
                RegisterNamedRendertarget(bunkerBusinessLaptop, false)
                Wait(0.0)
            end
            -- Link the laptop's screen to the render target if not already linked.
            if not IsNamedRendertargetLinked(-424277613) and IsNamedRendertargetRegistered(bunkerBusinessLaptop) then
                LinkNamedRendertarget(-424277613)
                Wait(0.0)
            elseif IsNamedRendertargetLinked(-424277613) then
                disruptScreen = true -- Indicate that the laptop screen is now set up.
            end
        end
    end

    -- Print whether the render target is linked (for debugging).
    
    print("disruptScreen:"..tostring(disruptScreen))
    print("IsNamedRendertargetLinked "..tostring(IsNamedRendertargetLinked(-424277613)))
    print("GetInteriorFromEntity(playerPed) == bunkerInterior "..tostring(GetInteriorFromEntity(playerPed) == bunkerInterior))
end

-- Draws the Disruption Logistics screen on the laptop in the bunker.
function DrawDisruptLogistics()
    -- Retrieve the player's character.
    local playerPed = GetPlayerPed(PlayerId())

    -- Check if the player is inside the bunker and if the laptop screen is set up.
    if GetInteriorFromEntity(playerPed) == bunkerInterior and IsNamedRendertargetLinked(-424277613) then
        -- Get the render target ID for the laptop.
        local bunkerLaptopRenderTargetId = GetNamedRendertargetRenderId(bunkerBusinessLaptop)
        
        -- Set the current render target to the laptop screen for drawing.
        SetTextRenderId(bunkerLaptopRenderTargetId)
        -- Set up the position and order for drawing the screen.
        SetScreenDrawPosition(73, 73)
        SetScriptGfxDrawOrder(4)
        SetScriptGfxDrawBehindPausemenu(true)
        -- Draw the Disruption Logistics screen on the laptop.
        DrawSprite(disruptionLogisticsScreen, disruptionLogisticsScreen, 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
        -- Reset the render target to default after drawing.
        ScreenDrawPositionEnd()
        SetTextRenderId(GetDefaultScriptRendertargetRenderId())
    end
end


function DisAbleControlActionSet()
    DisableControlAction(0, 37, true) --*INPUT_SELECT_WEAPON*
    DisableControlAction(0, 157, true) --*INPUT_SELECT_WEAPON_UNARMED*
    DisableControlAction(0, 22, true) --*INPUT_JUMP*
    DisableControlAction(0, 159, true) --*INPUT_SELECT_WEAPON_HANDGUN*
    DisableControlAction(0, 160, true) --*INPUT_SELECT_WEAPON_SHOTGUN*
    DisableControlAction(0, 161, true) --*INPUT_SELECT_WEAPON_SMG*
    DisableControlAction(0, 162, true) --*INPUT_SELECT_WEAPON_AUTO_RIFLE*
    DisableControlAction(0, 163, true) --*INPUT_SELECT_WEAPON_SNIPER*
    DisableControlAction(0, 164, true) --*INPUT_SELECT_WEAPON_HEAVY*
    DisableControlAction(0, 165, true) --*INPUT_SELECT_WEAPON_SPECIAL*
    DisableControlAction(0, 158, true) --*INPUT_SELECT_WEAPON_MELEE*
    DisableControlAction(0, 24, true) --*INPUT_ATTACK*


end

function IsPlayerPlayingLaptopAnim(playerId)
    local ped = GetPlayerPed(playerId)

    if DoesEntityExist(ped) and not IsPedInjured(ped) then
        if IsEntityPlayingAnim(ped, AnimationDictToTest, "enter", 3) or
           IsEntityPlayingAnim(ped, AnimationDictToTest, "idle_a", 3) or
           IsEntityPlayingAnim(ped, AnimationDictToTest, "idle_b", 3) or
           IsEntityPlayingAnim(ped, AnimationDictToTest, "idle_c", 3) or
           IsEntityPlayingAnim(ped, AnimationDictToTest, "idle_d", 3) or
           IsEntityPlayingAnim(ped, AnimationDictToTest, "exit", 3) then
            return true
        else
            return false
        end
    end

end



function IsPlayerInBunkerDeskSeatLocate(bPrint)
    -- bPrint defaults to true if not provided
    bPrint = bPrint or true

    local playerPed = PlayerPedId()

    if IsPedRunning(playerPed) then
        return false, nil
    end

    local enteredFromRight = false

    if IsEntityInAngledArea(playerPed, 907.294678, -3206.696045, -98.187889, 908.211975, -3207.899170, -96.437889, 1.3125, false, true, 0) then
        if bPrint then
            --print("[PROPERTY_SEAT] IS_LOCAL_PLAYER_IN_BUNKER_DESK_SEAT_LOCATE: Player is in boss seat, entered from the right")
        end
        enteredFromRight = true
        return true, enteredFromRight
    elseif IsEntityInAngledArea(playerPed, 909.094727, -3205.729492, -98.188049, 909.589966, -3207.126221, -96.438103, 1.0, false, true, 0) then
        if bPrint then
            --print("[PROPERTY_SEAT] IS_LOCAL_PLAYER_IN_BUNKER_DESK_SEAT_LOCATE: Player is in boss seat, entered from the left")
        end
        enteredFromRight = false
        return true, enteredFromRight
    end

    return false, enteredFromRight
end

function ShowOverlay(sMessage, sAcceptButtonLabel, sCancelButtonLabel)
    BeginScaleformMovieMethod(Scaleform, "SHOW_OVERLAY")
        BeginTextCommandScaleformString(sMessage)
        EndTextCommandScaleformString()
        ScaleformMovieMethodAddParamIntString(sAcceptButtonLabel)
        ScaleformMovieMethodAddParamIntString(sCancelButtonLabel)


    EndScaleformMovieMethod()

end



function Things(Scaleform)   
    if HasScaleformMovieLoaded(Scaleform) then		 
        --Set_2dLayer(4)
        --enableMouse()

        BeginScaleformMovieMethod(Scaleform, "SET_STATS")
            ScaleformMovieMethodAddParamIntString("playerName")
            ScaleformMovieMethodAddParamIntString("playerOrgin")
            ScaleformMovieMethodAddParamIntString("bunkerName")
            ScaleformMovieMethodAddParamIntString("bunkerLocation")
            ScaleformMovieMethodAddParamInt(0)
            ScaleformMovieMethodAddParamInt(10)
            ScaleformMovieMethodAddParamInt(25)
            ScaleformMovieMethodAddParamInt(50)
            ScaleformMovieMethodAddParamInt(34)
            ScaleformMovieMethodAddParamInt(25000)
            ScaleformMovieMethodAddParamInt(5)
            ScaleformMovieMethodAddParamInt(0)
            ScaleformMovieMethodAddParamInt(1)
            ScaleformMovieMethodAddParamInt(0)
            ScaleformMovieMethodAddParamInt(2000)
            ScaleformMovieMethodAddParamInt(0)
            ScaleformMovieMethodAddParamInt(5)
            ScaleformMovieMethodAddParamInt(1)
        EndScaleformMovieMethod()



        
    end
end

AnimationDictToTest = "anim@amb@clubhouse@boss@male@"

function GetInDeskChair(side)
    local done = false
    local ChairCoords = {x = 908.670, y = -3206.994, z = -97.500} --GetEntityCoords(OfficeChairOBJ)
    local ChairRot = GetEntityRotation(OfficeChairOBJ, 2)
    --SetEntityCoords(OfficeChairOBJ, ChairCoords.x)

                RequestAnimDict(AnimationDictToTest)
                if not HasAnimDictLoaded(AnimationDictToTest) then
                    Wait(0.0)
                end

    if side == 0 or side == nil then
    SittScene = NetworkCreateSynchronisedScene(ChairCoords.x, ChairCoords.y, ChairCoords.z, ChairRot.x, ChairRot.y, ChairRot.z, 2, true, false, 1.0, 0.0, 1.0)
                NetworkAddPedToSynchronisedScene(PlayerPedId(), SittScene, AnimationDictToTest, "enter", 4.0, -1.5, 5, 16, 1000.0, 4)
                NetworkAddEntityToSynchronisedScene(OfficeChairOBJ, SittScene, AnimationDictToTest, "enter_chair", 4.0, 4.0, 32773)
                NetworkStartSynchronisedScene(SittScene)
                Wait(5100)
                isSittingInBossChair = true
                --NetworkStopSynchronisedScene(SittScene)
                --print("isSittingInBossChair " ..tostring(isSittingInBossChair))
                --print("IsPlayerPlayingLaptopAnim(playerId)"..tostring(IsPlayerPlayingLaptopAnim(PlayerId())))
                print("IsEntityPlayingAnim(PlayerPedId(), AnimationDictToTest, enter, 3)"..tostring(IsEntityPlayingAnim(PlayerPedId(), AnimationDictToTest, "enter", 3)))
                --PlayEntityAnim(playerPed, "idle_a",AnimationDictToTest, 3, true, false, true, 1, 0)
                done = true
    elseif side == 1 then
    SittScene = NetworkCreateSynchronisedScene(ChairCoords.x, ChairCoords.y, ChairCoords.z, ChairRot.x, ChairRot.y, ChairRot.z, 2, true, false, 1.0, 0.0, 1.0)
                NetworkAddPedToSynchronisedScene(PlayerPedId(), SittScene, AnimationDictToTest, "enter_LEFT", 4.0, -1.5, 5, 16, 1000.0, 4)
                NetworkAddEntityToSynchronisedScene(OfficeChairOBJ, SittScene, AnimationDictToTest, "enter_chair", 4.0, 4.0, 32773)
                NetworkStartSynchronisedScene(SittScene)
                Wait(5100)
                isSittingInBossChair = true
                --print("isSittingInBossChair " ..tostring(isSittingInBossChair))
                print("IsEntityPlayingAnim(PlayerPedId(), AnimationDictToTest, computer_idle, 3)"..tostring(IsEntityPlayingAnim(PlayerPedId(), AnimationDictToTest, "computer_idle", 3)))
                done = true
    
    end
    if isSittingInBossChair and done then
        SittScene = NetworkCreateSynchronisedScene(ChairCoords.x, ChairCoords.y, ChairCoords.z, ChairRot.x, ChairRot.y, ChairRot.z, 2, true, false, 1.0, 0.0, 1.0)
                NetworkAddPedToSynchronisedScene(PlayerPedId(), SittScene, AnimationDictToTest, "computer_idle", 4.0, -1.5, 5, 16, 1000.0, 4)
                NetworkAddEntityToSynchronisedScene(OfficeChairOBJ, SittScene, AnimationDictToTest, "COMPUTER_IDLE_CHAIR", 4.0, 4.0, 32773)
                NetworkStartSynchronisedScene(SittScene)
                
    end

end

function GetOutDeskChair()
    local done = false
    local ChairCoords = {x = 908.670, y = -3206.994, z = -97.500} --GetEntityCoords(OfficeChairOBJ)
    local ChairRot = GetEntityRotation(OfficeChairOBJ, 2)
                RequestAnimDict(AnimationDictToTest)
                RequestAnimDict("anim@amb@warehouse@laptop@")
                
                if not HasAnimDictLoaded(AnimationDictToTest) then
                    Wait(0.0)
                end
    if isSittingInBossChair then
    SittScene = NetworkCreateSynchronisedScene(ChairCoords.x, ChairCoords.y, ChairCoords.z, ChairRot.x, ChairRot.y, ChairRot.z, 2, true, false, 1.0, 0.0, 1.0)
                NetworkAddPedToSynchronisedScene(PlayerPedId(), SittScene, AnimationDictToTest, "exit", 4.0, -4.0, 5, 0, 1000.0, 0)
                NetworkAddEntityToSynchronisedScene(OfficeChairOBJ, SittScene, AnimationDictToTest, "exit_chair", 4.0, 4.0, 32773)
                NetworkStartSynchronisedScene(SittScene)
                Wait(5500)
                isSittingInBossChair = false
                NetworkStopSynchronisedScene(SittScene)
                print("isSittingInBossChair " ..tostring(isSittingInBossChair))
        return done
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
    Things(Scaleform)
    





    while true do
        if Flag then
            
            DrawScaleformMovieFullscreen(Scaleform, 255, 255, 255, 255, 0)
            ShowOverlay("DL_BUS_EMPTY", "OR_OVRLY_OK", "")
          
        end

        local playerPed = GetPlayerPed(PlayerId())
        DrawBunkerEntranceMarkers ()
        CutsceneCheck()
        
        Wait(0.0)
        if GetInteriorFromEntity(playerPed) == bunkerInterior then
            
            if IsPlayerInBunkerDeskSeatLocate() and IsControlJustPressed(0, 38) then
               

                
                GetInDeskChair()
                Wait(3000)
                print("IsPlayerPlayingLaptopAnim(playerId)"..tostring(IsPlayerPlayingLaptopAnim(PlayerId())))
                print("isSittingInBossChair " ..tostring(isSittingInBossChair))
            end
            if isSittingInBossChair and IsControlJustPressed(0, 25) then

                GetOutDeskChair()
                
            end

            DisAbleControlActionSet()
            DrawDisruptLogistics()
        end
        
    end
    
end)
