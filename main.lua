local outlineOpacity = 0.85

function draw(dt)
    -- Outline the escape vehicle
    DrawBodyOutline(FindBody("escapevehicle", true), 117/255, 255/255, 123/255, outlineOpacity)

    local objectives = FindBodies("target", true)
    for _, objective in ipairs(objectives) do
        DrawObjectiveOutline(objective)
    end
end

function DrawObjectiveOutline(objective)
    if HasTag(objective, "optional") then
        -- Outline optional objectives
        DrawBodyOutline(objective, 1, 1, 1, outlineOpacity)
    else
        -- Outline required opbjectives
        DrawBodyOutline(objective, 252/255, 250/255, 137/255, outlineOpacity)
    end
end
