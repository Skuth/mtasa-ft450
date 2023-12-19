local screenWidth, screenHeight = guiGetScreenSize()

local browserGUI
local browser

local page = "http://mta/local/fueltech.html"

function loadBrowser()
  browserGUI = guiCreateBrowser(
    ((screenWidth - 480) - 32),
    ((screenHeight - 296) - 32),
    480,
    296,
    true,
    true,
    false
  )

  browser = guiGetBrowser(browserGUI)

  addEventHandler(
    "onClientBrowserCreated",
    browser,
    function()
      loadBrowserURL(browser, page)
    end
  )
end

function handleRender()
  if isPlayerInVehicle(localPlayer) then
    local vehicle = getPlayerOccupiedVehicle(localPlayer)

    local rpm = getVehicleRPM(vehicle)
    local gear = getVehicleCurrentGear(vehicle)
    local speed = getElementSpeed(vehicle) * 3
    local engineState = getVehicleEngineState(vehicle) and "true" or "false"

    executeBrowserJavascript(browser, ("updateFtParams(%d, %d, %d, %s)"):format(rpm, gear, speed, engineState))
    executeBrowserJavascript(browser, "app.updateRender()")
  end
end

function getElementSpeed(element, unit)
  if not isElement(element) then return 0 end

  local elementType = getElementType(element)

  assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
  assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
  unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))

  local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
  return (Vector3(getElementVelocity(element)) * mult).length
end

function getVehicleRPM(vehicle)
  local vehicleRPM = 0
  if (vehicle) then
      if (getVehicleEngineState(vehicle) == true) then
          if getVehicleCurrentGear(vehicle) > 0 then
              vehicleRPM = math.floor(((getElementSpeed(vehicle, "km/h") / getVehicleCurrentGear(vehicle)) * 160) + 0.5)
              if (vehicleRPM < 650) then
                  vehicleRPM = math.random(650, 750)
              elseif (vehicleRPM >= 9000) then
                  vehicleRPM = math.random(9000, 9900)
              end
          else
              vehicleRPM = math.floor((getElementSpeed(vehicle, "km/h") * 160) + 0.5)
              if (vehicleRPM < 650) then
                  vehicleRPM = math.random(650, 750)
              elseif (vehicleRPM >= 9000) then
                  vehicleRPM = math.random(9000, 9900)
              end
          end
      else
          vehicleRPM = 0
      end

      return tonumber(vehicleRPM)
  else
      return 0
  end
end

addEventHandler(
  "onClientVehicleEnter",
  getRootElement(),
  function()
    loadBrowser()
    addEventHandler("onClientRender", root, handleRender)
  end
)

addEventHandler(
  "onClientVehicleExit",
  getRootElement(),
  function()
    if isElement(browserGUI) then
      destroyElement(browserGUI)
    end

    if isElement(browser) then
      destroyElement(browser)
    end

    removeEventHandler ("onClientRender", root, handleRender)
  end
)