local MTUnitFrames = LibStub("AceAddon-3.0"):GetAddon("MTUnitFrames");

function MTUnitFrames:GetOptions()
    return {
        name = "MTUnitFrames",
        handler = MTUnitFrames,
        type = "group",
        args = {
            bb = {
                order = 21,
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
            bc = {
                order = 22,
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
        },
        db = {
            order = 41,
            type = "execute",
            name = "Reset to defaults",
            func = function()
                self.db:ResetDB();
                ReloadUI();
            end,
        }
    };
end;
