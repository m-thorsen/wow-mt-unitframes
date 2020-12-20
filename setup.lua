local MTUnitFrames = LibStub("AceAddon-3.0"):NewAddon("MTUnitFrames", "AceConsole-3.0");

local defaults = {
    global = {
        offsetY = 200,
        offsetX = 250,
        texture = "Interface/Addons/MTUnitFrames/Media/default",
    }
};

-- Called when the addon is loaded
function MTUnitFrames:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("MTUnitFramesDB", defaults, true);
    LibStub("AceConfig-3.0"):RegisterOptionsTable("MTUnitFrames", self:GetOptions());
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MTUnitFrames", "MTUnitFrames");

    self:InitUnitframes();
    self:InitMoveFrames();
    self:InitStatusbars();
    self:RegisterChatCommand("MTUF", "ChatCommand");
end;

function MTUnitFrames:OnEnable() end;
function MTUnitFrames:OnDisable() end;
function MTUnitFrames:ChatCommand()
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame);
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame); -- Intentionally called twice due to a bliz bug
end;

-- Add Interface option
function MTUnitFrames:GetOptions()
    return {
        name = "MTUnitFrames",
        handler = MTUnitFrames,
        type = "group",
        args = {
            11 = {
                order = 11,
                type = "range",
                name = "Space between",
                min = 100,
                max = 500,
                step = 1,
                get = function(info)
                    return self.db.global.offsetX;
                end,
                set = function(info, value)
                    self.db.global.offsetX = value;
                    self:InitMoveFrames();
                end,
            },
            ab = {
                order = 12,
                type = "range",
                name = "Distance from bottom",
                min = 150,
                max = 300,
                step = 1,
                get = function(info)
                    return self.db.global.offsetY;
                end,
                set = function(info, value)
                    self.db.global.offsetY = value;
                    self:InitMoveFrames();
                end,
            },
            ac = {
                order = 13,
                type = "execute",
                name = "Reset to defaults",
                func = function()
                    self.db:ResetDB();
                    ReloadUI();
                end,
            },
        },
    };
end;
