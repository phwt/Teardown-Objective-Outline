#include "key.lua"

local enableRequiredOutline
local enableOptionalOutline
local enableEscapeOutline
local enableRobotOutline

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
    if (not HasKey(RobotOutlineKey)) then
        SetBool(RobotOutlineKey, true)
    end
end

local opacity = 0.85
local requiredObjectives = {}
local optionalObjectives = {}
local robotParts = {}

function draw(dt)
    enableRequiredOutline = GetBool(ReqiuredOutlineKey)
    enableOptionalOutline = GetBool(OptionalOutlineKey)
    enableEscapeOutline = GetBool(EscapeOutlineKey)
    enableRobotOutline = GetBool(RobotOutlineKey)


    if enableEscapeOutline then
        DrawBodyOutline(FindBody("escapevehicle", true), 117 / 255, 255 / 255, 123 / 255, opacity) -- Escape Vehicle (Green)
    end

    for _, target in ipairs(FindBodies("target", true)) do
        local parts = { target }

        local isOptional = HasTag(target, "optional")
        local isRobot = HasTag(target, "body")

        if isRobot then
            MergeTables(parts, GetJointedBodies(target))
        end

        if isOptional and enableOptionalOutline then
            MergeTables(optionalObjectives, parts)
        end

        if not isOptional and enableRequiredOutline then
            MergeTables(requiredObjectives, parts)
        end
    end

    if enableRobotOutline then
        for _, leg in ipairs(FindBodies("leg", true)) do
            local parts = GetJointedBodies(leg)
            local isRobotValid = true

            if enableOptionalOutline or enableRequiredOutline then
                if IsRobotTarget(parts) then
                    isRobotValid = false
                end
            end

            if isRobotValid then
                MergeTables(robotParts, parts)
            end
        end
    end

    OutlineBodies(optionalObjectives, function(part) DrawBodyOutline(part, 1, 1, 1, opacity) end) -- Optional Objectives (White)
    OutlineBodies(requiredObjectives, function(part) DrawBodyOutline(part, 252 / 255, 250 / 255, 137 / 255, opacity) end) -- Required Objectives (Yellow)
    OutlineBodies(robotParts, function(part) DrawBodyOutline(part, 255 / 255, 107 / 255, 77 / 255, opacity) end) -- Robots (Red)
end

function IsRobotTarget(localRobotParts)
    for _, part in ipairs(localRobotParts) do
        if HasTag(part, "target") then return true end
    end
    return false
end

function OutlineBodies(bodies, outlineFunction)
    for _, body in ipairs(bodies) do
        outlineFunction(body)
    end
end

function MergeTables(t1, t2)
    for _, i in ipairs(t2) do
        table.insert(t1, i)
    end
end
