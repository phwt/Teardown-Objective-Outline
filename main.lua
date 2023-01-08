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

local outlineOpacity = 0.85

function tick(dt)
    enableRequiredOutline = GetBool(ReqiuredOutlineKey)
    enableOptionalOutline = GetBool(OptionalOutlineKey)
    enableEscapeOutline = GetBool(EscapeOutlineKey)
    enableRobotOutline = GetBool(RobotOutlineKey)

    -- Outline the escape vehicle
    if enableEscapeOutline then
        DrawBodyOutline(FindBody("escapevehicle", true), 117 / 255, 255 / 255, 123 / 255, outlineOpacity)
    end

    OutlineBodies(FindBodies("target", true), DrawObjectiveOutline)

    if enableRobotOutline then
        OutlineBodies(FindBodies("leg", true), DrawRobotOutline)
    end
end

function OutlineBodies(bodies, outlineFunction)
    for _, body in ipairs(bodies) do
        outlineFunction(body)
    end
end

function DrawObjectiveOutline(objective)
    local function drawOptionalOutline(optionalObjective)
        DrawBodyOutline(optionalObjective, 252 / 255, 250 / 255, 137 / 255, outlineOpacity)
    end

    local function drawRequiredOutline(requiredObjective)
        DrawBodyOutline(requiredObjective, 252 / 255, 250 / 255, 137 / 255, outlineOpacity)
    end

    local isOptional = HasTag(objective, "optional")
    local isRobot = HasTag(objective, "body")

    if isOptional and enableOptionalOutline then
        -- Outline optional objectives
        if isRobot then
            OutlineBodies(GetJointedBodies(objective), drawOptionalOutline)
        else
            drawOptionalOutline(objective)
        end
    end

    if not isOptional and enableRequiredOutline then
        -- Outline required objectives
        if isRobot then
            OutlineBodies(GetJointedBodies(objective), drawRequiredOutline)
        else
            drawRequiredOutline(objective)
        end
    end
end

function DrawRobotOutline(robot)
    local function drawRequiredOutline(part)
        DrawBodyOutline(part, 255 / 255, 107 / 255, 77 / 255, outlineOpacity)
    end

    local robotParts = GetJointedBodies(robot)
    OutlineBodies(robotParts, drawRequiredOutline)
end
