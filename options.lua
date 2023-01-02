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

function draw()
    -- Title
    UiAlign("center middle")
    UiTranslate(UiCenter(), 150)
    UiFont("bold.ttf", 64)
    UiText("Objective Outline - Options")

    -- Options
    UiTranslate(0, 150)
    UiFont("regular.ttf", 32)

    enableRequiredOutline = UiBoolOption("Outline Required Objective", ReqiuredOutlineKey, enableRequiredOutline)
    enableOptionalOutline = UiBoolOption("Outline Optional Objective", OptionalOutlineKey, enableOptionalOutline)
    enableEscapeOutline = UiBoolOption("Outline Escape Vehicle", EscapeOutlineKey, enableEscapeOutline)
end

function UiBoolOption(text, key, initialValue)
    UiText(text)
    UiTranslate(0, 35)

    local returnValue = initialValue
    if initialValue then
        UiColor(119 / 255, 221 / 255, 118 / 255) -- Green
        if UiTextButton("Enabled") then
            returnValue = false
            SetBool(key, returnValue)
        end
    else
        UiColor(232 / 255, 107 / 255, 77 / 255) -- Red
        if UiTextButton("Disabled") then
            returnValue = true
            SetBool(key, returnValue)
        end
    end

    UiTranslate(0, 80)
    UiColor(1, 1, 1)

    return returnValue
end
