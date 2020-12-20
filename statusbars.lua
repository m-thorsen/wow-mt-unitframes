local MTUnitFrames = LibStub("AceAddon-3.0"):GetAddon("MTUnitFrames");

local UnitFrames = {
    PlayerFrame, PlayerFrameManaBar, PlayerFrameAlternateManaBar, PlayerFrameMyHealPredictionBar,
    TargetFrame, TargetFrameToT, FocusFrame, FocusFrameToT, PetFrame,
    PartyMemberFrame1, PartyMemberFrame2, PartyMemberFrame3, PartyMemberFrame4,
    Boss1TargetFrame, Boss2TargetFrame, Boss3TargetFrame, Boss4TargetFrame, Boss5TargetFrame,
};

local UnitFrameRegions = {
    "healthbar", "spellbar", "healAbsorbBar", "totalAbsorbBar",
    "AnimatedLossBar", "myHealPredictionBar", "otherHealPredictionBar",
    "manabar", "myManaCostPredictionBar",
};

function MTUnitFrames:InitStatusbars()
    local texture = self.db.global.texture;

    for _, frame in next, UnitFrames do
        for _, region in next, UnitFrameRegions do
            local bar = frame[region];

            if (bar and bar.SetStatusBarTexture) then
                bar:SetStatusBarTexture(texture);
            elseif (bar and bar.SetTexture) then
                bar:SetTexture(texture);
            end;
        end;
    end;
end;
