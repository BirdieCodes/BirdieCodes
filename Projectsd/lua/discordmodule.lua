-- [[ VARIABLES ]] --

local httpservice = game:GetService("HttpService")
local httprequest = httprequest or syn.request

-- [[ FUNCTIONS ]] -- 

local function checkInvite(inviteCode)
    local request = httprequest({
        Url = "https://discord.com/api/invites/" .. inviteCode,
        Method = "GET"
    })

    if request.Success then
        local inviteData = httpservice:JSONDecode(request.Body)
        if inviteData.guild.id == "" then -- discord server ID
            return true
        end
    end

    return false
end

local function DiscordInvite(inviteCode)
    for i = 6463, 6472 do
        local request = httprequest({
            Url = string.format("http://127.0.0.1:%d/rpc?v=1", i),
            Method = "POST",
            Headers = {
                Origin = "https://discord.com",
                ["Content-Type"] = "application/json"
            },
            Body = httpservice:JSONEncode({
                cmd = "INVITE_BROWSER",
                nonce = string.lower(httpservice:GenerateGUID(false)),
                args = {
                    code = inviteCode
                }
            })
        })

        if request.Success then
            break
        end
    end
end

local function sendDiscordInviteIfNotJoined(inviteCode)
    if not checkInvite(inviteCode) then
        DiscordInvite(inviteCode)
    end
end

sendDiscordInviteIfNotJoined("") -- your invite code here
