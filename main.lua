#include "key.lua"

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

function draw(dt)
    local enableRequiredOutline = GetBool(ReqiuredOutlineKey)
    local enableOptionalOutline = GetBool(OptionalOutlineKey)
    local enableEscapeOutline = GetBool(EscapeOutlineKey)
    local enableRobotOutline = GetBool(RobotOutlineKey)

    local requiredObjectives = {}
    local optionalObjectives = {}
    local robotParts = {}

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
            MergeTables(robotParts, GetJointedBodies(leg))
        end
    end

    OutlineBodies(robotParts, function(part) DrawBodyOutline(part, 255 / 255, 107 / 255, 77 / 255, opacity) end) -- Robots (Red)
    OutlineBodies(optionalObjectives, function(part) DrawBodyOutline(part, 1, 1, 1, opacity) end) -- Optional Objectives (White)
    OutlineBodies(requiredObjectives, function(part) DrawBodyOutline(part, 252 / 255, 250 / 255, 137 / 255, opacity) end) -- Required Objectives (Yellow)
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
