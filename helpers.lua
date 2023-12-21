function isPlayerInValidVehicle()
  if isPedInVehicle(localPlayer) then
    local vehicle = getPedOccupiedVehicle(localPlayer)
    local vehicleType = getVehicleType(vehicle)

    if vehicleType == "Automobile"
      or vehicleType == "Bike"
      or vehicleType == "Monster Truck"
      or vehicleType == "Quad"
    then
      return true
    end
  end

  return false
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