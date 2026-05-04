local Plr = game:GetService("Players")
local TS = game:GetService("TweenService")
local LP = Plr.LocalPlayer

local Services = {
    Players = Plr,
    RunService = game:GetService("RunService"),
    TeleportService = game:GetService("TeleportService"),
    UserInputService = game:GetService("UserInputService"),
    Lighting = game:GetService("Lighting"),
    HttpService = game:GetService("HttpService"),
    TweenService = TS,
    VirtualInputManager = game:GetService("VirtualInputManager"),
    VirtualUser = game:GetService("VirtualUser"),
    GuiService = game:GetService("GuiService"),
    Stats = game:GetService("Stats"),
}

local math_random = math.random
local string_lower = string.lower
local string_sub = string.sub
local tick = tick
local task_wait = task.wait

local cachedPlayers = {}
local function updateCachedPlayers()
    cachedPlayers = {}
    for _, v in ipairs(Services.Players:GetPlayers()) do
        if v ~= LP then
            cachedPlayers[#cachedPlayers + 1] = v
        end
    end
end
updateCachedPlayers()
Services.Players.PlayerAdded:Connect(function(pl)
    if pl ~= LP then
        cachedPlayers[#cachedPlayers + 1] = pl
    end
end)
Services.Players.PlayerRemoving:Connect(function(pl)
    for i = #cachedPlayers, 1, -1 do
        if cachedPlayers[i] == pl then
            table.remove(cachedPlayers, i)
            break
        end
    end
end)
local N = Instance.new
local U2 = UDim2.new
local C3 = Color3.fromRGB
local V2 = Vector2.new

local gui = N("ScreenGui")
gui.Name = "NoNameLoader" gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true gui.Parent = game.CoreGui

local mf = N("Frame")
mf.Name = "MainFrame" mf.Size = U2(0,2,0,2)
mf.Position = U2(0.5,0,0.5,0) mf.AnchorPoint = V2(0.5,0.5)
mf.BackgroundColor3 = C3(10,10,10) mf.BorderSizePixel = 0 mf.Parent = gui
N("UICorner",mf).CornerRadius = UDim.new(0,16)

local stroke = N("UIStroke",mf)
stroke.Color = C3(40,40,40) stroke.Thickness = 1.2

local tb = N("Frame",mf)
tb.Size = U2(1,0,0,54) tb.Position = U2(0,0,0,0)
tb.BackgroundColor3 = C3(14,14,14) tb.BorderSizePixel = 0 tb.ZIndex = 2
N("UICorner",tb).CornerRadius = UDim.new(0,16)

local tbfix = N("Frame",tb)
tbfix.Size = U2(1,0,0,16) tbfix.Position = U2(0,0,1,-16)
tbfix.BackgroundColor3 = C3(14,14,14) tbfix.BorderSizePixel = 0 tbfix.ZIndex = 2

local title = N("TextLabel",tb)
title.Size = U2(0,200,1,0) title.Position = U2(0,18,0,0)
title.BackgroundTransparency = 1 title.Text = "no name"
title.Font = Enum.Font.GothamBold title.TextSize = 21
title.TextColor3 = C3(240,240,240) title.TextXAlignment = Enum.TextXAlignment.Left title.ZIndex = 3

local bframe = N("Frame",tb)
bframe.Size = U2(0,58,0,22) bframe.Position = U2(0,106,0.5,-11)
bframe.BackgroundColor3 = C3(40,0,0) bframe.BorderSizePixel = 0 bframe.ZIndex = 3
N("UICorner",bframe).CornerRadius = UDim.new(0,6)

local bstroke = N("UIStroke",bframe)
bstroke.Color = C3(200,0,0) bstroke.Thickness = 1

local blabel = N("TextLabel",bframe)
blabel.Size = U2(1,0,1,0) blabel.BackgroundTransparency = 1
blabel.Text = "loader" blabel.Font = Enum.Font.GothamBold
blabel.TextSize = 12 blabel.TextColor3 = C3(255,60,60)
blabel.TextXAlignment = Enum.TextXAlignment.Center blabel.ZIndex = 4

local avframe = N("Frame",tb)
avframe.Size = U2(0,34,0,34) avframe.Position = U2(1,-50,0.5,-17)
avframe.BackgroundColor3 = C3(22,22,22) avframe.BorderSizePixel = 0 avframe.ZIndex = 3
N("UICorner",avframe).CornerRadius = UDim.new(1,0)

local avstroke = N("UIStroke",avframe)
avstroke.Color = C3(55,55,55) avstroke.Thickness = 1.2

local avimg = N("ImageLabel",avframe)
avimg.Size = U2(1,0,1,0) avimg.BackgroundTransparency = 1
local ok, thumb = pcall(function()
    return Plr:GetUserThumbnailAsync(LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size48x48)
end)
avimg.Image = ok and thumb or ""
avimg.ZIndex = 4
N("UICorner",avimg).CornerRadius = UDim.new(1,0)

local cf = N("Frame",mf)
cf.Size = U2(1,0,1,-56) cf.Position = U2(0,0,0,56)
cf.BackgroundTransparency = 1 cf.ZIndex = 2

local hello = N("TextLabel",cf)
hello.Size = U2(1,-36,0,32) hello.Position = U2(0,18,0,20)
hello.BackgroundTransparency = 1 hello.Text = "Hello, "..(LP.DisplayName or LP.Name).."!"
hello.Font = Enum.Font.GothamBold hello.TextSize = 26
hello.TextColor3 = C3(245,245,245) hello.TextXAlignment = Enum.TextXAlignment.Center hello.ZIndex = 3

local sub = N("TextLabel",cf)
sub.Size = U2(1,-36,0,18) sub.Position = U2(0,18,0,54)
sub.BackgroundTransparency = 1 sub.Text = "preparing your experience"
sub.Font = Enum.Font.Gotham sub.TextSize = 14
sub.TextColor3 = C3(65,65,65) sub.TextXAlignment = Enum.TextXAlignment.Center sub.ZIndex = 3

local div = N("Frame",cf)
div.Size = U2(1,-36,0,1) div.Position = U2(0,18,0,82)
div.BackgroundColor3 = C3(22,22,22) div.BorderSizePixel = 0 div.ZIndex = 3

local status = N("TextLabel",cf)
status.Size = U2(1,-36,0,22) status.Position = U2(0,18,0,97)
status.BackgroundTransparency = 1 status.Text = ""
status.Font = Enum.Font.GothamMedium status.TextSize = 16
status.TextColor3 = C3(255,0,0) status.TextXAlignment = Enum.TextXAlignment.Center
status.TextTransparency = 1 status.ZIndex = 3

local skip = N("TextButton",cf)
skip.Size = U2(1,-36,0,28) skip.Position = U2(0,18,1,-58)
skip.BackgroundTransparency = 1 skip.Text = "skip loading"
skip.Font = Enum.Font.Gotham skip.TextSize = 14
skip.TextColor3 = C3(60,60,60) skip.TextXAlignment = Enum.TextXAlignment.Center
skip.TextTransparency = 1 skip.AutoButtonColor = false skip.ZIndex = 10

local pbg = N("Frame",cf)
pbg.Size = U2(1,-36,0,3) pbg.Position = U2(0,18,1,-26)
pbg.BackgroundColor3 = C3(22,22,22) pbg.BorderSizePixel = 0 pbg.ZIndex = 3
N("UICorner",pbg).CornerRadius = UDim.new(1,0)

local pfill = N("Frame",pbg)
pfill.Size = U2(0,0,1,0) pfill.Position = U2(0,0,0,0)
pfill.BackgroundColor3 = C3(255,0,0) pfill.BorderSizePixel = 0 pfill.ZIndex = 4
N("UICorner",pfill).CornerRadius = UDim.new(1,0)

local skipped = false
local DURATION = 4
local RED,GREEN = C3(255,0,0),C3(0,220,0)
local RBG,RST,RTX = C3(40,0,0),C3(200,0,0),C3(255,60,60)
local GBG,GST,GTX = C3(0,40,0),C3(0,200,0),C3(60,255,100)

local steps = {
	{text="setup hook",     color=RED,   time=0.5},
	{text="setup function", color=RED,   time=1.5},
	{text="almost done",    color=RED,   time=2.5},
	{text="done",           color=GREEN, time=3.5},
}

local function Tween(obj,props,dur,style,dir)
	local t = TS:Create(obj,TweenInfo.new(dur,style or Enum.EasingStyle.Quart,dir or Enum.EasingDirection.Out),props)
	t:Play() return t
end

local function SetAccentColor(color,isGreen)
	Tween(pfill,  {BackgroundColor3=color},0.4)
	Tween(stroke, {Color=isGreen and C3(0,200,0) or C3(200,0,0)},0.5)
	Tween(bframe, {BackgroundColor3=isGreen and GBG or RBG},0.5)
	Tween(bstroke,{Color=isGreen and GST or RST},0.5)
	Tween(blabel, {TextColor3=isGreen and GTX or RTX},0.5)
end

local function CloseLoader()
	Tween(status,{TextTransparency=1},0.2) Tween(skip,  {TextTransparency=1},0.2)
	Tween(hello, {TextTransparency=1},0.2) Tween(sub,   {TextTransparency=1},0.2)
	Tween(title, {TextTransparency=1},0.2) Tween(blabel,{TextTransparency=1},0.2)
	Tween(div,   {BackgroundTransparency=1},0.2) Tween(pbg,  {BackgroundTransparency=1},0.2)
	Tween(pfill, {BackgroundTransparency=1},0.2) Tween(avimg,{ImageTransparency=1},0.2)
	Tween(bframe,{BackgroundTransparency=1},0.2) Tween(stroke,{Transparency=1},0.2)
	task.wait(0.25)
	Tween(mf,{Size=U2(0,0,0,0)},0.35,Enum.EasingStyle.Quart,Enum.EasingDirection.In).Completed:Wait()
	gui:Destroy()
end

local loaderDone = false

local function OnSkip()
	if not skipped then skipped=true CloseLoader() loaderDone=true end
end

skip.MouseButton1Click:Connect(OnSkip)
skip.TouchTap:Connect(OnSkip)
skip.MouseEnter:Connect(function() Tween(skip,{TextColor3=C3(170,170,170)},0.2) end)
skip.MouseLeave:Connect(function() Tween(skip,{TextColor3=C3(60,60,60)},0.2) end)

task.spawn(function()
	Tween(mf,{Size=U2(0,500,0,300)},0.55,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
	task.wait(0.45)
	Tween(status,{TextTransparency=0},0.3) Tween(skip,{TextTransparency=0},0.3)
	task.wait(0.1)
	Tween(pfill,{Size=U2(1,0,1,0)},DURATION,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)

	local t0 = tick()
	for _,step in ipairs(steps) do
		if skipped then break end
		local rem = step.time-(tick()-t0)
		if rem > 0 then task.wait(rem) end
		if skipped then break end
		local isGreen = step.color==GREEN
		Tween(status,{TextTransparency=1},0.15)
		task.wait(0.15)
		if skipped then break end
		status.Text = step.text
		Tween(status,{TextTransparency=0,TextColor3=step.color},0.35)
		SetAccentColor(step.color,isGreen)
	end

	if not skipped then task.wait(0.5) CloseLoader() loaderDone=true end
end)

local function initLoader()

local Players = Services.Players
local p       = Players.LocalPlayer
local rs      = Services.RunService
local tps     = Services.TeleportService
local uis     = Services.UserInputService
local lighting= Services.Lighting
local hs      = Services.HttpService
local ts      = Services.TweenService
local cam     = workspace.CurrentCamera
local _active = {}
local function isActive(id) return _active[id] == true end
local function setActive(id) _active[id] = true end
local function clearActive(id) _active[id] = nil end
local _ctrls
local function getCtrls()
	if not _ctrls then _ctrls = require(p.PlayerScripts:WaitForChild("PlayerModule")):GetControls() end
	return _ctrls
end
local SpeedSettings = {Locked=false, Value=16, Original=16}
local JumpSettings  = {Locked=false, Value=50, Original=50}
local oldIndex, hookActive = nil, false
local function ensureHook()
	if hookActive then return end
	hookActive = true
	oldIndex = hookmetamethod(game, "__newindex", newcclosure(function(t, k, v)
		if not checkcaller() and typeof(t) == "Instance" and t:IsA("Humanoid") then
			if k == "WalkSpeed" and SpeedSettings.Locked then return oldIndex(t, k, SpeedSettings.Value) end
			if k == "JumpPower"  and JumpSettings.Locked  then return oldIndex(t, k, JumpSettings.Value)  end
		end
		return oldIndex(t, k, v)
	end))
end
local function tryRemoveHook()
	if not SpeedSettings.Locked and not JumpSettings.Locked and hookActive and oldIndex then
		hookmetamethod(game, "__newindex", oldIndex)
		oldIndex, hookActive = nil, false
	end
end
local conn = {}
local st = {
	hitboxConns={}, hitboxOrigSizes={},
	clickTpConns={}, espPlayerData={},
	neConns={}, avisConns={},
	invisVisibleParts={},
	isFlying=false, _flyHum=nil,
	bv=nil, bg=nil, spinBody=nil, spinSpeed=nil,
	origAmbient=nil, origOutdoor=nil, origBright=nil, origShadows=nil, fbActive=false,
	espFolder=nil, clickTpTool=nil,
	godHookIndex=nil, godHookNewIndex=nil,
	OldPos=nil, vwPart=nil, fcPart=nil,
	nfActive=false, origFog=nil, neHookOrig=nil,
	alGui=nil, alCircle=nil, akActive=false, akOrig=nil,
	saOld=nil, saGui=nil, saCircle=nil, invisActive=false, adminActive=false,
}
local saSettings = {Enabled=false, FOV=300, TargetPart="Head", Mode="fov"}
local AC = {active=false, target=Vector2.new(0,0), mode="Mobile", delay=0.3}
local hookSupported = type(hookmetamethod) == "function"
local NOTIF_URL = "https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/refs/heads/main/NamelessAdminNotifications.lua"
local NOTIF_PATH = "no name/notif.lua"
local UI_Notif
pcall(function()
	if type(writefile)=="function" then
		pcall(function()
			if not isfolder("no name") then makefolder("no name") end
			if not isfile(NOTIF_PATH) then writefile(NOTIF_PATH,game:HttpGet(NOTIF_URL)) end
		end)
		local ok,res=false,nil
		if type(loadfile)=="function" then
			ok,res=pcall(loadfile,NOTIF_PATH)
			if ok and type(res)=="function" then ok,UI_Notif=pcall(res) end
		end
		if not UI_Notif and type(readfile)=="function" then
			ok,UI_Notif=pcall(function() return loadstring(readfile(NOTIF_PATH))() end)
		end
	end
	if not UI_Notif then UI_Notif=loadstring(game:HttpGet(NOTIF_URL))() end
end)
local DC
local Cmds = {}
local Cmd = {}
function Cmd.add(aliases, opts)
	opts = opts or {}
	local entry = {aliases=aliases}
	for k,v in pairs(opts) do entry[k]=v end
	Cmds[#Cmds+1] = entry
end
local function safeClip(text)
	local ok=pcall(setclipboard,text)
	if not ok and UI_Notif then UI_Notif.Notify({Title="No Name",Content="setclipboard not supported by your executor",Duration=5}) end
end
local function getEspFolder()
	if not st.espFolder or not st.espFolder.Parent then
		st.espFolder = Instance.new("Folder", game.CoreGui); st.espFolder.Name = "NNGui_ESP"
	end
	return st.espFolder
end
 
local function resolveTargets(name)
    if name == "all" then
        return cachedPlayers
    end
    if name == "random" then
        local count = #cachedPlayers
        return (count > 0) and { cachedPlayers[math_random(count)] } or {}
    end
    local ln = string_lower(name)
    local nl = #name
    for _, v in ipairs(cachedPlayers) do
        local vNameLower = string_lower(v.Name)
        local vDisplayLower = string_lower(v.DisplayName)
        if string_sub(vNameLower, 1, nl) == ln or string_sub(vDisplayLower, 1, nl) == ln then
            return { v }
        end
    end
    return {}
end
local function getHum(char) return char and char:FindFirstChildOfClass("Humanoid") end
local function stopFly()
	clearActive("fly"); st.isFlying = false
	if conn.flyConn then conn.flyConn:Disconnect(); conn.flyConn = nil end
	if conn.flyCharConn then conn.flyCharConn:Disconnect(); conn.flyCharConn = nil end
	if st.bv then st.bv:Destroy(); st.bv = nil end
	if st.bg then st.bg:Destroy(); st.bg = nil end
	local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.PlatformStand = false end
end
local function setupFlyChar(char)
	if st.bv then st.bv:Destroy(); st.bv = nil end
	if st.bg then st.bg:Destroy(); st.bg = nil end
	local root = char:WaitForChild("HumanoidRootPart",10)
	local hum  = char:WaitForChild("Humanoid",10)
	if not (root and hum) then return end
	st._flyHum = hum
	st.bv = Instance.new("BodyVelocity",root); st.bv.MaxForce = Vector3.new(1e6,1e6,1e6)
	st.bg = Instance.new("BodyGyro",root);     st.bg.MaxTorque = Vector3.new(1e6,1e6,1e6); st.bg.P = 1e4
end
local flySpeed_val = 50
local function startFly(spd)
	if isActive("fly") then stopFly() end; setActive("fly")
	st.isFlying = true; flySpeed_val = spd or 50
	local char = p.Character or p.CharacterAdded:Wait()
	setupFlyChar(char)
	conn.flyCharConn = p.CharacterAdded:Connect(function(c) setupFlyChar(c) end)
	conn.flyConn = rs.RenderStepped:Connect(function()
		if not st.isFlying or not st.bv or not st.bv.Parent or not st._flyHum or not st._flyHum.Parent then return end
		local mv = getCtrls():GetMoveVector()
		local cf = cam.CFrame
		local vel = cf.RightVector*mv.X + cf.LookVector*-mv.Z
		st.bv.Velocity = vel.Magnitude>0 and vel.Unit*flySpeed_val or Vector3.zero
		st.bg.CFrame = cf; st._flyHum.PlatformStand = true
	end)
end
Cmd.add({"fly"}, {args="[speed]", fn=function(v) startFly(tonumber(v) or 50) end, hud="speed",hudDefault=50,hudStart="startFly",hudStop="stopFly",hudOn={"fly"},hudOff={"unfly"}})
Cmd.add({"unfly"}, {fn=stopFly})

local function startNoclip()
	if isActive("noclip") then return end; setActive("noclip")
	if conn.noclipConn then conn.noclipConn:Disconnect() end
	conn.noclipConn=rs.Stepped:Connect(function()
		local char=p.Character; if not char then return end
		for _,v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide=false end
		end
	end)
end
local function stopNoclip()
	clearActive("noclip")
	if conn.noclipConn then conn.noclipConn:Disconnect(); conn.noclipConn=nil end
end
Cmd.add({"noclip","nc"}, {fn=startNoclip})
Cmd.add({"unnoclip","unnc","clip"}, {fn=stopNoclip})

local function startLws(spd)
	if isActive("lws") then return end; setActive("lws")
	ensureHook(); SpeedSettings.Value, SpeedSettings.Locked = spd, true
	local function apply(char)
		local hum = getHum(char)
		if hum then
			if not SpeedSettings.Original or SpeedSettings.Original==spd then SpeedSettings.Original=16 end
			hum.WalkSpeed = spd
		end
	end
	if p.Character then apply(p.Character) end
	if conn.lockwsCharConn then conn.lockwsCharConn:Disconnect() end
	conn.lockwsCharConn = p.CharacterAdded:Connect(apply)
end
local function stopLws()
	clearActive("lws"); SpeedSettings.Locked = false
	if conn.lockwsCharConn then conn.lockwsCharConn:Disconnect(); conn.lockwsCharConn = nil end
	tryRemoveHook()
end
Cmd.add({"lockwalkspeed","lockws"}, {args="[speed]", fn=function(v) startLws(tonumber(v) or 16) end, hook=true})
Cmd.add({"unlockwalkspeed","unlockws"}, {fn=stopLws})

local function startLoopws(spd)
	if isActive("loopws") then return end; setActive("loopws")
	SpeedSettings.Locked = false
	if conn.lockwsCharConn  then conn.lockwsCharConn:Disconnect();  conn.lockwsCharConn  = nil end
	if conn.loopwsConn      then conn.loopwsConn:Disconnect();      conn.loopwsConn      = nil end
	if conn.loopwsCharConn  then conn.loopwsCharConn:Disconnect();  conn.loopwsCharConn  = nil end
	local _lwsChar, _lwsHum
	conn.loopwsCharConn = p.CharacterAdded:Connect(function(c) _lwsChar=c; _lwsHum=nil end)
	conn.loopwsConn = rs.Heartbeat:Connect(function()
		local char = p.Character
		if char~=_lwsChar then _lwsChar=char; _lwsHum=nil end
		if not _lwsHum or not _lwsHum.Parent then _lwsHum = char and char:FindFirstChildOfClass("Humanoid") end
		if _lwsHum and _lwsHum.WalkSpeed~=spd then _lwsHum.WalkSpeed=spd end
	end)
end
local function stopLoopws()
	clearActive("loopws")
	if conn.loopwsConn     then conn.loopwsConn:Disconnect();     conn.loopwsConn     = nil end
	if conn.loopwsCharConn then conn.loopwsCharConn:Disconnect(); conn.loopwsCharConn = nil end
end
Cmd.add({"loopwalkspeed","loopws","lws"}, {args="[speed]", fn=function(v) startLoopws(tonumber(v) or 16) end})
Cmd.add({"unloopwalkspeed","unloopws","unlws"}, {fn=stopLoopws})

local function setWs(spd) local hum=getHum(p.Character); if hum then hum.WalkSpeed=spd end end
Cmd.add({"walkspeed","speed","ws"}, {args="[speed]", fn=function(v) setWs(tonumber(v) or 16) end})

local function startLjp(pw)
	if isActive("ljp") then return end; setActive("ljp")
	ensureHook(); JumpSettings.Value, JumpSettings.Locked, JumpSettings.OriginalUseJumpPower = pw, true, false
	local function apply(char)
		local hum=getHum(char); if hum then hum.UseJumpPower=true; hum.JumpPower=pw end
	end
	if p.Character then apply(p.Character) end
	if conn.lockjpCharConn then conn.lockjpCharConn:Disconnect() end
	conn.lockjpCharConn = p.CharacterAdded:Connect(apply)
end
local function stopLjp()
	clearActive("ljp"); JumpSettings.Locked = false
	if conn.lockjpCharConn then conn.lockjpCharConn:Disconnect(); conn.lockjpCharConn = nil end
	tryRemoveHook()
	local hum=getHum(p.Character); if hum then hum.UseJumpPower = JumpSettings.OriginalUseJumpPower or false end
end
Cmd.add({"lockjumppower","lockjp","ljp"}, {args="[power]", fn=function(v) startLjp(tonumber(v) or 50) end, hook=true})
Cmd.add({"unlockjumppower","unlockjp","unljp"}, {fn=stopLjp})

local function setJp(pw) local hum=getHum(p.Character); if hum then hum.UseJumpPower=true; hum.JumpPower=pw end end
Cmd.add({"jumppower","jp"}, {args="[power]", fn=function(v) setJp(tonumber(v) or 50) end})

local function gotoPlayer(name, y, z)
	local root = p.Character and p.Character:FindFirstChild("HumanoidRootPart"); if not root then return end
	if tonumber(name) and tonumber(y) and tonumber(z) then root.CFrame=CFrame.new(tonumber(name),tonumber(y),tonumber(z)); return end
	local target=resolveTargets(name)[1]
	local tRoot=target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	if tRoot then root.CFrame=tRoot.CFrame end
end
Cmd.add({"goto","tp"}, {args="[player/x] [y] [z]", fn=function(v,v2,v3) if v then gotoPlayer(v,v2,v3) end end})
Cmd.add({"fov"}, {args="[value]", fn=function(v) cam.FieldOfView=tonumber(v) or 70 end})
Cmd.add({"maxzoom"}, {args="[value]", fn=function(v) p.CameraMaxZoomDistance=tonumber(v) or 400 end})
Cmd.add({"rejoin","rj"}, {fn=function() tps:TeleportToPlaceInstance(game.PlaceId,game.JobId,p) end})

local function applySpinToChar(char)
	if st.spinBody then st.spinBody:Destroy(); st.spinBody=nil end
	local root=char:FindFirstChild("HumanoidRootPart")
	if root then
		st.spinBody=Instance.new("BodyAngularVelocity",root)
		st.spinBody.MaxTorque=Vector3.new(0,math.huge,0); st.spinBody.AngularVelocity=Vector3.new(0,st.spinSpeed,0)
	end
end
local function startSpin(speed)
	if isActive("spin") then return end; setActive("spin"); st.spinSpeed=speed
	if conn.spinConn then conn.spinConn:Disconnect() end
	if p.Character then applySpinToChar(p.Character) end
	conn.spinConn = p.CharacterAdded:Connect(applySpinToChar)
end
local function stopSpin()
	clearActive("spin")
	if st.spinBody then st.spinBody:Destroy(); st.spinBody=nil end
	if conn.spinConn then conn.spinConn:Disconnect(); conn.spinConn=nil end
end
Cmd.add({"spin"}, {args="[speed]", fn=function(v) startSpin(tonumber(v) or 50) end})
Cmd.add({"unspin"}, {fn=stopSpin})

local function startInfJump()
	if isActive("infjump") then return end; setActive("infjump")
	if conn.ijConn then conn.ijConn:Disconnect() end
	conn.ijConn = uis.JumpRequest:Connect(function()
		local hum=getHum(p.Character); if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end)
end
local function stopInfJump() clearActive("infjump"); if conn.ijConn then conn.ijConn:Disconnect(); conn.ijConn=nil end end
Cmd.add({"infjump","infinitejump"}, {fn=startInfJump})
Cmd.add({"uninfjump"}, {fn=stopInfJump})

local function startFullbright()
	if isActive("fullbright") then return end; setActive("fullbright")
	if not st.fbActive then st.origAmbient,st.origOutdoor,st.origBright,st.origShadows=lighting.Ambient,lighting.OutdoorAmbient,lighting.Brightness,lighting.GlobalShadows; st.fbActive=true end
	lighting.Ambient=Color3.new(1,1,1); lighting.OutdoorAmbient=Color3.new(1,1,1)
	lighting.Brightness=2; lighting.GlobalShadows=false; lighting.FogEnd=100000
end
local function stopFullbright()
	clearActive("fullbright"); if not st.fbActive then return end; st.fbActive=false
	lighting.Ambient,lighting.OutdoorAmbient,lighting.Brightness,lighting.GlobalShadows=st.origAmbient,st.origOutdoor,st.origBright,st.origShadows
end
Cmd.add({"fullbright","fb"}, {fn=startFullbright})
Cmd.add({"unfullbright","unfb"}, {fn=stopFullbright})

local function detachEspPlayer(target)
	local data=st.espPlayerData[target]; if not data then return end
	for _,c in ipairs(data.conns) do c:Disconnect() end
	for _,obj in ipairs(data.items) do if obj and obj.Parent then obj:Destroy() end end
	st.espPlayerData[target]=nil
end
local function stopEsp()
	clearActive("esp")
	if conn.espGlobalConn then conn.espGlobalConn:Disconnect(); conn.espGlobalConn=nil end
	if conn.espRemoveConn then conn.espRemoveConn:Disconnect(); conn.espRemoveConn=nil end
	for target in pairs(st.espPlayerData) do detachEspPlayer(target) end
	getEspFolder():ClearAllChildren()
end
local function attachEsp(target)
	detachEspPlayer(target)
	local data={conns={},items={}}; st.espPlayerData[target]=data
	local function getLabel()
		return target.DisplayName~=target.Name and target.DisplayName.."\n@"..target.Name or target.Name
	end
	local function clearItems()
		for _,obj in ipairs(data.items) do if obj and obj.Parent then obj:Destroy() end end; data.items={}
	end
	local function createESP(char)
		if not char then return end; clearItems()
		local hrp=char:FindFirstChild("HumanoidRootPart")
		if hrp then
			local bgUI=Instance.new("BillboardGui",getEspFolder())
			bgUI.Size=UDim2.new(0,200,0,44); bgUI.StudsOffset=Vector3.new(0,3,0); bgUI.AlwaysOnTop=true; bgUI.Adornee=hrp
			data.items[#data.items+1]=bgUI
			local txt=Instance.new("TextLabel",bgUI)
			txt.Size=UDim2.new(1,0,1,0); txt.BackgroundTransparency=1; txt.TextColor3=Color3.fromRGB(0,255,255)
			txt.TextStrokeTransparency=0; txt.Font=Enum.Font.GothamBold; txt.TextSize=13; txt.Text=getLabel()
			data.conns[#data.conns+1]=target:GetPropertyChangedSignal("DisplayName"):Connect(function() txt.Text=getLabel() end)
		else
			local hrpConn
			hrpConn=char.DescendantAdded:Connect(function(d)
				if d.Name=="HumanoidRootPart" and d:IsA("BasePart") then hrpConn:Disconnect(); createESP(char) end
			end)
			data.conns[#data.conns+1]=hrpConn
		end
	end
	if target.Character then createESP(target.Character) end
	data.conns[#data.conns+1]=target.CharacterAdded:Connect(createESP)
end
local function startEsp(name)
	local targets=resolveTargets(name)
	if #targets==0 then return end
	stopEsp()
	setActive("esp")
	for _,v in ipairs(targets) do attachEsp(v) end
	if name=="all" then conn.espGlobalConn=Players.PlayerAdded:Connect(attachEsp) end
	conn.espRemoveConn=Players.PlayerRemoving:Connect(detachEspPlayer)
end
Cmd.add({"esp"}, {args="[player/all]", fn=function(v) if v then startEsp(v) end end})
Cmd.add({"unesp"}, {fn=stopEsp})

local function startFling(name)
	if not name then return end
	local targets=resolveTargets(name); if #targets==0 then return end
local targetPlayer=targets[math_random(#targets)]
	local Character=p.Character
	local Humanoid=Character and Character:FindFirstChildOfClass("Humanoid")
	local RootPart=Humanoid and Humanoid.RootPart
	local TCharacter=targetPlayer.Character
	local THumanoid=TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
	local TRootPart=THumanoid and THumanoid.RootPart
	local THead=TCharacter and TCharacter:FindFirstChild("Head")
	local Accessory=TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
	local Handle=Accessory and Accessory:FindFirstChild("Handle")
	if not (Character and Humanoid and RootPart) then return end
	if RootPart.Velocity.Magnitude<50 then st.OldPos=RootPart.CFrame end
	if THumanoid and THumanoid.Sit then return end
	if THead then cam.CameraSubject=THead elseif Handle then cam.CameraSubject=Handle else cam.CameraSubject=THumanoid end
	if not TCharacter or not TCharacter:FindFirstChildWhichIsA("BasePart") then return end
	local function FPos(BasePart,Pos,Ang)
		RootPart.CFrame=CFrame.new(BasePart.Position)*Pos*Ang
		Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position)*Pos*Ang)
		RootPart.Velocity=Vector3.new(9e7,9e7*10,9e7); RootPart.RotVelocity=Vector3.new(9e8,9e8,9e8)
	end
	local function SFBasePart(BasePart)
		local Time=tick(); local Angle=0
		repeat
			if RootPart and THumanoid then
				if BasePart.Velocity.Magnitude<50 then
					Angle=Angle+100
					FPos(BasePart,CFrame.new(0,1.5,0)+THumanoid.MoveDirection*BasePart.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(Angle),0,0));task.wait()
					FPos(BasePart,CFrame.new(0,-1.5,0)+THumanoid.MoveDirection*BasePart.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(Angle),0,0));task.wait()
					FPos(BasePart,CFrame.new(2.25,1.5,-2.25)+THumanoid.MoveDirection*BasePart.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(Angle),0,0));task.wait()
					FPos(BasePart,CFrame.new(-2.25,-1.5,2.25)+THumanoid.MoveDirection*BasePart.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(Angle),0,0));task.wait()
					FPos(BasePart,CFrame.new(0,1.5,0)+THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle),0,0));task.wait()
					FPos(BasePart,CFrame.new(0,-1.5,0)+THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle),0,0));task.wait()
				else
					FPos(BasePart,CFrame.new(0,1.5,THumanoid.WalkSpeed),CFrame.Angles(math.rad(90),0,0));task.wait()
					FPos(BasePart,CFrame.new(0,-1.5,-THumanoid.WalkSpeed),CFrame.Angles(0,0,0));task.wait()
					FPos(BasePart,CFrame.new(0,1.5,THumanoid.WalkSpeed),CFrame.Angles(math.rad(90),0,0));task.wait()
					FPos(BasePart,CFrame.new(0,1.5,TRootPart.Velocity.Magnitude/1.25),CFrame.Angles(math.rad(90),0,0));task.wait()
					FPos(BasePart,CFrame.new(0,-1.5,-TRootPart.Velocity.Magnitude/1.25),CFrame.Angles(0,0,0));task.wait()
					FPos(BasePart,CFrame.new(0,1.5,TRootPart.Velocity.Magnitude/1.25),CFrame.Angles(math.rad(90),0,0));task.wait()
					FPos(BasePart,CFrame.new(0,-1.5,0),CFrame.Angles(math.rad(90),0,0));task.wait()
					FPos(BasePart,CFrame.new(0,-1.5,0),CFrame.Angles(0,0,0));task.wait()
					FPos(BasePart,CFrame.new(0,-1.5,0),CFrame.Angles(math.rad(-90),0,0));task.wait()
					FPos(BasePart,CFrame.new(0,-1.5,0),CFrame.Angles(0,0,0));task.wait()
				end
			else break end
		until BasePart.Velocity.Magnitude>500 or BasePart.Parent~=targetPlayer.Character or targetPlayer.Parent~=Players or THumanoid.Sit or Humanoid.Health<=0 or tick()>Time+2
	end
	local BV=Instance.new("BodyVelocity",RootPart)
	BV.Name="EpixVel"; BV.Velocity=Vector3.new(9e8,9e8,9e8); BV.MaxForce=Vector3.new(1/0,1/0,1/0)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
	if TRootPart and THead then
		if (TRootPart.CFrame.p-THead.CFrame.p).Magnitude>5 then SFBasePart(THead) else SFBasePart(TRootPart) end
	elseif TRootPart and not THead then SFBasePart(TRootPart)
	elseif not TRootPart and THead then SFBasePart(THead)
	elseif Accessory and Handle then SFBasePart(Handle)
	else BV:Destroy(); Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true); cam.CameraSubject=Humanoid; return end
	BV:Destroy(); Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true); cam.CameraSubject=Humanoid
	if st.OldPos then
		repeat
			RootPart.CFrame=st.OldPos*CFrame.new(0,0.5,0)
			Character:SetPrimaryPartCFrame(st.OldPos*CFrame.new(0,0.5,0))
			Humanoid:ChangeState("GettingUp")
			for _,x in ipairs(Character:GetChildren()) do if x:IsA("BasePart") then x.Velocity=Vector3.new(); x.RotVelocity=Vector3.new() end end
			task.wait()
		until (RootPart.Position-st.OldPos.p).Magnitude<25
	end
