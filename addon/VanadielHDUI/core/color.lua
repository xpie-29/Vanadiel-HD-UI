local color = {};

local function clamp_channel(value)
    value = tonumber(value) or 0;
    if value < 0 then return 0; end
    if value > 255 then return 255; end
    return math.floor(value + 0.5);
end

function color.is_hex(value)
    return type(value) == 'string'
        and value:match('^#[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]$') ~= nil;
end

function color.to_rgb(value, fallback)
    if not color.is_hex(value) then
        value = fallback or '#FFFFFF';
    end
    return tonumber(value:sub(2, 3), 16) or 255,
        tonumber(value:sub(4, 5), 16) or 255,
        tonumber(value:sub(6, 7), 16) or 255;
end

function color.from_rgb(red, green, blue)
    return ('#%02X%02X%02X'):format(
        clamp_channel(red), clamp_channel(green), clamp_channel(blue));
end

function color.to_u32(value, alpha, fallback)
    local red, green, blue = color.to_rgb(value, fallback);
    alpha = clamp_channel(alpha == nil and 255 or alpha);
    return alpha * 0x01000000
        + blue * 0x00010000
        + green * 0x00000100
        + red;
end

function color.with_alpha_u32(value, alpha)
    alpha = clamp_channel(alpha);
    return alpha * 0x01000000 + value % 0x01000000;
end

function color.to_float4(value, fallback)
    local red, green, blue = color.to_rgb(value, fallback);
    return { red / 255, green / 255, blue / 255, 1.0 };
end

function color.from_float4(values)
    return color.from_rgb(
        (tonumber(values[1]) or 0) * 255,
        (tonumber(values[2]) or 0) * 255,
        (tonumber(values[3]) or 0) * 255);
end

return color;
