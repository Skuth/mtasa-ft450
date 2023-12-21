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

function destroyBrowser()
  if isElement(browserGUI) then
    destroyElement(browserGUI)
  end

  if isElement(browser) then
    destroyElement(browser)
  end
end

function handleRender()
  if exports["fueltech"]:isPlayerInValidVehicle() then
    local vehicle = getPedOccupiedVehicle(localPlayer)

    local rpm = exports["fueltech"]:getVehicleRPM(vehicle)
    local gear = getVehicleCurrentGear(vehicle)
    local numberOfGears = getVehicleHandling(vehicle).numberOfGears
    local speed = exports["fueltech"]:getElementSpeed(vehicle) * 3
    local engineState = getVehicleEngineState(vehicle) and "true" or "false"

    executeBrowserJavascript(browser, ("updateFtParams(%d, %d, %d, %d, %s)"):format(rpm, gear, numberOfGears, speed, engineState))
    executeBrowserJavascript(browser, "app.updateRender()")
  end
end

addEventHandler(
  "onClientVehicleEnter",
  getRootElement(),
  function(player)
    if (player == localPlayer) then
      loadBrowser()
      addEventHandler("onClientRender", root, handleRender)
    end
  end
)

addEventHandler(
  "onClientVehicleExit",
  getRootElement(),
  function(player)
    if (player == localPlayer) then
      destroyBrowser()
      removeEventHandler("onClientRender", root, handleRender)
    end
  end
)

addEventHandler(
  "onClientResourceStart",
  getRootElement(),
  function()
    destroyBrowser()
    removeEventHandler("onClientRender", root, handleRender)

    if exports["fueltech"]:isPlayerInValidVehicle() then
      loadBrowser()
      addEventHandler("onClientRender", root, handleRender)
    end
  end
)