end
Cmd.add({"fling"}, {args="[player]", fn=function(v) if v then startFling(v) end end})

local function copyPos()
	local root=p.Character and p.Character:FindFirstChild("HumanoidRootPart"); if not root then return end
	local pos=root.Position; safeClip(math.floor(pos.X)..", "..math.floor(pos.Y)..", "..math.floor(pos.Z))
end
Cmd.add({"copypos","cpos"}, {fn=copyPos})

local function respawn() local hum=getHum(p.Character); if hum then hum.Health=0 end end
Cmd.add({"respawn","reset"}, {fn=respawn})

local function stopClickTp()
	clearActive("clicktp")
	if st.clickTpTool then st.clickTpTool:Destroy(); st.clickTpTool=nil end
	for _,c in ipairs(st.clickTpConns) do c:Disconnect() end; st.clickTpConns={}
end
local function startClickTp()
	stopClickTp()
	setActive("clicktp")
	local tool=Instance.new("Tool",p.Backpack)
	tool.Name="ClickTP"; tool.RequiresHandle=false; tool.ToolTip="Click/Tap to teleport"; st.clickTpTool=tool
	local function doRaycastTp(screenPos)
		local char=p.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if not root then return end
		local ray=cam:ScreenPointToRay(screenPos.X,screenPos.Y)
		local params=RaycastParams.new(); params.FilterDescendantsInstances={char}; params.FilterType=Enum.RaycastFilterType.Exclude
		local result=workspace:Raycast(ray.Origin,ray.Direction*1000,params)
		if result then root.CFrame=CFrame.new(result.Position+result.Normal*2.5) end
	end
	local equipped,lastTouchPos=false,nil
	local isMobile=uis.TouchEnabled and not uis.KeyboardEnabled
	st.clickTpConns[#st.clickTpConns+1]=tool.Equipped:Connect(function() equipped=true end)
	st.clickTpConns[#st.clickTpConns+1]=tool.Unequipped:Connect(function() equipped=false; lastTouchPos=nil end)
	if isMobile then
		st.clickTpConns[#st.clickTpConns+1]=uis.TouchStarted:Connect(function(input) if equipped then lastTouchPos=Vector2.new(input.Position.X,input.Position.Y) end end)
		st.clickTpConns[#st.clickTpConns+1]=tool.Activated:Connect(function() if lastTouchPos then doRaycastTp(lastTouchPos); lastTouchPos=nil end end)
	else
		st.clickTpConns[#st.clickTpConns+1]=tool.Activated:Connect(function() doRaycastTp(uis:GetMouseLocation()) end)
	end
	st.clickTpConns[#st.clickTpConns+1]=tool.AncestryChanged:Connect(function() if not tool.Parent then stopClickTp() end end)
end
Cmd.add({"clicktp","ctp"}, {fn=startClickTp})
Cmd.add({"unclicktp","uctp"}, {fn=stopClickTp})

local function stopGodAll()
	clearActive("god")
	if conn.godmodeConn   then conn.godmodeConn:Disconnect();   conn.godmodeConn=nil end
	if conn.godHealthConn then conn.godHealthConn:Disconnect(); conn.godHealthConn=nil end
	if st.godHookIndex    then hookmetamethod(game,"__index",   st.godHookIndex);    st.godHookIndex=nil end
	if st.godHookNewIndex then hookmetamethod(game,"__newindex",st.godHookNewIndex); st.godHookNewIndex=nil end
end
local function activateGod(mode)
	stopGodAll()
	setActive("god")
	if mode=="nohook" then
		local function applyGod(char)
			local hum=char:WaitForChild("Humanoid",5); if not hum then return end
			hum.MaxHealth,hum.Health=math.huge,math.huge
			if conn.godHealthConn then conn.godHealthConn:Disconnect() end
			conn.godHealthConn=hum.HealthChanged:Connect(function() hum.Health=math.huge end)
		end
		if p.Character then applyGod(p.Character) end
		conn.godmodeConn=p.CharacterAdded:Connect(applyGod)
	else
		st.godHookIndex=hookmetamethod(game,"__index",newcclosure(function(self,key)
			if not checkcaller() and self:IsA("Humanoid") and (key=="Health" or key=="MaxHealth") then
				if p.Character and self:IsDescendantOf(p.Character) then return math.huge end
			end
			return st.godHookIndex(self,key)
		end))
		st.godHookNewIndex=hookmetamethod(game,"__newindex",newcclosure(function(self,key,value)
			if not checkcaller() and self:IsA("Humanoid") and key=="Health" then
				if p.Character and self:IsDescendantOf(p.Character) then return st.godHookNewIndex(self,key,math.huge) end
			end
			return st.godHookNewIndex(self,key,value)
		end))
	end
end
Cmd.add({"godmode","god"}, {picker={
	title="GODMODE",subtitle="Select godmode method",stopAlias="ungodmode",
	buttons={
		{label="NO HOOK",  sub="HealthChanged-based", accent=Color3.fromRGB(0,170,255), value="nohook"},
		{label="WITH HOOK",sub="hookmetamethod-based",accent=Color3.fromRGB(160,80,255),value="hook"},
	},
	onPick=activateGod,stopFn=stopGodAll,hookOnValue="hook",
}})
Cmd.add({"ungodmode","ungod"}, {fn=stopGodAll})

local function stopVw()
	clearActive("vw")
	if conn.vwConn       then conn.vwConn:Disconnect();       conn.vwConn=nil end
	if conn.vwRemoveConn then conn.vwRemoveConn:Disconnect(); conn.vwRemoveConn=nil end
	if conn.vwCharConn   then conn.vwCharConn:Disconnect();   conn.vwCharConn=nil end
	if st.vwPart       then st.vwPart:Destroy();          st.vwPart=nil end
	cam.CameraType=Enum.CameraType.Custom
	local char=p.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
	if hum then cam.CameraSubject=hum end
	local root=char and char:FindFirstChild("HumanoidRootPart"); if root then root.Anchored=false end
end
local function startVw(name)
	local target=resolveTargets(name)[1]; if not target then return end
	stopVw()
	setActive("vw")
	local part=Instance.new("Part"); part.Anchored,part.CanCollide,part.Transparency,part.Size=true,false,1,Vector3.new(1,1,1)
	part.Parent=workspace; st.vwPart=part; cam.CameraSubject,cam.CameraType=part,Enum.CameraType.Custom
	local root=p.Character and p.Character:FindFirstChild("HumanoidRootPart"); if root then root.Anchored=true end
	conn.vwCharConn=p.CharacterAdded:Connect(function(c) local r=c:WaitForChild("HumanoidRootPart",5); if r then r.Anchored=true end end)
	conn.vwConn=rs.Heartbeat:Connect(function()
		if not st.vwPart or not st.vwPart.Parent then return end
		local tr=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
		if tr then st.vwPart.CFrame=tr.CFrame end
	end)
	conn.vwRemoveConn=Players.PlayerRemoving:Connect(function(pl) if pl==target then stopVw() end end)
end
Cmd.add({"view","watch"}, {args="[player]", fn=function(v) if v then startVw(v) else stopVw() end end})
Cmd.add({"unview","unwatch"}, {fn=stopVw})

local function stopFc()
	clearActive("fc")
	if conn.fcConn     then conn.fcConn:Disconnect();     conn.fcConn=nil end
	if conn.fcCharConn then conn.fcCharConn:Disconnect(); conn.fcCharConn=nil end
	if st.fcPart     then st.fcPart:Destroy();        st.fcPart=nil end
	cam.CameraType=Enum.CameraType.Custom
	local char=p.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
	if hum then cam.CameraSubject=hum end
	local root=char and char:FindFirstChild("HumanoidRootPart"); if root then root.Anchored=false end
end
local function startFc(spd)
	stopFc()
	setActive("fc")
	local speed=spd or 50
	local part=Instance.new("Part"); part.Anchored,part.CanCollide,part.Transparency,part.CFrame=true,false,1,cam.CFrame
	part.Parent=workspace; st.fcPart=part; cam.CameraSubject=part
	local root=p.Character and p.Character:FindFirstChild("HumanoidRootPart"); if root then root.Anchored=true end
	local ctrls=getCtrls()
	conn.fcConn=rs.RenderStepped:Connect(function()
		local mv=ctrls:GetMoveVector()
		local move=(cam.CFrame.LookVector*-mv.Z)+(cam.CFrame.RightVector*mv.X)
		if move.Magnitude>0 then part.CFrame=part.CFrame+(move*(speed*0.06)) end
	end)
	conn.fcCharConn=p.CharacterAdded:Connect(function(c) local r=c:WaitForChild("HumanoidRootPart",5); if r then r.Anchored=true end end)
end
Cmd.add({"freecam","fc"}, {args="[speed]", fn=function(v) startFc(tonumber(v)) end, hud="speed",hudDefault=50,hudStart="startFc",hudStop="stopFc",hudOn={"freecam","fc"},hudOff={"unfreecam","unfc"}})
Cmd.add({"unfreecam","unfc"}, {fn=stopFc})

local function startNf()
	if isActive("nf") then return end; setActive("nf")
	if not st.nfActive then st.origFog,st.nfActive=lighting.FogEnd,true end
	lighting.FogEnd=1e9
	if conn.nfConn then conn.nfConn:Disconnect() end
	conn.nfConn=lighting:GetPropertyChangedSignal("FogEnd"):Connect(function() if st.nfActive and lighting.FogEnd<1e9 then lighting.FogEnd=1e9 end end)
end
local function stopNf()
	clearActive("nf"); if not st.nfActive then return end; st.nfActive=false
	if conn.nfConn then conn.nfConn:Disconnect(); conn.nfConn=nil end; lighting.FogEnd=st.origFog
end
Cmd.add({"nofog"}, {fn=startNf})
Cmd.add({"unnofog"}, {fn=stopNf})

local function stopAfl()
	clearActive("afl")
	if conn.antiflingConn then conn.antiflingConn:Disconnect(); conn.antiflingConn=nil end
end
local function startAfl()
	stopAfl()
	setActive("afl")
	conn.antiflingConn=rs.Stepped:Connect(function()
		for _,pl in ipairs(Players:GetPlayers()) do
			if pl~=p then
				local char=pl.Character; if not char then continue end
				for _,part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide=false end
				end
			end
		end
	end)
end
Cmd.add({"antifling"}, {fn=startAfl})
Cmd.add({"unantifling"}, {fn=stopAfl})

local function stopFrz()
	clearActive("frz"); if conn.frzConn then conn.frzConn:Disconnect(); conn.frzConn=nil end
	local char=p.Character; if char then for _,v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then v.Anchored=false end end end
end
local function startFrz()
	stopFrz()
	setActive("frz")
	local function applyFreeze(char) for _,v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then v.Anchored=true end end end
	local char=p.Character or p.CharacterAdded:Wait(); applyFreeze(char)
	conn.frzConn=p.CharacterAdded:Connect(applyFreeze)
end
Cmd.add({"freeze"}, {fn=startFrz, hud="toggle",hudStart="startFrz",hudStop="stopFrz",hudOn={"freeze"},hudOff={"unfreeze"}})
Cmd.add({"unfreeze"}, {fn=stopFrz})

local function startAk()
	if st.akActive then return end; st.akActive=true
	st.akOrig=hookmetamethod(game,"__namecall",newcclosure(function(s,...)
		if tostring(getnamecallmethod())=="Kick" then task.wait(9e9); return end
		return st.akOrig(s,...)
	end))
end
local function stopAk()
	if not st.akActive then return end
	hookmetamethod(game,"__namecall",st.akOrig); st.akOrig,st.akActive=nil,false
end
Cmd.add({"antikick"}, {fn=startAk, hook=true})
Cmd.add({"unantikick"}, {fn=stopAk})

local function serverhop()
	local placeId,curJob,servers,cursor=game.PlaceId,game.JobId,{},""
	repeat
		local url="https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
		if cursor~="" then url=url.."&cursor="..cursor end
		local ok,res=pcall(function() return game:HttpGet(url) end); if not ok then break end
		local data=hs:JSONDecode(res); if not data or not data.data then break end
		for _,s in ipairs(data.data) do if s.id~=curJob and s.playing<s.maxPlayers then servers[#servers+1]=s end end
		cursor=data.nextPageCursor or ""
	until cursor==""
    if #servers==0 then return end; tps:TeleportToPlaceInstance(placeId,servers[math_random(#servers)].id,p)
end
local function sshop_fn()
	local placeId,curJob,cursor,best=game.PlaceId,game.JobId,"",nil
	repeat
		local url="https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
		if cursor~="" then url=url.."&cursor="..cursor end
		local ok,res=pcall(function() return game:HttpGet(url) end); if not ok then break end
		local data=hs:JSONDecode(res); if not data or not data.data then break end
		for _,s in ipairs(data.data) do if s.id~=curJob and s.playing<s.maxPlayers then if not best or s.playing<best.playing then best=s end end end
		cursor=data.nextPageCursor or ""
	until cursor=="" or (best and best.playing<=1)
	if not best then return end; tps:TeleportToPlaceInstance(placeId,best.id,p)
end
Cmd.add({"serverhop","shop"}, {fn=function() task.spawn(serverhop) end})
Cmd.add({"smallserverhop","sshop"}, {fn=function() task.spawn(sshop_fn) end})

local function stopAl()
	clearActive("al"); rs:UnbindFromRenderStep("NNAimlock")
	if conn.alHB      then conn.alHB:Disconnect();      conn.alHB=nil end
	if conn.alPac     then conn.alPac:Disconnect();     conn.alPac=nil end
	if conn.alPrc     then conn.alPrc:Disconnect();     conn.alPrc=nil end
	if conn.alWsConn  then conn.alWsConn:Disconnect();  conn.alWsConn=nil end
	if st.alGui       then st.alGui:Destroy();          st.alGui=nil end
	if st.alCircle    then st.alCircle:Remove();        st.alCircle=nil end
end
local function startAl(fov)
	stopAl(); setActive("al")
	local F=fov or 180; local F2=F*F; local A=0.1
	local Sq=math.sqrt; local UP=Vector3.new(0,1,0)
	local C2=cam; local UIS2=Services.UserInputService
	
	local circle=Drawing.new("Circle")
	circle.Thickness=2; circle.Color=Color3.fromRGB(0,220,80)
	circle.Filled=false; circle.Visible=true; circle.Radius=F
	st.alCircle=circle
	
	local T={}
	local function trackChar(c)
		local r=c:FindFirstChild("HumanoidRootPart"); if r then T[c]=r end
		c.ChildAdded:Connect(function(v2) if v2.Name=="HumanoidRootPart" then T[c]=v2 end end)
		c.AncestryChanged:Connect(function(_,par) if not par then T[c]=nil end end)
	end
	local function trackPlayer(pl)
		if pl~=p then
			if pl.Character then trackChar(pl.Character) end
			pl.CharacterAdded:Connect(trackChar)
			pl.CharacterRemoving:Connect(function(c) T[c]=nil end)
		end
	end
	for _,pl in Players:GetPlayers() do trackPlayer(pl) end
	conn.alPac=Players.PlayerAdded:Connect(trackPlayer)
	conn.alPrc=Players.PlayerRemoving:Connect(function(pl) if pl.Character then T[pl.Character]=nil end end)
	for _,m in workspace:GetChildren() do
		if m:IsA("Model") and m~=p.Character and m:FindFirstChildWhichIsA("Humanoid") and not T[m] then trackChar(m) end
	end
	conn.alWsConn=workspace.ChildAdded:Connect(function(m)
		task.defer(function()
			if m:IsA("Model") and m~=p.Character and m:FindFirstChildWhichIsA("Humanoid") and not T[m] then trackChar(m) end
		end)
	end)
	
	local rpAl=RaycastParams.new(); rpAl.FilterType=Enum.RaycastFilterType.Exclude
	local function wallCheck(hrp)
		if not p.Character or not hrp then return false end
		local excl={p.Character,hrp.Parent}
		for _,v2 in ipairs(Players:GetPlayers()) do
			if v2~=p and v2.Character and v2.Character~=hrp.Parent then excl[#excl+1]=v2.Character end
		end
		rpAl.FilterDescendantsInstances=excl
		local orig=C2.CFrame.Position; local dir=hrp.Position-orig
		return not workspace:Raycast(orig,dir,rpAl)
	end
	
	local function findBest()
		local mp=UIS2:GetMouseLocation(); local mx,my=mp.X,mp.Y
		local best,bestD=nil,math.huge
		for m,hrp in pairs(T) do
			local hum=m:FindFirstChild("Humanoid")
			if hrp and hrp.Parent==m and hum and hum.Health>0 then
				local sp,onScreen=C2:WorldToViewportPoint(hrp.Position)
				if onScreen then
					local dx,dy=sp.X-mx,sp.Y-my; local d2=dx*dx+dy*dy
					if d2<F2 and d2<bestD and wallCheck(hrp) then best,bestD=hrp,d2 end
				end
			end
		end
		return best
	end
	
	local function predict(hrp)
		local camPos=C2.CFrame.Position; local d=hrp.Position-camPos
		local dMag2=d:Dot(d); if dMag2<1e-6 then return hrp.Position end
		local dUnit=d/Sq(dMag2); local right=dUnit:Cross(UP)
		local rMag2=right:Dot(right); if rMag2<1e-6 then return hrp.Position end
		right=right/Sq(rMag2)
		return hrp.Position+right*hrp.AssemblyLinearVelocity:Dot(right)*A
	end
	local target=nil
	conn.alHB=rs.Heartbeat:Connect(function()
		if not target or not target.Parent then target=findBest() end
	end)
	rs:BindToRenderStep("NNAimlock",10000,function()
		local mp=UIS2:GetMouseLocation(); circle.Position=Vector2.new(mp.X,mp.Y)
		if target and target.Parent then
			local hum=target.Parent:FindFirstChild("Humanoid")
			local sp,onScreen=C2:WorldToViewportPoint(target.Position)
			local mp2=UIS2:GetMouseLocation(); local dx,dy=sp.X-mp2.X,sp.Y-mp2.Y
			if hum and hum.Health>0 and onScreen and dx*dx+dy*dy<=F2 and wallCheck(target) then
				C2.CFrame=CFrame.lookAt(C2.CFrame.Position,predict(target))
			else
				target=nil
			end
		end
	end)
end
Cmd.add({"aimlock"}, {args="[fov]", fn=function(v) startAl(tonumber(v)) end})
Cmd.add({"unaimlock"}, {fn=stopAl})

local function stopNoEffect()
	clearActive("ne")
	for _,c in ipairs(st.neConns) do c:Disconnect() end;st.neConns={}
	if st.neHookOrig then hookmetamethod(game,"__newindex",st.neHookOrig); st.neHookOrig=nil end
end
local processed=setmetatable({},{__mode="k"})
local function activateNoEffect(mode)
	if isActive("ne") then return end;setActive("ne");stopNoEffect()
	task.spawn(function()
		repeat task.wait() until game:IsLoaded()
		local w,l=workspace,Services.Lighting
		l.GlobalShadows=false;l.FogEnd=1e9;l.EnvironmentDiffuseScale=0;l.EnvironmentSpecularScale=0;l.Technology=Enum.Technology.Compatibility
		local function k(o)
			if o:IsA("Sky")then o.SkyboxBk=""o.SkyboxDn=""o.SkyboxFt=""o.SkyboxLf=""o.SkyboxRt=""o.SkyboxUp=""end
			if o:IsA("Decal")then o.Transparency=1;o.Texture=""end
			if o:IsA("Texture")then o.Transparency=1;o.Texture=""o.StudsPerTileU=0;o.StudsPerTileV=0 end
			if o:IsA("MeshPart")then o.TextureID=""
			elseif o:IsA("SpecialMesh")then o.TextureId=""
			elseif o:IsA("SurfaceAppearance")then o.ColorMap=""o.MetalnessMap=""o.RoughnessMap=""o.NormalMap=""
			elseif o:IsA("Highlight")then o.Enabled=false end
			if o:IsA("ParticleEmitter")then o.Enabled=false;o.Rate=0;o.Speed=NumberRange.new(0);o.Lifetime=NumberRange.new(0);o.Size=NumberSequence.new(0);o.Transparency=NumberSequence.new(1);o:Clear()end
			if o:IsA("Trail")or o:IsA("Beam")then o.Enabled=false;o.Width0=0;o.Width1=0;o.Transparency=NumberSequence.new(1);o.TextureLength=0 end
			if o:IsA("Fire")or o:IsA("Smoke")or o:IsA("Sparkles")then o.Enabled=false;o.Size=0 end
			if o:IsA("Explosion")then o.BlastRadius=0;o.BlastPressure=0 end
			if o:IsA("PointLight")or o:IsA("SpotLight")or o:IsA("SurfaceLight")then o.Enabled=false;o.Brightness=0;o.Range=0 end
			if o:IsA("BlurEffect")or o:IsA("BloomEffect")or o:IsA("ColorCorrectionEffect")or o:IsA("SunRaysEffect")or o:IsA("DepthOfFieldEffect")then o.Enabled=false end
			if o:IsA("Clouds")then o.Cover=0;o.Density=0 end
			if o:IsA("Atmosphere")then o.Density=0;o.Haze=0;o.Glare=0 end
			if o:IsA("BasePart")then o.CastShadow=false;o.Reflectance=0;o.Material=Enum.Material.Plastic end
		end
		for _,x in ipairs(w:GetDescendants())do k(x)end
		for _,x in ipairs(l:GetDescendants())do k(x)end
		st.neConns[#st.neConns+1]=w.DescendantAdded:Connect(k)
		st.neConns[#st.neConns+1]=l.DescendantAdded:Connect(k)
		if mode=="hook" then
			st.neHookOrig=hookmetamethod(game,"__newindex",newcclosure(function(s,k2,vv)
				if typeof(s)=="Instance" then
					if processed[s] then return st.neHookOrig(s,k2,vv) end
					if k2=="Parent" then
						processed[s]=true
						if s:IsA("ParticleEmitter")then st.neHookOrig(s,"Enabled",false);st.neHookOrig(s,"Rate",0);st.neHookOrig(s,"Lifetime",NumberRange.new(0));st.neHookOrig(s,"Speed",NumberRange.new(0));st.neHookOrig(s,"Size",NumberSequence.new(0));st.neHookOrig(s,"Transparency",NumberSequence.new(1))
						elseif s:IsA("Trail")or s:IsA("Beam")then st.neHookOrig(s,"Enabled",false);st.neHookOrig(s,"Width0",0);st.neHookOrig(s,"Width1",0);st.neHookOrig(s,"Transparency",NumberSequence.new(1))
						elseif s:IsA("Explosion")then st.neHookOrig(s,"BlastRadius",0);st.neHookOrig(s,"BlastPressure",0)
						elseif s:IsA("Fire")or s:IsA("Smoke")or s:IsA("Sparkles")then st.neHookOrig(s,"Enabled",false)
						elseif s:IsA("PointLight")or s:IsA("SpotLight")or s:IsA("SurfaceLight")then st.neHookOrig(s,"Enabled",false);st.neHookOrig(s,"Range",0) end
						return st.neHookOrig(s,k2,vv)
					end
					if s:IsA("ParticleEmitter")then
						if k2=="Enabled"then return st.neHookOrig(s,k2,false) elseif k2=="Rate"then return st.neHookOrig(s,k2,0)
						elseif k2=="Speed"or k2=="Lifetime"then return st.neHookOrig(s,k2,NumberRange.new(0))
						elseif k2=="Size"then return st.neHookOrig(s,k2,NumberSequence.new(0))
						elseif k2=="Transparency"then return st.neHookOrig(s,k2,NumberSequence.new(1)) end
					elseif s:IsA("Trail")or s:IsA("Beam")then
						if k2=="Enabled"then return st.neHookOrig(s,k2,false) elseif k2=="Width0"or k2=="Width1"then return st.neHookOrig(s,k2,0)
						elseif k2=="Transparency"then return st.neHookOrig(s,k2,NumberSequence.new(1)) end
					elseif s:IsA("PointLight")or s:IsA("SpotLight")or s:IsA("SurfaceLight")then
						if k2=="Enabled"then return st.neHookOrig(s,k2,false) elseif k2=="Range"then return st.neHookOrig(s,k2,0) end
					end
				end
				return st.neHookOrig(s,k2,vv)
			end))
		end
	end)
end
Cmd.add({"noeffect"}, {picker={
	title="NOEFFECT",subtitle="Select method",stopAlias="unnoeffect",
	buttons={
		{label="NO HOOK",  sub="Safe, client-side only",accent=Color3.fromRGB(0,170,255), value="nohook"},
		{label="WITH HOOK",sub="hookmetamethod-based",  accent=Color3.fromRGB(160,80,255),value="hook"},
	},
	onPick=activateNoEffect,stopFn=stopNoEffect,hookOnValue="hook",
}})
Cmd.add({"unnoeffect"}, {fn=stopNoEffect})

local function stopAvis()
	clearActive("avis"); for _,c in ipairs(st.avisConns) do c:Disconnect() end; st.avisConns={}
end
local function startAvis()
	if isActive("avis") then return end;stopAvis();setActive("avis")
	local b={Head=1,Torso=1,["Left Arm"]=1,["Right Arm"]=1,["Left Leg"]=1,["Right Leg"]=1,UpperTorso=1,LowerTorso=1,RightUpperArm=1,RightLowerArm=1,RightHand=1,LeftUpperArm=1,LeftLowerArm=1,LeftHand=1,RightUpperLeg=1,RightLowerLeg=1,RightFoot=1,LeftUpperLeg=1,LeftLowerLeg=1,LeftFoot=1}
	local function v(o)
		if o.Name=="HumanoidRootPart"then return end
		if(o:IsA("BasePart")and(b[o.Name]or(o.Parent and o.Parent:IsA("Accessory"))))or o:IsA("Decal")then
			pcall(function()
				o.Transparency=0;o.LocalTransparencyModifier=0
				st.avisConns[#st.avisConns+1]=o:GetPropertyChangedSignal("Transparency"):Connect(function() o.Transparency=0 end)
				st.avisConns[#st.avisConns+1]=o:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function() o.LocalTransparencyModifier=0 end)
			end)
		end
	end
	local function c(h)
		for _,o in ipairs(h:GetDescendants())do v(o)end
		st.avisConns[#st.avisConns+1]=h.DescendantAdded:Connect(v)
	end
	for _,player in ipairs(Players:GetPlayers())do
		if player.Character then c(player.Character)end
		st.avisConns[#st.avisConns+1]=player.CharacterAdded:Connect(c)
	end
	st.avisConns[#st.avisConns+1]=Players.PlayerAdded:Connect(function(player) st.avisConns[#st.avisConns+1]=player.CharacterAdded:Connect(c) end)
end
Cmd.add({"antiinvisible","antiinvis","avis"}, {fn=startAvis})
Cmd.add({"unantiinvisible","unantiinvis","unavis"}, {fn=stopAvis})

local function startAutoClick()
	if isActive("ac") then return end
	local VIM=Services.VirtualInputManager
	local ok=pcall(function() VIM:SendMouseButtonEvent(0,0,0,false,game,1) end)
	if not ok then
		if UI_Notif then UI_Notif.Notify({Title="No Name",Content="VirtualInputManager not supported by your executor",Duration=5}) end
		return
	end
	setActive("ac")
	task.spawn(function()
		while AC.active do
			pcall(function()
				local t2,m,d=AC.target,AC.mode,AC.delay
				if m=="Mobile"then VIM:SendTouchEvent(999,0,t2.X,t2.Y);if d>0 then task.wait(d/2)end;VIM:SendTouchEvent(999,2,t2.X,t2.Y)
				elseif m=="PC"then VIM:SendMouseButtonEvent(t2.X,t2.Y,0,true,game,1);if d>0 then task.wait(d/2)end;VIM:SendMouseButtonEvent(t2.X,t2.Y,0,false,game,1) end
			end)
			if AC.delay>0 then task.wait(AC.delay/2) else task.wait() end
		end
	end)
end
local function stopAutoClick() clearActive("ac"); AC.active=false end
local wfPower = 100000
Cmd.add({"autoclicker","autoclick"}, {fn=startAutoClick})
Cmd.add({"unautoclicker","unautoclick"}, {fn=stopAutoClick})

local function startWf(power)
	wfPower = tonumber(power) or 100000
	if conn.wfConn then conn.wfConn:Disconnect(); conn.wfConn = nil end
	local function getRoot(char) return char and(char:FindFirstChild("HumanoidRootPart")or char:FindFirstChild("Torso")or char:FindFirstChild("UpperTorso")) end
	conn.wfConn=rs.Heartbeat:Connect(function()
		local root=getRoot(p.Character); if not root then return end
		local v=root.Velocity; root.Velocity=v*wfPower; rs.RenderStepped:Wait(); root.Velocity=v
	end)
end
local function stopWf() if conn.wfConn then conn.wfConn:Disconnect(); conn.wfConn=nil end end
Cmd.add({"walkfling","wf"}, {args="[power]", fn=function(v) startWf(tonumber(v) or 100000) end})
Cmd.add({"unwalkfling","unwf"}, {fn=stopWf})

local function saDrawCircle(fov, visible)
	if st.saGui then st.saGui:Destroy(); st.saGui=nil end
	if st.saCircle then st.saCircle:Remove(); st.saCircle=nil end
	if not visible then return end
	
	local circle=Drawing.new("Circle")
	circle.Thickness=2; circle.Color=Color3.fromRGB(255,255,255)
	circle.Filled=false; circle.Visible=true; circle.Radius=fov
	circle.Position=Vector2.new(0,0)
	st.saCircle=circle
end
local function stopSa()
	saSettings.Enabled=false
	if st.saGui        then st.saGui:Destroy();              st.saGui=nil end
	if st.saCircle     then st.saCircle:Remove();            st.saCircle=nil end
	if conn.saMouseConn   then conn.saMouseConn:Disconnect();   conn.saMouseConn=nil end
	if conn.saPressConn   then conn.saPressConn:Disconnect();   conn.saPressConn=nil end
	if conn.saReleaseConn then conn.saReleaseConn:Disconnect(); conn.saReleaseConn=nil end
	if not st.saOld then return end
	hookmetamethod(game,"__index",st.saOld); st.saOld=nil
end
local function startSa(targetPart, arg, showFov)
	stopSa(); saSettings.Enabled=true
	saSettings.TargetPart=targetPart or saSettings.TargetPart
	local isNear=(arg=="near"); saSettings.Mode=isNear and "near" or "fov"
	saSettings.FOV=tonumber(arg) or saSettings.FOV
	local UIS2=Services.UserInputService
	local showCircle=(showFov~=false) and not isNear
	
	saDrawCircle(saSettings.FOV, showCircle)
	if st.saCircle then st.saCircle.Visible=false end
	if showCircle then
		local holding=false
		
		conn.saMouseConn=rs.RenderStepped:Connect(function()
			if holding and st.saCircle then
				local mp=UIS2:GetMouseLocation()
				st.saCircle.Position=Vector2.new(mp.X,mp.Y)
			end
		end)
		conn.saPressConn=UIS2.InputBegan:Connect(function(i,g)
			if g then return end
			if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
				holding=true
				if st.saCircle then st.saCircle.Visible=true end
			end
		end)
		conn.saReleaseConn=UIS2.InputEnded:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
				holding=false
				if st.saCircle then st.saCircle.Visible=false end
			end
		end)
	end
	
	local rpSa=RaycastParams.new(); rpSa.FilterType=Enum.RaycastFilterType.Exclude
	local function saWallCheck(part)
		if not p.Character or not part then return false end
		rpSa.FilterDescendantsInstances={p.Character,part.Parent}
		local orig=workspace.CurrentCamera.CFrame.Position
		local dir=part.Position-orig
		return not workspace:Raycast(orig,dir,rpSa)
	end
	local mouse=p:GetMouse()
	local function GetTarget()
		local myChar=p.Character; local myRoot=myChar and myChar:FindFirstChild("HumanoidRootPart")
		if saSettings.Mode=="near" then
			local closest,bestDist=nil,math.huge
			for _,pl in ipairs(Players:GetPlayers()) do
				local ch=pl.Character
				if pl~=p and ch and myRoot then
					local part=ch:FindFirstChild(saSettings.TargetPart); local hum=ch:FindFirstChildOfClass("Humanoid")
					local root2=ch:FindFirstChild("HumanoidRootPart")
					if part and hum and hum.Health>0 and root2 then
						local d=(myRoot.Position-root2.Position).Magnitude
						if d<bestDist and saWallCheck(part) then bestDist=d; closest=part end
					end
				end
			end
			return closest
		else
			local c2=workspace.CurrentCamera; if not c2 then return end
			
			local mp=UIS2:GetMouseLocation(); local cx,cy=mp.X,mp.Y
			local fovR=saSettings.FOV; local closest,dist=nil,fovR
			for _,pl in ipairs(Players:GetPlayers()) do
				local ch=pl.Character
				if pl~=p and ch then
					local part=ch:FindFirstChild(saSettings.TargetPart); local hum=ch:FindFirstChildOfClass("Humanoid")
					if part and hum and hum.Health>0 then
						local pos,on=c2:WorldToScreenPoint(part.Position)
						if on then
							local d=(Vector2.new(pos.X,pos.Y)-Vector2.new(cx,cy)).Magnitude
							if d<dist and saWallCheck(part) then dist=d; closest=part end
						end
					end
				end
			end
			return closest
		end
	end
	st.saOld=hookmetamethod(game,"__index",newcclosure(function(self,key)
		if not checkcaller() and self==mouse and saSettings.Enabled and (key=="Hit" or key=="Target" or key=="UnitRay") then
			local target=GetTarget(); local c2=workspace.CurrentCamera
			if target and target:IsDescendantOf(workspace) and c2 then
				local dir=target.Position-c2.CFrame.Position
				dir=dir.Magnitude>0 and dir.Unit or c2.CFrame.LookVector
				if key=="Target"   then return target end
				if key=="Hit"      then return CFrame.new(target.Position,target.Position+dir) end
				if key=="UnitRay"  then return Ray.new(c2.CFrame.Position,dir) end
			end
		end
		return st.saOld(self,key)
	end))
end
Cmd.add({"silentaim"}, {picker={
	title="SILENT AIM",subtitle="Select target part",stopAlias="unsilentaim",
	buttons={
		{label="HEAD", sub="Aim at head",              accent=Color3.fromRGB(0,170,255),  value="Head"},
		{label="HRP",  sub="Aim at HumanoidRootPart",  accent=Color3.fromRGB(160,80,255), value="HumanoidRootPart"},
	},
	onPick=function(part)
		
		task.delay(0.35,function()
			if not DC._showPicker then startSa(part,tostring(saSettings.FOV),true);return end
			DC._showPicker({
				title="SILENT AIM",subtitle="Show or hide FOV circle",
				buttons={
					{label="SHOW FOV",sub="Circle follows your mouse",accent=Color3.fromRGB(0,170,255), value="show"},
					{label="HIDE FOV",sub="No visual circle",         accent=Color3.fromRGB(80,80,120), value="hide"},
				},
			},function(fovVal)
				if fovVal==nil then return end
				startSa(part,tostring(saSettings.FOV),fovVal~="hide")
			end)
		end)
	end,
	stopFn=stopSa,
}})
Cmd.add({"unsilentaim"}, {fn=stopSa})

local function startTpw(spd)
	if isActive("tpw") then return end;setActive("tpw")
	if conn.tpwConn then conn.tpwConn:Disconnect() end; if conn.tpwCharConn then conn.tpwCharConn:Disconnect() end
	local s=spd or 0.5; local _tpwHum
	conn.tpwCharConn=p.CharacterAdded:Connect(function() _tpwHum=nil end)
	conn.tpwConn=rs.Stepped:Connect(function()
		if not _tpwHum or not _tpwHum.Parent then _tpwHum=p.Character and p.Character:FindFirstChildOfClass("Humanoid") end
		if _tpwHum and _tpwHum.MoveDirection.Magnitude>0 then _tpwHum.Parent:TranslateBy(_tpwHum.MoveDirection*s) end
	end)
end
local function stopTpw()
	clearActive("tpw")
	if conn.tpwConn     then conn.tpwConn:Disconnect();     conn.tpwConn=nil end
	if conn.tpwCharConn then conn.tpwCharConn:Disconnect(); conn.tpwCharConn=nil end
end
Cmd.add({"tpwalkspeed","tpwalk"}, {args="[speed]", fn=function(v) startTpw(tonumber(v)) end})
Cmd.add({"untpwalkspeed","untpwalk"}, {fn=stopTpw})

local function stopVf()
	clearActive("vf")
	if conn.vfConn     then conn.vfConn:Disconnect();     conn.vfConn=nil end
	if conn.vfCharConn then conn.vfCharConn:Disconnect(); conn.vfCharConn=nil end
	local char=p.Character
	if char then
		local root2=char:FindFirstChild("HumanoidRootPart")
		if root2 then
			local bg2=root2:FindFirstChild("NA_Gyro");local bv2=root2:FindFirstChild("NA_Velocity")
			if bg2 then bg2:Destroy() end;if bv2 then bv2:Destroy() end
		end
	end
end
local function startVf(spd)
	if isActive("vf") then return end;setActive("vf");stopVf()
	local speed=spd or 50
	local function doFly(char)
		local root2=char:WaitForChild("HumanoidRootPart",5); if not root2 then return end
		local bg2=Instance.new("BodyGyro",root2);bg2.Name="NA_Gyro";bg2.MaxTorque=Vector3.new(9e9,9e9,9e9);bg2.P=9e4
		local bv2=Instance.new("BodyVelocity",root2);bv2.Name="NA_Velocity";bv2.MaxForce=Vector3.new(9e9,9e9,9e9);bv2.Velocity=Vector3.zero
		conn.vfConn=rs.Heartbeat:Connect(function()
			if not char:IsDescendantOf(workspace) or not bg2.Parent or not bv2.Parent then
				conn.vfConn:Disconnect();conn.vfConn=nil;bg2:Destroy();bv2:Destroy();return
			end
			local mv=getCtrls():GetMoveVector()
			bv2.Velocity=mv.Magnitude>0 and cam.CFrame:VectorToWorldSpace(Vector3.new(mv.X,0,mv.Z))*speed or Vector3.zero
			bg2.CFrame=cam.CFrame
		end)
	end
	if p.Character then doFly(p.Character) end
	conn.vfCharConn=p.CharacterAdded:Connect(doFly)
end
Cmd.add({"vehiclefly","vfly"}, {args="[speed]", fn=function(v) startVf(tonumber(v)) end, hud="speed",hudDefault=50,hudStart="startVf",hudStop="stopVf",hudOn={"vehiclefly","vfly"},hudOff={"unvehiclefly","unvfly"}})
Cmd.add({"unvehiclefly","unvfly"}, {fn=stopVf})

local function startReach(sz)
	local size=tonumber(sz) or 25; local char=p.Character
	local tool=char and char:FindFirstChildOfClass("Tool") or p.Backpack:FindFirstChildOfClass("Tool"); if not tool then return end
	local val=Instance.new("Vector3Value",tool);val.Name="OGSize3";val.Value=tool.Handle.Size
	local sb=Instance.new("SelectionBox");sb.Adornee=tool.Handle;sb.Name="FunTIMES";sb.Transparency=1;sb.Parent=tool.Handle
	tool.Handle.Massless=true;tool.Handle.Size=Vector3.new(size,size,size)
end
Cmd.add({"reach"}, {args="[size]", fn=function(v) startReach(v) end})

local function setupInvisChar(char)
	char=char or p.Character; if not char then return end; st.invisVisibleParts={}
	for _,part in pairs(char:GetDescendants()) do if part:IsA("BasePart") and part.Transparency==0 then st.invisVisibleParts[#st.invisVisibleParts+1]=part end end
	for _,part in pairs(st.invisVisibleParts) do part.Transparency=0.5 end
end
local function startInvis()
	if st.invisActive then return end; st.invisActive=true
	local char=p.Character or p.CharacterAdded:Wait()
	local hum=char:WaitForChild("Humanoid",5);local root2=char:WaitForChild("HumanoidRootPart",5)
	if not hum or not root2 then st.invisActive=false;return end
	setupInvisChar(char)
	if conn.invisCharConn then conn.invisCharConn:Disconnect() end
	conn.invisCharConn=p.CharacterAdded:Connect(function(newChar)
		if not st.invisActive then return end
		hum=newChar:WaitForChild("Humanoid",5);root2=newChar:WaitForChild("HumanoidRootPart",5)
		if hum and root2 then setupInvisChar(newChar) end
	end)
	if conn.invisConn then conn.invisConn:Disconnect() end
	conn.invisConn=rs.Heartbeat:Connect(function()
		if not st.invisActive or not root2 or not root2.Parent or not hum or not hum.Parent then return end
		local origCF=root2.CFrame;local origCO=hum.CameraOffset
		local hiddenCF=origCF-origCF.Position+Vector3.new(origCF.X,origCF.Y-200000,origCF.Z)
		root2.CFrame=hiddenCF;hum.CameraOffset=origCF.Position-hiddenCF.Position
		rs.RenderStepped:Wait(); root2.CFrame=origCF;hum.CameraOffset=origCO
	end)
end
local function stopInvis()
	clearActive("invis");st.invisActive=false
	if conn.invisConn     then conn.invisConn:Disconnect();     conn.invisConn=nil end
	if conn.invisCharConn then conn.invisCharConn:Disconnect(); conn.invisCharConn=nil end
	for _,part in pairs(st.invisVisibleParts) do if part and part.Parent then part.Transparency=0 end end
	st.invisVisibleParts={}
end
Cmd.add({"invisible","invis"}, {fn=startInvis})
Cmd.add({"uninvisible","uninvis"}, {fn=stopInvis})

Cmd.add({"selfkick","sk"}, {fn=function() p:Kick("You have been banned.\n\nReason: Exploiting\n\nAppeal at: www.roblox.com/appeal") end})
Cmd.add({"addbutton","ab"}, {args="[command] [arg]", fn=function(v,v2,v3) if v and DC.addButton then DC.addButton(v,v2,v3) end end})
Cmd.add({"removebutton","rb"}, {args="[command] [arg]", fn=function(v,v2) if v and DC.removeButton then DC.removeButton(v,v2) end end})
Cmd.add({"commands","cmds"}, {fn=nil})
Cmd.add({"jobid"}, {fn=function() safeClip(tostring(game.JobId)) end})
Cmd.add({"gameid"}, {fn=function() safeClip(tostring(game.GameId)) end})
Cmd.add({"placeid"}, {fn=function() safeClip(tostring(game.PlaceId)) end})
Cmd.add({"joinjobid"}, {args="[id]", fn=function(v) if v then tps:TeleportToPlaceInstance(game.PlaceId,v,p) end end})
Cmd.add({"joinplaceid"}, {args="[id]", fn=function(v) if v then tps:Teleport(tonumber(v),p) end end})
Cmd.add({"admin"}, {fn=function()
	if st.adminActive then return end; st.adminActive=true
	conn.adminChatConn=p.Chatted:Connect(function(msg)
		if msg:sub(1,1)~="/" then return end
		if DC.runCmd then DC.runCmd(msg:sub(2)) end
	end)
end})
Cmd.add({"antiafk","aafk"}, {fn=function()
	if DC._aafkConn then return end
	local vu=Services.VirtualUser
	local ok=pcall(function() vu:Button2Down(Vector2.new(),cam.CFrame);vu:Button2Up(Vector2.new(),cam.CFrame) end)
	if not ok then
		if UI_Notif then UI_Notif.Notify({Title="No Name",Content="VirtualUser not supported by your executor",Duration=5}) end
		return
	end
	DC._aafkConn=p.Idled:Connect(function()
		vu:Button2Down(Vector2.new(),cam.CFrame);task.wait(1);vu:Button2Up(Vector2.new(),cam.CFrame)
	end)
end})
Cmd.add({"unantiafk","uaafk"}, {fn=function()
	if DC._aafkConn then DC._aafkConn:Disconnect();DC._aafkConn=nil end
end})
Cmd.add({"fixcam"}, {fn=function()
	local ch=p.Character or p.CharacterAdded:Wait()
	local f=cam.FieldOfView
	cam.CameraType=Enum.CameraType.Custom;cam.CameraSubject=ch:FindFirstChildOfClass("Humanoid");cam.FieldOfView=f
end})
Cmd.add({"hitbox","hb"}, {args="[size] [transparency]", fn=function(v,v2)
	for _,c in ipairs(st.hitboxConns) do c:Disconnect() end; st.hitboxConns={}
	if st.hitboxNccFolder then st.hitboxNccFolder:Destroy() end
	st.hitboxNccFolder=Instance.new("Folder",workspace);st.hitboxNccFolder.Name="NNHitboxNCC"
	local size=tonumber(v) or 30; local transp=tonumber(v2) or 0.9
	local myHrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
	local function applyNcc(hrp)
		if not myHrp then myHrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart") end
		if myHrp then local ncc=Instance.new("NoCollisionConstraint",st.hitboxNccFolder);ncc.Part0,ncc.Part1=myHrp,hrp end
	end
	local function monitor(hrp)
		local sz=Vector3.new(size,size,size)
		if not st.hitboxOrigSizes[hrp] then st.hitboxOrigSizes[hrp]=hrp.Size end
		local function apply() if hrp.Size.X~=size then hrp.Size=sz;hrp.Transparency=transp end end
		apply();applyNcc(hrp)
		st.hitboxConns[#st.hitboxConns+1]=hrp:GetPropertyChangedSignal("Size"):Connect(apply)
	end
	local function onChar(char)
		local hrp=char:WaitForChild("HumanoidRootPart",5); if hrp then monitor(hrp) end
	end
	local function onPlayer(pl)
		if pl==p then return end
		if p.Team and pl.Team and pl.Team==p.Team then return end
		if pl.Character then onChar(pl.Character) end
		st.hitboxConns[#st.hitboxConns+1]=pl.CharacterAdded:Connect(onChar)
	end
	for _,pl in ipairs(Players:GetPlayers()) do onPlayer(pl) end
	st.hitboxConns[#st.hitboxConns+1]=Players.PlayerAdded:Connect(onPlayer)
	st.hitboxConns[#st.hitboxConns+1]=p.CharacterAdded:Connect(function(char)
		myHrp=char:WaitForChild("HumanoidRootPart",5); if not myHrp then return end
		for _,pl in ipairs(Players:GetPlayers()) do
			if pl~=p and pl.Character then
				local hrp=pl.Character:FindFirstChild("HumanoidRootPart"); if hrp then applyNcc(hrp) end
			end
		end
	end)
end})
Cmd.add({"unhitbox","unhb"}, {fn=function()
	for _,c in ipairs(st.hitboxConns) do c:Disconnect() end; st.hitboxConns={}
	for hrp,origSize in pairs(st.hitboxOrigSizes) do if hrp and hrp.Parent then hrp.Size=origSize;hrp.Transparency=0 end end
	st.hitboxOrigSizes={}
	if st.hitboxNccFolder then st.hitboxNccFolder:Destroy();st.hitboxNccFolder=nil end
end})


DC = {
	Player=p,Players=Players,_active=_active,
	Cmds=Cmds,
	resolveTargets=resolveTargets,
	startFly=startFly,stopFly=stopFly,
	lockws=startLws,unlockws=stopLws,
	loopws=startLoopws,unloopws=stopLoopws,
	getCtrls=getCtrls,
	startFc=startFc,stopFc=stopFc,
	startFrz=startFrz,stopFrz=stopFrz,
	startVf=startVf,stopVf=stopVf,
	AC=AC,
}

task.wait()
local _C=Color3.fromRGB;local _U=UDim2.new;local _N=Instance.new;local _GB=Enum.Font.GothamBold;local _GS=Enum.Font.GothamSemibold;local _G=Enum.Font.Gotham;local _TX=Enum.TextXAlignment;local _UI=Enum.UserInputType
local MAX_SUGG=6;local ITEM_H=30;local ITEM_PAD=10
local sg=_N("ScreenGui",game.CoreGui);sg.ResetOnSpawn=false;sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;sg.Enabled=false
local function makeDraggable(frame,handle)
	handle=handle or frame
	local dragInput,dragStart,startPos
	handle.InputBegan:Connect(function(input)
		if input.UserInputType==_UI.MouseButton1 or input.UserInputType==_UI.Touch then
			dragInput=input;dragStart=input.Position;startPos=frame.Position
			input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then if dragInput==input then dragInput=nil end end end)
		end
	end)
	handle.InputChanged:Connect(function(input)
		if dragInput and input==dragInput then
			local delta=input.Position-dragStart
			frame.Position=_U(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
		end
	end)
end
local btnContainer=_N("Frame",sg);btnContainer.Name="Container";btnContainer.Size=_U(0,50,0,50);btnContainer.Position=_U(0,20,0,20)
btnContainer.BackgroundTransparency=1;btnContainer.BorderSizePixel=0;btnContainer.ZIndex=10
local btn=_N("ImageButton",btnContainer);btn.Name="Button";btn.Size=_U(1,0,1,0);btn.BackgroundTransparency=1;btn.BorderSizePixel=0
btn.Image="rbxassetid://104825908024064";btn.ImageTransparency=0;btn.ScaleType=Enum.ScaleType.Fit;btn.AutoButtonColor=false;btn.Active=true;btn.ZIndex=10
btn.MouseEnter:Connect(function() ts:Create(btn,TweenInfo.new(0.15),{ImageTransparency=0.2}):Play() end)
btn.MouseLeave:Connect(function() ts:Create(btn,TweenInfo.new(0.15),{ImageTransparency=0}):Play() end)
makeDraggable(btnContainer,btn)
local cmdFrame=_N("Frame",sg);cmdFrame.Size=_U(0,0,0,48);cmdFrame.Position=_U(0.5,0,0.60,0);cmdFrame.AnchorPoint=Vector2.new(0.5,0.5)
cmdFrame.BackgroundColor3=_C(12,12,12);cmdFrame.ClipsDescendants=true;cmdFrame.Visible=false
_N("UICorner",cmdFrame).CornerRadius=UDim.new(0,24)
local s2=_N("UIStroke",cmdFrame);s2.Color=_C(45,45,45);s2.Thickness=1.5
local cmdIcon=_N("TextLabel",cmdFrame);cmdIcon.Size=_U(0,36,1,0);cmdIcon.Position=_U(0,8,0,0);cmdIcon.BackgroundTransparency=1
cmdIcon.Text="⌘";cmdIcon.TextColor3=_C(160,160,160);cmdIcon.Font=_GB;cmdIcon.TextSize=18
local box=_N("TextBox",cmdFrame);box.Size=_U(1,-50,1,0);box.Position=_U(0,40,0,0);box.BackgroundTransparency=1
box.Text="";box.TextColor3=_C(220,220,220);box.PlaceholderText="Noname v1.0.0";box.PlaceholderColor3=_C(90,90,90)
box.Font=_GS;box.TextSize=15;box.TextXAlignment=_TX.Left
local suggFrame=_N("Frame",sg);suggFrame.Size=_U(0,400,0,0);suggFrame.Position=_U(0.5,0,0.60,-32);suggFrame.AnchorPoint=Vector2.new(0.5,1)
suggFrame.BackgroundTransparency=1;suggFrame.Visible=false
local ll=_N("UIListLayout",suggFrame);ll.Padding=UDim.new(0,ITEM_PAD);ll.HorizontalAlignment=Enum.HorizontalAlignment.Center
local clickingSugg=false
local suggItems={}
for i=1,MAX_SUGG do
	local item=_N("TextButton",suggFrame);item.Size=_U(0,165,0,ITEM_H);item.BackgroundColor3=_C(12,12,12);item.BackgroundTransparency=0;item.TextColor3=_C(255,255,255)
	item.Font=_GB;item.TextSize=12;item.TextXAlignment=_TX.Center;item.AutoButtonColor=false;item.Text="";item.Visible=false;item.LayoutOrder=i
	_N("UICorner",item).CornerRadius=UDim.new(0,7)
	local ist=_N("UIStroke",item);ist.Color=_C(45,45,45);ist.Thickness=1;ist.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
	item.MouseButton1Down:Connect(function() clickingSugg=true end)
	item.MouseButton1Click:Connect(function()
		local first=string.match(item.Text,"^([^/%s]+)")
		local hasArgs=string.find(item.Text,"%[") or string.find(item.Text,"%(")
		if hasArgs then
			box.Text=first.." ";clickingSugg=false;box:CaptureFocus()
		else
			box.Text=first;clickingSugg=false;closeCmd(first)
		end
	end)
	suggItems[i]=item
end
local populateList
local cmdListFrame,scroll,searchBox
local function ensureCmdList()
	if cmdListFrame then return end
	cmdListFrame=_N("Frame",sg);cmdListFrame.Size=_U(0,300,0,380);cmdListFrame.Position=_U(0.5,0,0.5,0)
	cmdListFrame.AnchorPoint=Vector2.new(0.5,0.5);cmdListFrame.BackgroundColor3=_C(25,25,25);cmdListFrame.Visible=false;cmdListFrame.Active=true
	_N("UICorner",cmdListFrame).CornerRadius=UDim.new(0,8)
	local sL=_N("UIStroke",cmdListFrame);sL.Color=_C(45,45,45);sL.Thickness=2
	local titleBar=_N("Frame",cmdListFrame);titleBar.Size=_U(1,0,0,40);titleBar.BackgroundColor3=_C(20,20,20)
	_N("UICorner",titleBar).CornerRadius=UDim.new(0,8)
	local tFix=_N("Frame",titleBar);tFix.Size=_U(1,0,0.5,0);tFix.Position=_U(0,0,0.5,0);tFix.BackgroundColor3=_C(20,20,20);tFix.BorderSizePixel=0
	makeDraggable(cmdListFrame,titleBar)
	local titleText=_N("TextLabel",titleBar);titleText.Size=_U(1,-40,1,0);titleText.Position=_U(0,15,0,0);titleText.BackgroundTransparency=1
	titleText.Text="Command List";titleText.TextColor3=_C(255,255,255);titleText.Font=_GB;titleText.TextSize=16;titleText.TextXAlignment=_TX.Left
	local closeBtn=_N("TextButton",titleBar);closeBtn.Size=_U(0,30,0,30);closeBtn.Position=_U(1,-35,0,5);closeBtn.BackgroundTransparency=1
	closeBtn.Text="❌";closeBtn.TextSize=14;closeBtn.Font=_G
	searchBox=_N("TextBox",cmdListFrame);searchBox.Size=_U(1,-20,0,28);searchBox.Position=_U(0,10,0,44)
	searchBox.BackgroundColor3=_C(35,35,35);searchBox.BorderSizePixel=0;searchBox.PlaceholderText="🔍search command..."
	searchBox.PlaceholderColor3=_C(100,100,100);searchBox.Text="";searchBox.TextColor3=_C(220,220,220)
	searchBox.Font=_GS;searchBox.TextSize=13;searchBox.ClearTextOnFocus=false
	_N("UICorner",searchBox).CornerRadius=UDim.new(0,6);_N("UIPadding",searchBox).PaddingLeft=UDim.new(0,8)
	scroll=_N("ScrollingFrame",cmdListFrame);scroll.Size=_U(1,-20,1,-82);scroll.Position=_U(0,10,0,78)
	scroll.BackgroundTransparency=1;scroll.ScrollBarThickness=4;scroll.CanvasSize=_U(0,0,0,0)
	scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y;scroll.ScrollBarImageColor3=_C(90,90,90)
	local listLayout=_N("UIListLayout",scroll);listLayout.Padding=UDim.new(0,5);listLayout.SortOrder=Enum.SortOrder.LayoutOrder
	closeBtn.MouseButton1Click:Connect(function() cmdListFrame.Visible=false end)
	searchBox:GetPropertyChangedSignal("Text"):Connect(function() populateList(string.lower(searchBox.Text)) end)
end
local COLOR_ON=_C(80,220,120);local COLOR_OFF=_C(220,70,70)
local function makeHUD(label,defaultSpd,startFn,stopFn,yOff)
	local active,speed,expanded=false,defaultSpd,false
	local tw=TweenInfo.new(0.15,Enum.EasingStyle.Quad)
	local frame,stroke,nameLabel,speedLabel,toggleBtn,inputRow,inputBox
	local built=false
	local applySpeed,setExpanded,setActive
	local function build()
		if built then return end;built=true
		frame=_N("Frame",sg);frame.Size=_U(0,130,0,44);frame.Position=_U(1,-146,0,20+yOff)
		frame.BackgroundColor3=_C(22,22,22);frame.BorderSizePixel=0;frame.Active=true;frame.Visible=false;frame.ClipsDescendants=true
		_N("UICorner",frame).CornerRadius=UDim.new(0,12)
		stroke=_N("UIStroke",frame);stroke.Color=COLOR_ON;stroke.Thickness=2
		nameLabel=_N("TextLabel",frame);nameLabel.Size=_U(1,-64,0,44);nameLabel.Position=_U(0,10,0,0)
		nameLabel.BackgroundTransparency=1;nameLabel.Text=label;nameLabel.TextColor3=COLOR_ON
		nameLabel.Font=_GB;nameLabel.TextSize=16;nameLabel.TextXAlignment=_TX.Left;nameLabel.TextYAlignment=Enum.TextYAlignment.Center
		speedLabel=_N("TextLabel",frame);speedLabel.Size=_U(0,36,0,44);speedLabel.Position=_U(1,-60,0,0)
		speedLabel.BackgroundTransparency=1;speedLabel.Text=tostring(speed);speedLabel.TextColor3=_C(140,140,140)
		speedLabel.Font=_GB;speedLabel.TextSize=11;speedLabel.TextXAlignment=_TX.Center;speedLabel.TextYAlignment=Enum.TextYAlignment.Center
		toggleBtn=_N("TextButton",frame);toggleBtn.Size=_U(0,22,0,22);toggleBtn.Position=_U(1,-26,0,11)
		toggleBtn.BackgroundColor3=_C(45,45,45);toggleBtn.BorderSizePixel=0;toggleBtn.Text="+"
		toggleBtn.TextColor3=_C(200,200,200);toggleBtn.Font=_GB;toggleBtn.TextSize=13;toggleBtn.ZIndex=5
		_N("UICorner",toggleBtn).CornerRadius=UDim.new(0,6)
		inputRow=_N("Frame",frame);inputRow.Size=_U(1,-16,0,38);inputRow.Position=_U(0,8,0,50)
		inputRow.BackgroundColor3=_C(32,32,32);inputRow.BorderSizePixel=0;inputRow.Visible=false
		_N("UICorner",inputRow).CornerRadius=UDim.new(0,8);_N("UIStroke",inputRow).Color=_C(60,60,80)
		inputBox=_N("TextBox",inputRow);inputBox.Size=_U(1,-16,1,-8);inputBox.Position=_U(0,8,0,4)
		inputBox.BackgroundTransparency=1;inputBox.Text=tostring(speed);inputBox.TextColor3=_C(230,230,230)
		inputBox.Font=_GB;inputBox.TextSize=15;inputBox.TextXAlignment=_TX.Center;inputBox.PlaceholderText="speed"
		local clickArea=_N("TextButton",frame);clickArea.Size=_U(1,-36,0,44);clickArea.BackgroundTransparency=1;clickArea.Text="";clickArea.ZIndex=2
		makeDraggable(frame,clickArea)
		local _th=false
		toggleBtn.MouseButton1Click:Connect(function() _th=true;setExpanded(not expanded) end)
		clickArea.MouseButton1Click:Connect(function()
			if _th then _th=false;return end
			active=not active
			local col=active and COLOR_ON or COLOR_OFF
			ts:Create(stroke,tw,{Color=col}):Play();ts:Create(nameLabel,tw,{TextColor3=col}):Play()
			if active then startFn(speed) else stopFn() end
			if not active and expanded then setExpanded(false) end
		end)
		inputBox.FocusLost:Connect(function()
			applySpeed(inputBox.Text)
			if tonumber(inputBox.Text)==nil or tonumber(inputBox.Text)<1 then inputBox.Text=tostring(speed) end
		end)
	end
	applySpeed=function(val)
		local n=tonumber(val);if not n or n<1 then return end
		speed=n;speedLabel.Text=tostring(speed);inputBox.Text=tostring(speed);if active then startFn(speed) end
	end
	setExpanded=function(state)
		expanded=state;toggleBtn.Text=state and "-" or "+"
		if state then ts:Create(frame,tw,{Size=_U(0,130,0,98)}):Play();task.delay(0.15,function() inputRow.Visible=true end)
		else inputRow.Visible=false;ts:Create(frame,tw,{Size=_U(0,130,0,44)}):Play() end
	end
	setActive=function(state,doShow)
		active=state
		if doShow then frame.Visible=true end
		if not state then frame.Visible=false;if expanded then setExpanded(false) end;stopFn();return end
		startFn(speed)
	end
	return {
		show=function(spd)
			build()
			if spd then speed=math.max(1,spd);speedLabel.Text=tostring(speed);inputBox.Text=tostring(speed) end
			setActive(true,true)
		end,
		hide=function() if not built then return end;setActive(false,false) end,
	}
end
local function makeToggleHUD(label,startFn,stopFn,yOff)
	local active=false
	local tw=TweenInfo.new(0.15,Enum.EasingStyle.Quad)
	local frame,stroke,nameLabel
	local built=false
	local function build()
		if built then return end;built=true
		frame=_N("Frame",sg);frame.Size=_U(0,100,0,40);frame.Position=_U(1,-120,0,20+yOff)
		frame.BackgroundColor3=_C(22,22,22);frame.BorderSizePixel=0;frame.Active=true;frame.Visible=false
		_N("UICorner",frame).CornerRadius=UDim.new(0,12)
		stroke=_N("UIStroke",frame);stroke.Color=COLOR_ON;stroke.Thickness=2
		nameLabel=_N("TextLabel",frame);nameLabel.Size=_U(1,0,1,0);nameLabel.BackgroundTransparency=1
		nameLabel.Text=label;nameLabel.TextColor3=COLOR_ON;nameLabel.Font=_GB;nameLabel.TextSize=16;nameLabel.TextXAlignment=_TX.Center
		local E=14
		for _,ed in ipairs({{_U(1,0,0,E),_U(0,0,0,0)},{_U(1,0,0,E),_U(0,0,1,-E)},{_U(0,E,1,0),_U(0,0,0,0)},{_U(0,E,1,0),_U(1,-E,0,0)}}) do
			local strip=_N("TextButton",frame);strip.Size=ed[1];strip.Position=ed[2]
			strip.BackgroundTransparency=1;strip.Text="";strip.AutoButtonColor=false;strip.ZIndex=3
			makeDraggable(frame,strip)
		end
		local clickArea=_N("TextButton",frame);clickArea.Size=_U(1,-8,1,-8);clickArea.Position=_U(0,4,0,4)
		clickArea.BackgroundTransparency=1;clickArea.Text="";clickArea.ZIndex=2;makeDraggable(frame,clickArea)
		local _th=false
		clickArea.MouseButton1Click:Connect(function()
			if _th then _th=false;return end
			active=not active
			local col=active and COLOR_ON or COLOR_OFF
			ts:Create(stroke,tw,{Color=col}):Play();ts:Create(nameLabel,tw,{TextColor3=col}):Play()
			if active then startFn() else stopFn() end
		end)
	end
	return {
		show=function() build();active=true;frame.Visible=true;stroke.Color=COLOR_ON;nameLabel.TextColor3=COLOR_ON;startFn() end,
		hide=function() if not built then return end;active=false;frame.Visible=false;stopFn() end,
		showOff=function() build();active=false;frame.Visible=true;stroke.Color=COLOR_OFF;nameLabel.TextColor3=COLOR_OFF end,
		destroy=function() if frame then frame:Destroy();frame=nil end;built=false end,
	}
end
local hudMap={};local hudYOffset=0
for _,entry in ipairs(Cmds) do
	if entry.hud then
		local alias0=entry.aliases[1]
		local label=entry.hudLabel or (alias0:sub(1,1):upper()..alias0:sub(2))
		local hud
		if entry.hud=="speed" then
			hud=makeHUD(label,entry.hudDefault or 50,
				function(spd) if DC[entry.hudStart] then DC[entry.hudStart](spd) end end,
				function() if DC[entry.hudStop] then DC[entry.hudStop]() end end,
				hudYOffset);hudYOffset+=80
		elseif entry.hud=="toggle" then
			hud=makeToggleHUD(label,
				function() if DC[entry.hudStart] then DC[entry.hudStart]() end end,
				function() if DC[entry.hudStop] then DC[entry.hudStop]() end end,
				hudYOffset);hudYOffset+=50
		end
		if hud then
			if entry.hudOn then
				local ons=type(entry.hudOn)=="table" and entry.hudOn or {entry.hudOn}
				for _,a in ipairs(ons) do hudMap[a]={hud=hud,action="show",isSpeed=entry.hud=="speed"} end
			end
			if entry.hudOff then
				local offs=type(entry.hudOff)=="table" and entry.hudOff or {entry.hudOff}
				for _,a in ipairs(offs) do hudMap[a]={hud=hud,action="hide"} end
			end
		end
	end
end
local aliasLookup={}
for _,entry in ipairs(Cmds) do for _,alias in ipairs(entry.aliases) do aliasLookup[alias]=entry end end
local function updateSugg(txt)
	if txt=="" then suggFrame.Visible=false;return end
	local count=0;local tl=#txt;local seen={}
	for _,entry in ipairs(Cmds) do
		for _,alias in ipairs(entry.aliases) do
			if string.sub(alias,1,tl)==txt then
				local label=table.concat(entry.aliases,"/")
				if not seen[label] then
					seen[label]=true;count+=1
					local displayText=entry.args and(label.." "..entry.args)or label
					suggItems[count].Text=displayText;suggItems[count].Size=_U(0,150+#displayText*10,0,ITEM_H);suggItems[count].Visible=true
					if count>=MAX_SUGG then break end
				end;break
			end
		end
		if count>=MAX_SUGG then break end
	end
	if count==0 then suggFrame.Visible=false;return end
	for i=count+1,MAX_SUGG do suggItems[i].Text="";suggItems[i].Visible=false end
	suggFrame.Size=_U(0,400,0,count*ITEM_H+(count-1)*ITEM_PAD);suggFrame.Visible=true
end
populateList=function(filter)
	for _,child in ipairs(scroll:GetChildren()) do if child:IsA("TextLabel") then child:Destroy() end end
	local i=1;local seen={}
	for _,entry in ipairs(Cmds) do
		local label=table.concat(entry.aliases,"/")
		if not seen[label] then
			seen[label]=true
			local show=filter==nil or filter=="" or string.find(label,filter,1,true)
			if show then
				local item=_N("TextLabel",scroll);item.Size=_U(1,-10,0,25);item.BackgroundTransparency=1
				item.Text=i..". "..(entry.args and(label.." "..entry.args)or label)
				item.TextColor3=_C(255,255,255);item.Font=_GS;item.TextSize=14;item.TextXAlignment=_TX.Left;item.LayoutOrder=i
				i+=1
			end
		end
	end
end
local function runCommand(input)
	local args={}
	for word in string.gmatch(input,"%S+") do args[#args+1]=word:gsub(",","") end
	if #args==0 then return end
	local c=args[1]
	if c=="commands" or c=="cmds" then ensureCmdList();searchBox.Text="";populateList(nil);cmdListFrame.Visible=true;return end
	local h=hudMap[c]
	if h then
		if h.action=="show" then h.hud.show(h.isSpeed and tonumber(args[2]) or nil)
		else h.hud.hide() end;return
	end
	local entry=aliasLookup[c]
	if entry and entry.fn then
		local stopEntry=aliasLookup["un"..c]
		if not stopEntry then stopEntry=aliasLookup["un"..c:gsub("^lock","unlock"):gsub("^loop","unloop")] end
		if stopEntry and stopEntry.fn then pcall(stopEntry.fn) end
		entry.fn(args[2],args[3],args[4])
	end
end
local cmdOpen=false
local function closeCmd(input)
	if not cmdOpen then return end;cmdOpen=false;box.Text="";suggFrame.Visible=false
	ts:Create(cmdFrame,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=_U(0,0,0,48)}):Play()
	task.delay(0.25,function() cmdFrame.Visible=false;btnContainer.Visible=true end)
	if input and input~="" then runCommand(input) end
end
btn.MouseButton1Click:Connect(function()
	if cmdOpen then return end;cmdOpen=true;btnContainer.Visible=false;cmdFrame.Visible=true;cmdFrame.Size=_U(0,0,0,48)
	ts:Create(cmdFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=_U(0,260,0,38)}):Play()
	task.delay(0.1,function() box:CaptureFocus() end)
end)
box:GetPropertyChangedSignal("Text"):Connect(function()
	local txt=string.lower(box.Text);if string.find(txt," ") then suggFrame.Visible=false else updateSugg(txt) end
end)
box.FocusLost:Connect(function(enter)
	if clickingSugg then return end
	local input=string.lower(box.Text)
	if not enter and input=="" then closeCmd(nil);return end;closeCmd(input)
end)
DC.runCmd=runCommand
local dynamicHuds={}
DC.addButton=function(alias,a1,a2)
	if not alias then return end
	alias=alias:lower()
	local key=alias..(a1 and ("_"..a1) or "")
	if dynamicHuds[key] then return end
	local entry=aliasLookup[alias]
	if not entry or not entry.fn then return end
	local label=alias:sub(1,1):upper()..alias:sub(2)..(a1 and (" "..a1) or "")
	local unEntry=aliasLookup["un"..alias]
	local hud
	if unEntry and unEntry.fn then
		hud=makeToggleHUD(label,function() entry.fn(a1,a2) end,unEntry.fn,hudYOffset)
	else
		local tw2=TweenInfo.new(0.15,Enum.EasingStyle.Quad)
		local built2=false
		local frame2,stroke2,nameLabel2
		local function build2()
			if built2 then return end;built2=true
			frame2=_N("Frame",sg);frame2.Size=_U(0,100,0,40);frame2.Position=_U(1,-120,0,20+hudYOffset)
			frame2.BackgroundColor3=_C(22,22,22);frame2.BorderSizePixel=0;frame2.Active=true;frame2.Visible=true
			_N("UICorner",frame2).CornerRadius=UDim.new(0,12)
			stroke2=_N("UIStroke",frame2);stroke2.Color=COLOR_OFF;stroke2.Thickness=2
			nameLabel2=_N("TextLabel",frame2);nameLabel2.Size=_U(1,0,1,0);nameLabel2.BackgroundTransparency=1
			nameLabel2.Text=label;nameLabel2.TextColor3=COLOR_OFF;nameLabel2.Font=_GB;nameLabel2.TextSize=16;nameLabel2.TextXAlignment=_TX.Center
			local clickArea=_N("TextButton",frame2);clickArea.Size=_U(1,-8,1,-8);clickArea.Position=_U(0,4,0,4)
			clickArea.BackgroundTransparency=1;clickArea.Text="";clickArea.ZIndex=2;makeDraggable(frame2,clickArea)
			clickArea.MouseButton1Click:Connect(function()
				ts:Create(stroke2,tw2,{Color=COLOR_ON}):Play();ts:Create(nameLabel2,tw2,{TextColor3=COLOR_ON}):Play()
				pcall(entry.fn,a1,a2)
				task.delay(0.4,function()
					ts:Create(stroke2,tw2,{Color=COLOR_OFF}):Play();ts:Create(nameLabel2,tw2,{TextColor3=COLOR_OFF}):Play()
				end)
			end)
		end
		hud={
			show=function() build2();frame2.Visible=true end,
			hide=function() if frame2 then frame2.Visible=false end end,
			showOff=function() build2();frame2.Visible=true end,
			destroy=function() if frame2 then frame2:Destroy();frame2=nil end;built2=false end,
		}
	end
	hudYOffset+=50;hud.showOff();dynamicHuds[key]=hud
end
DC.removeButton=function(alias,a1)
	local key=(alias or ""):lower()..(a1 and ("_"..a1) or "")
	local hud=dynamicHuds[key];if not hud then return end;hud.destroy();dynamicHuds[key]=nil
end

local sg2=_N("ScreenGui",game.CoreGui)
task.wait();sg2.Name="NNGui2";sg2.ResetOnSpawn=false;sg2.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;sg2.IgnoreGuiInset=true;sg2.Enabled=false
local pickerOpen=false;local warnOpen=false
local overlay,pickerFrame,titleLabel,subtitleLabel,closeBtn2,btnContainer2;local pickerBuilt=false
local function buildPicker()
	if pickerBuilt then return end;pickerBuilt=true
	overlay=_N("Frame",sg2);overlay.Size=_U(1,0,1,0);overlay.BackgroundTransparency=1;overlay.BackgroundColor3=_C(0,0,0);overlay.ZIndex=20;overlay.Visible=false
	pickerFrame=_N("Frame",overlay);pickerFrame.Size=_U(0,0,0,0);pickerFrame.Position=_U(0.5,0,0.42,0);pickerFrame.AnchorPoint=Vector2.new(0.5,0.5)
	pickerFrame.BackgroundColor3=_C(13,13,18);pickerFrame.ClipsDescendants=true;pickerFrame.ZIndex=21
	_N("UICorner",pickerFrame).CornerRadius=UDim.new(0,16)
	local pfStroke=_N("UIStroke",pickerFrame);pfStroke.Color=_C(0,170,255);pfStroke.Thickness=1.5
	local pfGrad=_N("UIGradient",pickerFrame)
	pfGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,_C(20,20,30)),ColorSequenceKeypoint.new(1,_C(13,13,18))};pfGrad.Rotation=90
	titleLabel=_N("TextLabel",pickerFrame);titleLabel.Size=_U(1,-40,0,36);titleLabel.BackgroundTransparency=1
	titleLabel.Text="";titleLabel.TextColor3=_C(255,255,255);titleLabel.Font=_GB;titleLabel.TextSize=13;titleLabel.ZIndex=22
	local titleGrad=_N("UIGradient",titleLabel)
	titleGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,_C(255,255,255)),ColorSequenceKeypoint.new(1,_C(0,170,255))}
	closeBtn2=_N("TextButton",pickerFrame);closeBtn2.Size=_U(0,26,0,26);closeBtn2.Position=_U(1,-32,0,5)
	closeBtn2.AnchorPoint=Vector2.new(1,0);closeBtn2.BackgroundColor3=_C(50,15,15);closeBtn2.Text="✕"
	closeBtn2.TextColor3=_C(255,80,80);closeBtn2.Font=_GB;closeBtn2.TextSize=13;closeBtn2.AutoButtonColor=false;closeBtn2.ZIndex=26
	_N("UICorner",closeBtn2).CornerRadius=UDim.new(0,8)
	local cTw=TweenInfo.new(0.12)
	closeBtn2.MouseEnter:Connect(function() ts:Create(closeBtn2,cTw,{BackgroundColor3=_C(90,20,20)}):Play() end)
	closeBtn2.MouseLeave:Connect(function() ts:Create(closeBtn2,cTw,{BackgroundColor3=_C(50,15,15)}):Play() end)
	local divider=_N("Frame",pickerFrame);divider.Size=_U(1,-32,0,1);divider.Position=_U(0,16,0,36)
	divider.BackgroundColor3=_C(40,40,55);divider.BorderSizePixel=0;divider.ZIndex=22
	btnContainer2=_N("Frame",pickerFrame);btnContainer2.Size=_U(1,-32,0,70);btnContainer2.Position=_U(0,16,0,45);btnContainer2.BackgroundTransparency=1;btnContainer2.ZIndex=22
	local btnLayout=_N("UIListLayout",btnContainer2)
	btnLayout.FillDirection=Enum.FillDirection.Horizontal;btnLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
	btnLayout.VerticalAlignment=Enum.VerticalAlignment.Center;btnLayout.Padding=UDim.new(0,14)
	subtitleLabel=_N("TextLabel",pickerFrame);subtitleLabel.Size=_U(1,0,0,20);subtitleLabel.Position=_U(0,0,1,-22)
	subtitleLabel.BackgroundTransparency=1;subtitleLabel.Text="";subtitleLabel.TextColor3=_C(60,60,80);subtitleLabel.Font=_GS;subtitleLabel.TextSize=10;subtitleLabel.ZIndex=22
end
local function makePickerBtn(parent,label,sub,accent)
	local btn2=_N("TextButton",parent);btn2.Size=_U(0,148,0,62);btn2.BackgroundColor3=_C(18,18,26);btn2.AutoButtonColor=false;btn2.Text="";btn2.ZIndex=23
	_N("UICorner",btn2).CornerRadius=UDim.new(0,12)
	local bs=_N("UIStroke",btn2);bs.Color=accent;bs.Thickness=1.2
	local icon=_N("TextLabel",btn2);icon.Size=_U(1,0,0,28);icon.Position=_U(0,0,0,8)
	icon.BackgroundTransparency=1;icon.Text=label;icon.TextColor3=_C(255,255,255);icon.Font=_GB;icon.TextSize=12;icon.ZIndex=24
	local subL=_N("TextLabel",btn2);subL.Size=_U(1,-16,0,18);subL.Position=_U(0,8,0,34)
	subL.BackgroundTransparency=1;subL.Text=sub;subL.TextColor3=_C(120,120,140);subL.Font=_GS;subL.TextSize=10;subL.ZIndex=24
	local bar=_N("Frame",btn2);bar.Size=_U(1,-24,0,2);bar.Position=_U(0,12,1,-10)
	bar.BackgroundColor3=accent;bar.BorderSizePixel=0;bar.ZIndex=24;_N("UICorner",bar).CornerRadius=UDim.new(1,0)
	local tw=TweenInfo.new(0.15)
	btn2.MouseEnter:Connect(function() ts:Create(btn2,tw,{BackgroundColor3=_C(24,24,36)}):Play();ts:Create(bs,tw,{Thickness=2}):Play() end)
	btn2.MouseLeave:Connect(function() ts:Create(btn2,tw,{BackgroundColor3=_C(18,18,26)}):Play();ts:Create(bs,tw,{Thickness=1.2}):Play() end)
	return btn2
end
local BTN_W,BTN_GAP,SIDE_PAD=148,14,32
local function calcWidth(n) return n*BTN_W+(n-1)*BTN_GAP+SIDE_PAD end
local function showPicker(pickerDef,callback)
	if pickerOpen then return end;pickerOpen=true;buildPicker()
	titleLabel.Text=pickerDef.title or "";subtitleLabel.Text=pickerDef.subtitle or ""
	for _,c in ipairs(btnContainer2:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
	local items={}
	for _,def in ipairs(pickerDef.buttons) do
		local b=makePickerBtn(btnContainer2,def.label,def.sub,def.accent);items[#items+1]={btn=b,value=def.value}
	end
	local TARGET=_U(0,calcWidth(#pickerDef.buttons),0,140)
	overlay.Visible=true;pickerFrame.Size=_U(0,0,0,0)
	ts:Create(overlay,TweenInfo.new(0.2),{BackgroundTransparency=0.6}):Play()
	ts:Create(pickerFrame,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=TARGET}):Play()
	local conns={}
	local function pick(value)
		if not pickerOpen then return end;pickerOpen=false
		for _,c in ipairs(conns) do c:Disconnect() end
		ts:Create(overlay,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play()
		ts:Create(pickerFrame,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=_U(0,0,0,0)}):Play()
		task.delay(0.28,function() overlay.Visible=false;callback(value) end)
	end
	conns[#conns+1]=closeBtn2.MouseButton1Click:Connect(function() pick(nil) end)
	for _,item in ipairs(items) do local v=item.value;conns[#conns+1]=item.btn.MouseButton1Click:Connect(function() pick(v) end) end
end
DC._showPicker=showPicker
local warnOverlay,warnFrame,cancelBtn,continueBtn;local warnBuilt=false
local function buildWarn()
	if warnBuilt then return end;warnBuilt=true
	warnOverlay=_N("Frame",sg2);warnOverlay.Size=_U(1,0,1,0);warnOverlay.BackgroundTransparency=1;warnOverlay.BackgroundColor3=_C(0,0,0);warnOverlay.ZIndex=30;warnOverlay.Visible=false
	warnFrame=_N("Frame",warnOverlay);warnFrame.Size=_U(0,0,0,0);warnFrame.Position=_U(0.5,0,0.42,0)
	warnFrame.AnchorPoint=Vector2.new(0.5,0.5);warnFrame.BackgroundColor3=_C(13,13,18);warnFrame.ClipsDescendants=true;warnFrame.ZIndex=31
	_N("UICorner",warnFrame).CornerRadius=UDim.new(0,16)
	local wfStroke=_N("UIStroke",warnFrame);wfStroke.Color=_C(220,80,80);wfStroke.Thickness=1.5
	local wfGrad=_N("UIGradient",warnFrame)
	wfGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,_C(25,15,15)),ColorSequenceKeypoint.new(1,_C(13,13,18))};wfGrad.Rotation=90
	local warnIcon=_N("TextLabel",warnFrame);warnIcon.Size=_U(1,0,0,40);warnIcon.Position=_U(0,0,0,16)
	warnIcon.BackgroundTransparency=1;warnIcon.Text="⚠";warnIcon.TextColor3=_C(255,180,0);warnIcon.Font=_GB;warnIcon.TextSize=28;warnIcon.ZIndex=32
	local warnTitle=_N("TextLabel",warnFrame);warnTitle.Size=_U(1,-32,0,22);warnTitle.Position=_U(0,16,0,58)
	warnTitle.BackgroundTransparency=1;warnTitle.Text="HOOK WARNING";warnTitle.TextColor3=_C(255,80,80)
	warnTitle.Font=_GB;warnTitle.TextSize=13;warnTitle.TextXAlignment=Enum.TextXAlignment.Center;warnTitle.ZIndex=32
	local wfTitleGrad=_N("UIGradient",warnTitle)
	wfTitleGrad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,_C(255,100,100)),ColorSequenceKeypoint.new(1,_C(255,60,60))}
	local warnDivider=_N("Frame",warnFrame);warnDivider.Size=_U(1,-32,0,1);warnDivider.Position=_U(0,16,0,86)
	warnDivider.BackgroundColor3=_C(80,30,30);warnDivider.BorderSizePixel=0;warnDivider.ZIndex=32
	local warnBody=_N("TextLabel",warnFrame);warnBody.Size=_U(1,-32,0,80);warnBody.Position=_U(0,16,0,96)
	warnBody.BackgroundTransparency=1
	warnBody.Text="This script uses hooking methods that may\nbe detected by some games.\n\nYour account could be at risk. It is\nrecommended to test this using an\nalternate account first."
	warnBody.TextColor3=_C(200,180,180);warnBody.Font=_GS;warnBody.TextSize=12;warnBody.TextXAlignment=Enum.TextXAlignment.Center;warnBody.TextWrapped=true;warnBody.ZIndex=32
	local warnBtnRow=_N("Frame",warnFrame);warnBtnRow.Size=_U(1,-32,0,42);warnBtnRow.Position=_U(0,16,0,184);warnBtnRow.BackgroundTransparency=1;warnBtnRow.ZIndex=32
	local wbLayout=_N("UIListLayout",warnBtnRow)
	wbLayout.FillDirection=Enum.FillDirection.Horizontal;wbLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
	wbLayout.VerticalAlignment=Enum.VerticalAlignment.Center;wbLayout.Padding=UDim.new(0,12)
	local function makeWarnBtn(label,bg2,fg)
		local wbtn=_N("TextButton",warnBtnRow);wbtn.Size=_U(0,130,0,36);wbtn.BackgroundColor3=bg2
		wbtn.AutoButtonColor=false;wbtn.Text=label;wbtn.TextColor3=fg;wbtn.Font=_GB;wbtn.TextSize=13;wbtn.ZIndex=33
		_N("UICorner",wbtn).CornerRadius=UDim.new(0,10)
		local tw=TweenInfo.new(0.12);local darken=_C(bg2.R*200,bg2.G*200,bg2.B*200)
		wbtn.MouseEnter:Connect(function() ts:Create(wbtn,tw,{BackgroundColor3=darken}):Play() end)
		wbtn.MouseLeave:Connect(function() ts:Create(wbtn,tw,{BackgroundColor3=bg2}):Play() end)
		return wbtn
	end
	cancelBtn  =makeWarnBtn("Cancel",  _C(35,35,45),_C(180,180,200))
	continueBtn=makeWarnBtn("Continue",_C(180,40,40),_C(255,255,255))
end
local function showHookWarn(callback)
	if not hookSupported then
		if UI_Notif then UI_Notif.Notify({Title="No Name",Content="Hook not supported by your executor",Duration=5}) end
		return
	end
	if warnOpen then return end;warnOpen=true;buildWarn()
	warnOverlay.Visible=true;warnFrame.Size=_U(0,0,0,0)
	ts:Create(warnOverlay,TweenInfo.new(0.2),{BackgroundTransparency=0.55}):Play()
	ts:Create(warnFrame,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=_U(0,320,0,240)}):Play()
	local conns={}
	local function close(proceed)
		if not warnOpen then return end;warnOpen=false
		for _,c in ipairs(conns) do c:Disconnect() end
		ts:Create(warnOverlay,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play()
		ts:Create(warnFrame,TweenInfo.new(0.22,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=_U(0,0,0,0)}):Play()
		task.delay(0.25,function() warnOverlay.Visible=false;if proceed then callback() end end)
	end
	conns[#conns+1]=continueBtn.MouseButton1Click:Connect(function() close(true) end)
	conns[#conns+1]=cancelBtn.MouseButton1Click:Connect(function() close(false) end)
end
local function makeACGui()
local UIS2=Services.UserInputService;local GS=Services.GuiService
	if p.PlayerGui:FindFirstChild("AC_Panel")then p.PlayerGui.AC_Panel:Destroy()end
	local function mk(c,pa,r)local o=_N(c,pa)for k,v in pairs(r or{})do o[k]=v end return o end
	local function cor(pa,r)mk("UICorner",pa,{CornerRadius=UDim.new(0,r or 6)})end
	local function str(pa,c,t2)mk("UIStroke",pa,{Color=c,Thickness=t2 or 1})end
	local SG3=mk("ScreenGui",p.PlayerGui,{Name="AC_Panel",ResetOnSpawn=false})
	local F=mk("Frame",SG3,{Size=_U(0,180,0,195),Position=_U(0.5,-90,0.5,-97),BackgroundColor3=_C(25,25,25),Active=true,Draggable=true})
	cor(F,8);str(F,_C(0,170,255),2)
	mk("TextLabel",F,{Size=_U(1,0,0,30),BackgroundTransparency=1,Text="AUTO CLICKER",TextColor3=_C(0,170,255),Font=_GB,TextSize=14})
	local X=mk("TextButton",F,{Size=_U(0,30,0,30),Position=_U(1,-30,0,0),BackgroundTransparency=1,Text="❌",TextSize=11,TextColor3=_C(200,200,200)})
	mk("Frame",F,{Size=_U(1,0,0,1),Position=_U(0,0,0,30),BackgroundColor3=_C(0,170,255),BorderSizePixel=0})
	local MB=mk("TextButton",F,{Size=_U(0.9,0,0,25),Position=_U(0.05,0,0,40),BackgroundColor3=_C(35,35,35),Text="Mode: Mobile",TextColor3=_C(255,255,255),Font=_GS,TextSize=13})
	cor(MB);local mS=mk("UIStroke",MB,{Color=_C(100,100,100),Thickness=1})
	local SB=mk("TextBox",F,{Size=_U(0.9,0,0,25),Position=_U(0.05,0,0,72),BackgroundColor3=_C(20,20,20),Text="0.3",PlaceholderText="Delay (0.3)",TextColor3=_C(220,220,220),Font=_GS,TextSize=13})
	cor(SB);str(SB,_C(60,60,80))
	local PB=mk("TextButton",F,{Size=_U(0.9,0,0,32),Position=_U(0.05,0,0,105),BackgroundColor3=_C(35,35,35),Text="Set Target",TextColor3=_C(220,220,220),Font=_GS,TextSize=13})
	cor(PB)
	local S=mk("TextButton",F,{Size=_U(0.9,0,0,36),Position=_U(0.05,0,0,145),BackgroundColor3=_C(220,70,70),Text="OFF",TextColor3=_C(255,255,255),Font=_GB,TextSize=18})
	cor(S);local bS=mk("UIStroke",S,{Color=_C(220,70,70),Thickness=1.5})
	local M=mk("Frame",SG3,{Size=_U(0,14,0,14),BackgroundColor3=_C(80,220,120),Visible=false,AnchorPoint=Vector2.new(0.5,0.5)})
	cor(M,99);str(M,_C(0,0,0))
	local picking=false
	X.MouseButton1Click:Connect(function() AC.active=false;SG3:Destroy() end)
	MB.MouseButton1Click:Connect(function() AC.mode=AC.mode=="Mobile"and"PC"or"Mobile";MB.Text="Mode: "..AC.mode;mS.Color=AC.mode=="PC"and _C(0,170,255)or _C(100,100,100) end)
	SB.FocusLost:Connect(function() local v=tonumber(SB.Text);AC.delay=(v and v>=0)and v or AC.delay;SB.Text=tostring(AC.delay) end)
	PB.MouseButton1Click:Connect(function() picking=true;PB.Text="Tap/Click Target...";PB.TextColor3=_C(0,170,255) end)
	UIS2.InputBegan:Connect(function(i,g)
		if picking and not g and(i.UserInputType.Name=="Touch"or i.UserInputType.Name=="MouseButton1")then
			AC.target=Vector2.new(i.Position.X,i.Position.Y+GS:GetGuiInset().Y)
			M.Position=_U(0,i.Position.X,0,i.Position.Y);M.Visible=true;picking=false
			PB.Text="Target Locked";PB.TextColor3=_C(220,220,220)
		end
	end)
	S.MouseButton1Click:Connect(function()
		AC.active=not AC.active;S.Text=AC.active and"ON"or"OFF"
		S.BackgroundColor3=AC.active and _C(80,220,120)or _C(220,70,70);bS.Color=AC.active and _C(80,220,120)or _C(220,70,70)
		if AC.active then startAutoClick() else stopAutoClick() end
	end)
end
local function makePingGui()
	local ST=Services.Stats
	if p.PlayerGui:FindFirstChild("HUD_Ping")then p.PlayerGui.HUD_Ping:Destroy()end
	local function mk(c,pa,r)local o=_N(c,pa)for k,v in pairs(r or{})do o[k]=v end return o end
	local SG3=mk("ScreenGui",p.PlayerGui,{Name="HUD_Ping",ResetOnSpawn=false})
	local F=mk("Frame",SG3,{Size=_U(0,110,0,24),Position=_U(0.5,-55,0,50),BackgroundColor3=_C(15,15,20),Active=true,Draggable=true})
	mk("UICorner",F,{CornerRadius=UDim.new(0,6)});mk("UIStroke",F,{Color=_C(0,170,255),Thickness=1.5})
	local T=mk("TextLabel",F,{Size=_U(1,-24,1,0),Position=_U(0,8,0,0),BackgroundTransparency=1,TextColor3=_C(0,170,255),Font=_GB,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})
	local X=mk("TextButton",F,{Size=_U(0,24,1,0),Position=_U(1,-24,0,0),BackgroundTransparency=1,Text="❌",TextSize=9,TextColor3=_C(200,200,200)})
	X.MouseButton1Click:Connect(function()SG3:Destroy()end)
	local c;c=rs.Heartbeat:Connect(function()
		if not T.Parent then c:Disconnect();return end
		local ping="0"
		pcall(function()ping=string.match(ST.Network.ServerStatsItem["Data Ping"]:GetValueString(),"%d+")or"0"end)
		T.Text="Ping: "..ping.."ms"
	end)
end
Cmd.add({"ping"}, {fn=function() end})

local function makeFpsGui()
	if p.PlayerGui:FindFirstChild("HUD_FPS")then p.PlayerGui.HUD_FPS:Destroy()end
	local function mk(c,pa,r)local o=_N(c,pa)for k,v in pairs(r or{})do o[k]=v end return o end
	local SG3=mk("ScreenGui",p.PlayerGui,{Name="HUD_FPS",ResetOnSpawn=false})
	local F=mk("Frame",SG3,{Size=_U(0,80,0,24),Position=_U(0.5,-40,0,20),BackgroundColor3=_C(15,15,20),Active=true,Draggable=true})
	mk("UICorner",F,{CornerRadius=UDim.new(0,6)});mk("UIStroke",F,{Color=_C(0,170,255),Thickness=1.5})
	local T=mk("TextLabel",F,{Size=_U(1,-24,1,0),Position=_U(0,8,0,0),BackgroundTransparency=1,TextColor3=_C(0,170,255),Font=_GB,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})
	local X=mk("TextButton",F,{Size=_U(0,24,1,0),Position=_U(1,-24,0,0),BackgroundTransparency=1,Text="❌",TextSize=9,TextColor3=_C(200,200,200)})
	X.MouseButton1Click:Connect(function()SG3:Destroy()end)
	local c;c=rs.RenderStepped:Connect(function(d)
		if not T.Parent then c:Disconnect();return end
		T.Text="FPS: "..math.round(1/d)
	end)
end
Cmd.add({"fps"}, {fn=function() end})

local function makeStatsGui()
local ST=Services.Stats
	if p.PlayerGui:FindFirstChild("HUD_All")then p.PlayerGui.HUD_All:Destroy()end
	local function mk(c,pa,r)local o=_N(c,pa)for k,v in pairs(r or{})do o[k]=v end return o end
	local SG3=mk("ScreenGui",p.PlayerGui,{Name="HUD_All",ResetOnSpawn=false})
	local F=mk("Frame",SG3,{Size=_U(0,150,0,24),Position=_U(0.5,-75,0,20),BackgroundColor3=_C(15,15,20),Active=true,Draggable=true})
	mk("UICorner",F,{CornerRadius=UDim.new(0,6)});mk("UIStroke",F,{Color=_C(0,170,255),Thickness=1.5})
	local T=mk("TextLabel",F,{Size=_U(1,-24,1,0),Position=_U(0,8,0,0),BackgroundTransparency=1,TextColor3=_C(0,170,255),Font=_GB,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})
	local X=mk("TextButton",F,{Size=_U(0,24,1,0),Position=_U(1,-24,0,0),BackgroundTransparency=1,Text="❌",TextSize=9,TextColor3=_C(200,200,200)})
	X.MouseButton1Click:Connect(function()SG3:Destroy()end)
	local c;c=rs.RenderStepped:Connect(function(d)
		if not T.Parent then c:Disconnect();return end
		local ping="0"
		pcall(function()ping=string.match(ST.Network.ServerStatsItem["Data Ping"]:GetValueString(),"%d+")or"0"end)
		T.Text="FPS: "..math.round(1/d).." | Ping: "..ping.."ms"
	end)
end
Cmd.add({"stats"}, {args="(fps & ping)", fn=function() end})

for _,e in ipairs(Cmds) do for _,a in ipairs(e.aliases) do
	if a=="autoclicker" then local o=e.fn;e.fn=function() makeACGui();o() end;break end
end end
for _,e in ipairs(Cmds) do for _,a in ipairs(e.aliases) do
	if a=="stats" then local o=e.fn;e.fn=function() makeStatsGui();o() end;break end
end end
for _,e in ipairs(Cmds) do for _,a in ipairs(e.aliases) do
	if a=="ping" then local o=e.fn;e.fn=function() makePingGui();o() end;break end
end end
for _,e in ipairs(Cmds) do for _,a in ipairs(e.aliases) do
	if a=="fps" then local o=e.fn;e.fn=function() makeFpsGui();o() end;break end
end end
DC.showHookWarn=showHookWarn
task.wait()
local aliasMap2={}
for _,entry in ipairs(Cmds) do
	for _,alias in ipairs(entry.aliases) do aliasMap2[alias]=entry end
end
task.wait()
for _,entry in ipairs(Cmds) do
	local pickerDef=entry.picker
	if pickerDef then
		local capturedEntry=entry
		if pickerDef.hookOnValue then
			capturedEntry.fn=function()
				task.delay(0.32,function()
					showPicker(pickerDef,function(value)
						if value==nil then return end
						if value==pickerDef.hookOnValue then showHookWarn(function() pickerDef.onPick(value) end)
						else pickerDef.onPick(value) end
					end)
				end)
			end
		else
			capturedEntry.fn=function()
				task.delay(0.32,function()
					showPicker(pickerDef,function(value) if value~=nil then pickerDef.onPick(value) end end)
				end)
			end
		end
		if pickerDef.stopAlias and pickerDef.stopFn then
			local stopEntry=aliasMap2[pickerDef.stopAlias]
			if stopEntry then stopEntry.fn=pickerDef.stopFn end
		end
	end
end
task.wait()
for _,entry in ipairs(Cmds) do
	if entry.hook and entry.fn and not entry.picker then
		local orig=entry.fn;entry.fn=function(...) local args={...};showHookWarn(function() orig(table.unpack(args)) end) end
	end
end
task.wait()
repeat task.wait() until loaderDone
if not hookSupported and UI_Notif then
	UI_Notif.Notify({Title="No Name",Content="Executor not supported, hook commands disabled",Duration=5})
end
sg.Enabled=true
sg2.Enabled=true
end
task.spawn(initLoader)