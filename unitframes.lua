local MTUnitFrames = LibStub("AceAddon-3.0"):GetAddon("MTUnitFrames");

local function ApplyCommonFrameTweaks(frame)
    frame.name:ClearAllPoints();
    frame.healthbar:ClearAllPoints();
    frame.healthbar:SetHeight(28);
    frame.healthbar.LeftText:SetPoint("LEFT", frame.healthbar, "LEFT", 3, 0);
    frame.healthbar.RightText:SetPoint("RIGHT", frame.healthbar, "RIGHT", -3, 0);
    frame.healthbar.TextString:SetPoint("CENTER", frame.healthbar, "CENTER", 0, 0);
end;

-- Return an appropriate unit color based on class (or threat situation)
local function GetUnitColor(unit, useThreatColors)
    if (UnitIsTapDenied(unit) or not UnitIsConnected(unit)) then
        return GRAY_FONT_COLOR:GetRGB();
    elseif (UnitIsPlayer(unit) and UnitClass(unit)) then
        local _, class = UnitClass(unit);
        local c = RAID_CLASS_COLORS[class];
        return c.r, c.g, c.b;
    elseif (UnitReaction(unit, "player") and UnitReaction(unit, "player") > 4) then
        return GREEN_FONT_COLOR:GetRGB();
    elseif (useThreatColors) then
        threatLevel = UnitThreatSituation("player", unit);
        if (threatLevel == 3) then return RED_FONT_COLOR:GetRGB();
        elseif (threatLevel == 2) then return ORANGE_FONT_COLOR:GetRGB();
        elseif (threatLevel == 1) then return YELLOW_FONT_COLOR:GetRGB();
        elseif (threatLevel ~= nil) then return GREEN_FONT_COLOR:GetRGB();
        end;
    end;
    return UnitSelectionColor(unit, true);
end;

local function SetHealthbarColor(bar)
    if not UnitExists(bar.unit) then end;
    bar:SetStatusBarColor(GetUnitColor(bar.unit));
end;

local function TweakPlayerFrame(frame)
    PlayerFrameTexture:SetTexture("Interface/Addons/MTUnitFrames/Media/TargetFrame");
    PlayerStatusTexture:SetTexture("Interface/Addons/MTUnitFrames/Media/Player-Status");
    PlayerStatusTexture:SetWidth(192);
    ApplyCommonFrameTweaks(frame);
    frame.healthbar:SetPoint("TOPRIGHT", -5, -24);
    frame.name:Hide();
    frame.name:SetPoint("CENTER", frame, "CENTER", 50.5, 36);
end;

local function TweakVehicleFrame(frame, vehicle)
    frame.healthbar:ClearAllPoints();
    frame.manabar:ClearAllPoints();
    if (vehicle == "Natural") then
        PlayerFrameVehicleTexture:SetTexture("Interface/Vehicles/UI-Vehicle-Frame-Organic");
        PlayerFrameFlash:SetTexture("Interface/Vehicles/UI-Vehicle-Frame-Organic-Flash");
        PlayerFrameFlash:SetTexCoord(-0.02, 1, 0.07, 0.86);
        frame.healthbar:SetSize(103, 12);
        frame.healthbar:SetPoint("TOPLEFT", 116, -41);
        frame.manabar:SetSize(103, 12);
        frame.manabar:SetPoint("TOPLEFT", 116, -52);
    else
        PlayerFrameVehicleTexture:SetTexture("Interface/Vehicles/UI-Vehicle-Frame");
        PlayerFrameFlash:SetTexture("Interface/Vehicles/UI-Vehicle-Frame-Flash");
        PlayerFrameFlash:SetTexCoord(-0.02, 1, 0.07, 0.86);
        frame.healthbar:SetPoint("TOPLEFT", 119, -41);
        frame.healthbar:SetSize(100, 12);
        frame.manabar:SetSize(100, 12);
        frame.manabar:SetPoint("TOPLEFT", 119, -52);
    end;
    PlayerName:SetPoint("CENTER", 50, 23);
    PlayerFrameBackground:SetWidth(114);
end

local function TweakTargetFrame(frame)
    local type = UnitClassification(frame.unit);
    frame.nameBackground:Hide();
    if (not frame.texture) then
        local tex = frame:CreateTexture(nil, "BACKGROUND");
        tex:SetTexture("Interface/Addons/MTUnitFrames/Media/TargetingFrameShadow");
        tex:SetPoint("TOPLEFT", frame, "TOPLEFT", -25, 16);
        tex:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 20, 0);
        frame.texture = tex;
    end
    ApplyCommonFrameTweaks(frame);
    frame.threatNumericIndicator:SetPoint("BOTTOM", PlayerFrame, "TOP", 72, -21);
    frame.deadText:SetPoint("CENTER", frame.healthbar, "CENTER", 0, 0);
    frame.deadText:SetTextColor(0.5, 0.5, 0.5);
    frame.healthbar:ClearAllPoints();
    frame.Background:SetPoint("TOP", frame.healthbar, "TOP", 0, 0);
    if (type == "minus") then
        frame.texture:Hide();
        frame.name:SetPoint("LEFT", frame, 16, 17);
        frame.healthbar:SetPoint("LEFT", 5, 3);
        frame.healthbar:SetHeight(12);
        frame.Background:SetHeight(12);
        if (frame.threatIndicator) then
            frame.threatIndicator:SetTexture("Interface/TargetingFrame/UI-TargetingFrame-Minus-Flash");
            frame.threatIndicator:SetTexCoord(0, 1, 0, 1);
            frame.threatIndicator:SetWidth(256);
            frame.threatIndicator:SetHeight(128);
            frame.threatIndicator:SetPoint("TOPLEFT", frame, "TOPLEFT", -24, 0);
        end;
    else
        frame.texture:Show();
        frame.name:SetPoint("LEFT", frame, 15, 36);
        frame.healthbar:SetPoint("TOPLEFT", 5, -24);
        frame.Background:SetHeight(40);
        if (type == "worldboss" or type == "elite") then
            frame.borderTexture:SetTexture("Interface/Addons/MTUnitFrames/Media/TargetFrame-Elite");
        elseif (type == "rareelite") then
            frame.borderTexture:SetTexture("Interface/Addons/MTUnitFrames/Media/TargetFrame-RareElite");
        elseif (type == "rare") then
            frame.borderTexture:SetTexture("Interface/Addons/MTUnitFrames/Media/TargetFrame-Rare");
        else
            frame.borderTexture:SetTexture("Interface/Addons/MTUnitFrames/Media/TargetFrame");
        end;
        if (frame.threatIndicator) then
            frame.threatIndicator:SetTexCoord(0, 0.9453125, 0, 0.181640625);
            frame.threatIndicator:SetWidth(242);
            frame.threatIndicator:SetHeight(93);
            frame.threatIndicator:SetPoint("TOPLEFT", frame, "TOPLEFT", -24, 0);
        end;
    end;
end;

function MTUnitFrames:InitUnitframes()
    hooksecurefunc("PlayerFrame_ToPlayerArt", TweakPlayerFrame);
    hooksecurefunc("PlayerFrame_ToVehicleArt", TweakVehicleFrame);
    hooksecurefunc("TargetFrame_CheckClassification", TweakTargetFrame);
    hooksecurefunc("UnitFrameHealthBar_Update", SetHealthbarColor);
    hooksecurefunc("HealthBar_OnValueChanged", SetHealthbarColor);
end;
