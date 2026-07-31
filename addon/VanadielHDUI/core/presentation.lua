local presentation = {};
presentation.__index = presentation;

local function clamp(value, minimum, maximum)
    if value < minimum then
        return minimum;
    end
    if value > maximum then
        return maximum;
    end
    return value;
end

function presentation.new(imgui)
    return setmetatable({
        imgui = imgui,
    }, presentation);
end

function presentation:scaled_size(base_size, scale, minimum)
    return clamp(base_size * scale, minimum or 1, 4096);
end

function presentation:measure_text(text, pixel_size)
    local imgui = self.imgui;
    local content = tostring(text or '');
    if content == '' then
        return 0, pixel_size;
    end

    local line_height = tonumber(imgui.GetTextLineHeight and imgui.GetTextLineHeight()) or 0;
    local width = tonumber(imgui.CalcTextSize and imgui.CalcTextSize(content)) or 0;
    if line_height > 0 then
        return width * (pixel_size / line_height), pixel_size;
    end
    return width, pixel_size;
end

function presentation:draw_text(draw_list, text, x, y, color, pixel_size)
    local imgui = self.imgui;
    local position = { x, y };
    local font = imgui.GetFont and imgui.GetFont() or nil;
    local ok = false;

    if font ~= nil then
        ok = pcall(function ()
            draw_list:AddText(font, pixel_size, position, color, tostring(text));
        end);
    end
    if not ok then
        draw_list:AddText(position, color, tostring(text));
    end
end

function presentation:measure_lines(lines)
    local width = 0;
    local height = 0;
    for index = 1, #lines do
        local line = lines[index];
        local line_width, line_height =
            self:measure_text(line.text, line.size);
        line.width = line_width;
        line.height = line_height;
        if line_width > width then
            width = line_width;
        end
        height = height + line_height;
        if index < #lines then
            height = height + (line.spacing_after or 0);
        end
    end
    return width, height;
end

function presentation:draw_lines(draw_list, origin_x, origin_y, lines)
    local y = origin_y;
    for index = 1, #lines do
        local line = lines[index];
        self:draw_text(draw_list, line.text, origin_x, y, line.color, line.size);
        y = y + line.height;
        if index < #lines then
            y = y + (line.spacing_after or 0);
        end
    end
end

return presentation;
