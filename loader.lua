-- // TechHub Loader
-- // By: dj
-- // Version: 1.0

local TechHub = {}

-- // Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- // Config
getgenv().TechHub = {
    ["Key"] = "";

    ["Quest"] = {
        ["Evo Race V1"] = true;
        ["Evo Race V2"] = true;
        ["RGB Haki"] = true;
        ["Pull Lerver"] = true;
    };

    Sword = {
        "Dual-Headed Blade";
        "Smoke Admiral";
        "Wardens Sword";
        "Cutlass";
        "Katana";
        "Dual Katana";
        "Triple Katana";
        "Iron Mace";
        "Saber";
        "Pole (1st Form)";
        "Gravity Blade";
        "Longsword";
        "Rengoku";
        "Midnight Blade";
        "Soul Cane";
        "Bisento";
        "Yama";
        "Tushita";
        "Cursed Dual Katana";
    };

    Gun = {
        "Skull Guitar";
        "Kabucha";
        "Venom Bow";
        "Musket";
        "Flintlock";
        "Refined Slingshot";
        "Magma Blaster";
        "Dual Flintlock";
        "Cannon";
        "Bizarre Revolver";
        "Bazooka";
    };

    ["Auto Active Race V4"] = true;
    ["FPS Limit"] = 15;
    ["Boost FPS"] = true;

    ["Hop Near"] = {
        Enabled = false;
        Distance = 500;
    };

    ["Webhook"] = {
        ["URL"] = "";
        ["Interval"] = 300;
    };
};

-- // Loader Core
local function Log(msg)
    print("[TechHub] " .. tostring(msg))
end

local function CheckKey(key)
    if key == "" or key == nil then
        Log("Khong co key - chay thu nghiem")
        return true
    end
    -- Thêm logic verify key ở đây nếu cần
    Log("Key hop le")
    return true
end

local function SetFPS(limit)
    if getgenv().TechHub["Boost FPS"] then
        settings().Rendering.QualityLevel = 1
        Log("Da giam chat luong do hoa")
    end
    if limit and limit > 0 then
        setfpscap(limit)
        Log("FPS gioi han: " .. limit)
    end
end

local function SendWebhook(content)
    local cfg = getgenv().TechHub["Webhook"]
    if cfg["URL"] == "" or cfg["URL"] == nil then return end
    local data = HttpService:JSONEncode({
        content = content;
        username = "TechHub | dj";
    })
    syn.request({
        Url = cfg["URL"];
        Method = "POST";
        Headers = {["Content-Type"] = "application/json"};
        Body = data;
    })
end

local function StartWebhookLoop()
    local cfg = getgenv().TechHub["Webhook"]
    if cfg["URL"] == "" then return end
    task.spawn(function()
        while task.wait(cfg["Interval"]) do
            local player = Players.LocalPlayer
            SendWebhook(
                "**TechHub Report**\n" ..
                "Player: " .. player.Name .. "\n" ..
                "Level: " .. tostring(player.Data and player.Data.Level or "N/A") .. "\n" ..
                "Time: " .. os.date("%H:%M:%S")
            )
        end
    end)
end

local function HopServer()
    local cfg = getgenv().TechHub["Hop Near"]
    if not cfg.Enabled then return end
    task.spawn(function()
        while task.wait(1) do
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= Players.LocalPlayer then
                    local char = v.Character
                    local local_char = Players.LocalPlayer.Character
                    if char and local_char then
                        local dist = (char.HumanoidRootPart.Position - local_char.HumanoidRootPart.Position).Magnitude
                        if dist <= cfg.Distance then
                            Log("Co nguoi gan - dang hop server...")
                            TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
                        end
                    end
                end
            end
        end
    end)
end

-- // Boot
local function Init()
    Log("Dang khoi dong TechHub...")

    if not CheckKey(getgenv().TechHub["Key"]) then
        Log("Key khong hop le - dung lai")
        return
    end

    SetFPS(getgenv().TechHub["FPS Limit"])
    StartWebhookLoop()
    HopServer()

    Log("TechHub da san sang!")
end

Init()
