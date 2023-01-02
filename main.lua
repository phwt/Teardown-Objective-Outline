#include "key.lua"

local enableRequiredOutline
local enableOptionalOutline
local enableEscapeOutline

function init()
    if (not HasKey(ReqiuredOutlineKey)) then
        SetBool(ReqiuredOutlineKey, true)
    end
    if (not HasKey(OptionalOutlineKey)) then
        SetBool(OptionalOutlineKey, true)
    end
    if (not HasKey(EscapeOutlineKey)) then
        SetBool(EscapeOutlineKey, true)
    end

    enableRequiredOutline = GetBool(ReqiuredOutlineKey)
    enableOptionalOutline = GetBool(OptionalOutlineKey)
    enableEscapeOutline = GetBool(EscapeOutlineKey)
end

local outlineOpacity = 0.85

function draw(dt)
    -- Outline the escape vehicle
    if enableEscapeOutline then
        DrawBodyOutline(FindBody("escapevehicle", true), 117 / 255, 255 / 255, 123 / 255, outlineOpacity)
    end

    local objectives = FindBodies("target", true)
    for _, objective in ipairs(objectives) do
        DrawObjectiveOutline(objective)
    end
end

function DrawObjectiveOutline(objective)

    if HasTag(objective, "optional") then
        -- Outline optional objectives
        if enableOptionalOutline then
            DrawBodyOutline(objective, 1, 1, 1, outlineOpacity)
        end
    else
        -- Outline required objectives
        if enableRequiredOutline then
            DrawBodyOutline(objective, 252 / 255, 250 / 255, 137 / 255, outlineOpacity)
        end
    end
end
