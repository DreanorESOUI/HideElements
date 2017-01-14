HideElements = {}
HideElements.name = "HideElements"
HideElements.configVersion = "2"
HideElements.defaults = {
  showWeaponSwap = true,
  showCompass = true,
  showCompassPins = true,
  showBossBar = true,
  showBossBarBrackets = true,
  showBossBarText = true
}

function HideElements.Initialize()
  --Load settings
  HideElements.savedVariables  = ZO_SavedVars:NewAccountWide("HideElementsVars", HideElements.configVersion, nil, HideElements.defaults)

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
      type = "header",
      name = "General",
    },
    [2] = {
      type = "checkbox",
      name = "Show Weapon Swap",
      tooltip = "Show Weapon Swap Icon near the Action bar",
      getFunc = function() return HideElements.savedVariables.showWeaponSwap end,
      setFunc = function(newValue) HideElements.savedVariables.showWeaponSwap = newValue; HideElements.ChangeWeaponSwap() end,
      default = HideElements.defaults.showWeaponSwap,
    },
    [3] = {
      type = "header",
      name = "Compass",
    },
	[4] = {
      type = "checkbox",
      name = "Show Compass",
      tooltip = "Show the Compass",
      getFunc = function() return HideElements.savedVariables.showCompass end,
      setFunc = function(newValue) HideElements.savedVariables.showCompass = newValue; HideElements.HideCompass() end,
      default = HideElements.defaults.showCompass,
	},
	[5] = {
	  type = "checkbox",
	  name = "Show Pins",
	  tooltip = "Show Pins of the Compass, auto hides compass",
	  getFunc = function() return HideElements.savedVariables.showCompassPins end,
	  setFunc = function(newValue) HideElements.savedVariables.showCompassPins = newValue; HideElements.HidePins() end,
	  default = HideElements.defaults.showCompassPins,
	},
	[6] = {
      type = "header",
      name = "Boss Bar",
    },
	[7] = {
      type = "checkbox",
      name = "Show Boss Bar",
      tooltip = "Show Boss Bar, auto hides brackets and text",
      getFunc = function() return HideElements.savedVariables.showBossBar end,
      setFunc = function(newValue) HideElements.savedVariables.showBossBar = newValue; HideElements.HideBossBar() end,
      default = HideElements.defaults.showBossBar,
	},
	[8] = {
	  type = "checkbox",
	  name = "Show Brackets",
	  tooltip = "Show left and right brackets",
	  getFunc = function() return HideElements.savedVariables.showBossBarBrackets end,
	  setFunc = function(newValue) HideElements.savedVariables.showBossBarBrackets = newValue; HideElements.HideBossBarBrackets() end,
	  default = HideElements.defaults.showBossBarBrackets,
	},
	[9] = {
	  type = "checkbox",
	  name = "Show Text",
	  tooltip = "Show Text",
	  getFunc = function() return HideElements.savedVariables.showBossBarText end,
	  setFunc = function(newValue) HideElements.savedVariables.showBossBarText = newValue; HideElements.HideBossBarText() end,
	  default = HideElements.defaults.showBossBarText,
	},
  }

  LAM:RegisterOptionControls(HideElements.name.."Config", controlData)
end

function HideElements.ChangeWeaponSwap()
  ZO_WeaponSwap_SetPermanentlyHidden(ZO_ActionBar1:GetNamedChild("WeaponSwap"), not HideElements.savedVariables.showWeaponSwap)
end

function HideElements.HidePins()
  -- pins
  local compassPins = WINDOW_MANAGER:GetControlByName("ZO_Compass", "Container")
  compassPins:SetHidden(not HideElements.savedVariables.showCompassPins)
  
  HideElements.savedVariables.showCompass = HideElements.savedVariables.showCompassPins;
  HideElements.HideCompass()
end

function HideElements.HideCompass()
  local hideCompass = not HideElements.savedVariables.showCompass
  local compassCenter = WINDOW_MANAGER:GetControlByName("ZO_CompassFrame", "Center")
  local compassLeft = WINDOW_MANAGER:GetControlByName("ZO_CompassFrame", "Left")
  local compassRight = WINDOW_MANAGER:GetControlByName("ZO_CompassFrame", "Right")
  compassCenter:SetHidden(hideCompass)
  compassLeft:SetHidden(hideCompass)
  compassRight:SetHidden(hideCompass)
end

function HideElements.HideBossBar()
  local hideBossBar = not HideElements.savedVariables.showBossBar
  local barLeft = WINDOW_MANAGER:GetControlByName("ZO_BossBar", "HealthBarLeft")
  local barRight = WINDOW_MANAGER:GetControlByName("ZO_BossBar", "HealthBarRight")
  barLeft:SetHidden(hideBossBar)
  barRight:SetHidden(hideBossBar)
    
  HideElements.savedVariables.showBossBarBrackets = HideElements.savedVariables.showBossBar;
  HideElements.savedVariables.showBossBarText = HideElements.savedVariables.showBossBar;
  HideElements.HideBossBarBrackets()
  HideElements.HideBossBarText()
end

function HideElements.HideBossBarBrackets()
  local hideBrackets = not HideElements.savedVariables.showBossBarBrackets
  local bracketRight = WINDOW_MANAGER:GetControlByName("ZO_BossBar", "BracketRight")
  local bracketLeft = WINDOW_MANAGER:GetControlByName("ZO_BossBar", "BracketLeft")
  bracketRight:SetHidden(hideBrackets)
  bracketLeft:SetHidden(hideBrackets)
end

function HideElements.HideBossBarText()
  local text = WINDOW_MANAGER:GetControlByName("ZO_BossBar", "HealthText")
  text:SetHidden(not HideElements.savedVariables.showBossBarText)
end

function HideElements.Refresh()
  HideElements.ChangeWeaponSwap()
  HideElements.HideCompass()
  HideElements.HideBossBar()
  HideElements.HidePins()
end

function HideElements.OnAddOnLoaded(event, addonName)
  if addonName == HideElements.name then
    HideElements.Initialize()
  end
end

EVENT_MANAGER:RegisterForEvent(HideElements.name, EVENT_ADD_ON_LOADED, HideElements.OnAddOnLoaded)