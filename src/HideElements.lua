HideElements = {}
HideElements.name = "HideElements"
HideElements.configVersion = "1"
HideElements.defaults = {
  showWeaponSwap = true,
  showCompass = true,
  showCompassPins = true
}

function HideElements.Initialize()
  --Load settings
  HideElements.savedVariables = ZO_SavedVars:NewAccountWide("HideElementsVars", HideElements.configVersion, nil, HideElements.defaults)

  HideElements.CreateOptions()
  HideElements.Refresh()
end

function HideElements.CreateOptions()
  local LAM = LibStub("LibAddonMenu-2.0")
  panelData = {
    type = "panel",
    name = "Hide Elements",
    displayName = "Hide User Interface Elements",
    author = "@NoPantsuNoLife",
    registerForDefaults = true,
  }
  LAM:RegisterAddonPanel(HideElements.name.."Config", panelData)

  controlData = {
    [1] = {
      type = "checkbox",
      name = "Show Weapon Swap",
      tooltip = "Show Weapon Swap Icon near the Action bar",
      getFunc = function() return HideElements.savedVariables.showWeaponSwap end,
      setFunc = function(newValue) HideElements.savedVariables.showWeaponSwap = newValue; HideElements.ChangeWeaponSwap() end,
      default = HideElements.defaults.showWeaponSwap,
    },
    [2] = {
      type = "submenu",
      name = "Compass",
      tooltip = "Compass options",
      controls = 	{
        [1] = {
          type = "checkbox",
          name = "Show Compass",
          tooltip = "Show the Compass",
          getFunc = function() return HideElements.savedVariables.showCompass end,
          setFunc = function(newValue) HideElements.savedVariables.showCompass = newValue; HideElements.ChangeCompass() end,
          default = HideElements.defaults.showCompass,
        },
        [2] = {
          type = "checkbox",
          name = "Show Pins",
          tooltip = "Show Pins of the Compass",
          getFunc = function() return HideElements.savedVariables.showCompassPins end,
          setFunc = function(newValue) HideElements.savedVariables.showCompassPins = newValue; HideElements.ChangeCompass() end,
          default = HideElements.defaults.showCompassPins,
        },
      },
    },
  }

  LAM:RegisterOptionControls(HideElements.name.."Config", controlData)
end

function HideElements.ChangeWeaponSwap()
  ZO_WeaponSwap_SetPermanentlyHidden(ZO_ActionBar1:GetNamedChild("WeaponSwap"), not HideElements.savedVariables.showWeaponSwap)
end

function HideElements.ChangeCompass()
  local hideCompass = not HideElements.savedVariables.showCompass
  --compass
  local compassCenter = WINDOW_MANAGER:GetControlByName("ZO_CompassFrame", "Center")
  local compassLeft = WINDOW_MANAGER:GetControlByName("ZO_CompassFrame", "Left")
  local compassRight = WINDOW_MANAGER:GetControlByName("ZO_CompassFrame", "Right")
  compassCenter:SetHidden(hideCompass)
  compassLeft:SetHidden(hideCompass)
  compassRight:SetHidden(hideCompass)

  -- pins
  local compassPins = WINDOW_MANAGER:GetControlByName("ZO_Compass", "Container")
  compassPins:SetHidden(not HideElements.savedVariables.showCompassPins)
end

function HideElements.Refresh()
  HideElements.ChangeWeaponSwap()
  HideElements.ChangeCompass()
end

function HideElements.OnAddOnLoaded(event, addonName)
  if addonName == HideElements.name then
    HideElements.Initialize()
  end
end

EVENT_MANAGER:RegisterForEvent(HideElements.name, EVENT_ADD_ON_LOADED, HideElements.OnAddOnLoaded)
