local _nnEnv = _G or {}
if type(getgenv) == "function" then
	local ok, env = pcall(getgenv)
	if ok and type(env) == "table" then _nnEnv = env end
end

local function _nnRef(svc)
	if not game or type(game.GetService) ~= "function" then return nil end
	local ok, s = pcall(game.GetService, game, svc)
	if not ok or not s then return nil end
	if cloneref and type(cloneref) == "function" then
		local ok2, r = pcall(cloneref, s)
		if ok2 and r then return r end
	end
	return s
end

local Players     = _nnRef("Players")
local TweenService = _nnRef("TweenService")

if not Players then error("NNNotify: Players service unavailable", 2) end
if not TweenService then error("NNNotify: TweenService unavailable", 2) end
if type(task) ~= "table" or type(task.spawn) ~= "function" or type(task.delay) ~= "function" then error("NNNotify: task library unavailable", 2) end

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then error("NNNotify: LocalPlayer unavailable", 2) end
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

local function _nnPickParent()
	if gethui and type(gethui) == "function" then
		local ok, h = pcall(gethui)
		if ok and type(typeof) == "function" and typeof(h) == "Instance" then return h end
	end
	local cg = _nnRef("CoreGui")
	if cg then
		local rg = cg:FindFirstChild("RobloxGui")
		if rg then return rg end
		return cg
	end
	return PlayerGui
end

local function _nnProtect(gui)
	if type(syn) == "table" and type(syn.protect_gui) == "function" then
		pcall(syn.protect_gui, gui)
	elseif protect_gui and type(protect_gui) == "function" then
		pcall(protect_gui, gui)
	end
	return gui
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NNNotifGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_nnProtect(ScreenGui)
ScreenGui.Parent = _nnPickParent()

local NOTIF_WIDTH = 300
local NOTIF_HEIGHT = 76
local NOTIF_HEIGHT_BTN = 108
local GAP = 8
local SIDE_PADDING = 16
local BOTTOM_PADDING = 24
local activeNotifs = {}

local function getFrameHeight(btnCount)
	return btnCount > 0 and NOTIF_HEIGHT_BTN or NOTIF_HEIGHT
end

local THEME = {
	bg = Color3.fromRGB(15, 15, 15),
	border = Color3.fromRGB(50, 50, 50),
	accent = Color3.fromRGB(255, 255, 255),
	btnBg = Color3.fromRGB(30, 30, 30),
	btnHover = Color3.fromRGB(255, 255, 255),
	btnText = Color3.fromRGB(160, 160, 160),
	btnTextHover = Color3.fromRGB(0, 0, 0),
	titleColor = Color3.fromRGB(255, 255, 255),
	textColor = Color3.fromRGB(140, 140, 140),
	iconBg = Color3.fromRGB(25, 25, 25),
	progressBg = Color3.fromRGB(35, 35, 35),
}

local function getSlotPos(index)
	local totalOffset = 0
	for i = 1, index - 1 do
		local d = activeNotifs[i]
		local dh = d and d.frameHeight or NOTIF_HEIGHT
		totalOffset = totalOffset + dh + GAP
	end
	local h = activeNotifs[index] and activeNotifs[index].frameHeight or NOTIF_HEIGHT
	return UDim2.new(1, -(NOTIF_WIDTH + SIDE_PADDING), 1, -(h + BOTTOM_PADDING) - totalOffset)
end

local function repositionAll()
	local totalOffset = 0
	for i, data in ipairs(activeNotifs) do
		local frameHeight = data and data.frameHeight or NOTIF_HEIGHT
		local pos = UDim2.new(1, -(NOTIF_WIDTH + SIDE_PADDING), 1, -(frameHeight + BOTTOM_PADDING) - totalOffset)
		if data and data.frame and data.frame.Parent then
			TweenService:Create(data.frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position = pos
			}):Play()
		end
		totalOffset = totalOffset + frameHeight + GAP
	end
end

local function dismissNotif(frame, data)
	if not data or data.dismissed then return end
	data.dismissed = true

	if not frame or not frame.Parent then
		for i, d in ipairs(activeNotifs) do
			if d.frame == frame then
				table.remove(activeNotifs, i)
				break
			end
		end
		repositionAll()
		return
	end

	local idx = nil
	for i, d in ipairs(activeNotifs) do
		if d.frame == frame then idx = i break end
	end

	local currentPos = frame.Position
	local exitPos = UDim2.new(1, NOTIF_WIDTH + 30, currentPos.Y.Scale, currentPos.Y.Offset)
	local tween = TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
		Position = exitPos
	})
	tween:Play()
	tween.Completed:Connect(function()
		for i, d in ipairs(activeNotifs) do
			if d.frame == frame then
				table.remove(activeNotifs, i)
				break
			end
		end
		frame:Destroy()
		repositionAll()
	end)
end

local function createNotif(config)
	if type(config) ~= "table" then config = {} end
	local title = config.Title or "Notification"
	local text = config.Text or ""
	local duration = config.Duration or 4
	local buttons = config.Buttons or {}
	if type(title) ~= "string" then title = tostring(title) end
	if type(text) ~= "string" then text = tostring(text) end
	if type(duration) ~= "number" or duration ~= duration or duration < 0 then duration = 4 end
	if type(buttons) ~= "table" then buttons = {} end
	if #buttons > 2 then buttons = { buttons[1], buttons[2] } end
	local btnCount = #buttons

	local frameHeight = getFrameHeight(btnCount)

	local frame = Instance.new("Frame")
	frame.Name = "NNNotif"
	frame.Size = UDim2.new(0, NOTIF_WIDTH, 0, frameHeight)
	frame.Position = UDim2.new(1, NOTIF_WIDTH + 30, 1, -(frameHeight + BOTTOM_PADDING))
	frame.BackgroundColor3 = THEME.bg
	frame.BorderSizePixel = 0
	frame.ZIndex = 10
	frame.Parent = ScreenGui

	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

	local stroke = Instance.new("UIStroke")
	stroke.Color = THEME.border
	stroke.Thickness = 1
	stroke.Transparency = 0.3
	stroke.Parent = frame

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 20, 0, 20)
	closeBtn.Position = UDim2.new(1, -26, 0, 8)
	closeBtn.BackgroundTransparency = 1
	closeBtn.BorderSizePixel = 0
	closeBtn.Text = "×"
	closeBtn.TextColor3 = Color3.fromRGB(80, 80, 80)
	closeBtn.TextSize = 14
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.ZIndex = 13
	closeBtn.Parent = frame

	closeBtn.MouseEnter:Connect(function()
		TweenService:Create(closeBtn, TweenInfo.new(0.15), {
			TextColor3 = Color3.fromRGB(200, 200, 200)
		}):Play()
	end)

	closeBtn.MouseLeave:Connect(function()
		TweenService:Create(closeBtn, TweenInfo.new(0.15), {
			TextColor3 = Color3.fromRGB(80, 80, 80)
		}):Play()
	end)

	local iconFrame = Instance.new("Frame")
	iconFrame.Size = UDim2.new(0, 36, 0, 36)
	iconFrame.Position = UDim2.new(0, 20, 0, 14)
	iconFrame.BackgroundColor3 = THEME.iconBg
	iconFrame.BorderSizePixel = 0
	iconFrame.ZIndex = 11
	iconFrame.ClipsDescendants = true
	iconFrame.Parent = frame
	Instance.new("UICorner", iconFrame).CornerRadius = UDim.new(1, 0)

	local iconImage = Instance.new("ImageLabel")
	iconImage.Size = UDim2.new(1, 0, 1, 0)
	iconImage.BackgroundTransparency = 1
	iconImage.ZIndex = 12
	iconImage.Parent = iconFrame
	Instance.new("UICorner", iconImage).CornerRadius = UDim.new(1, 0)

	task.spawn(function()
		local ok, thumb = pcall(function()
			return Players:GetUserThumbnailAsync(
				LocalPlayer.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size48x48
			)
		end)
		if ok and type(thumb) == "string" and iconImage.Parent then iconImage.Image = thumb end
	end)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -74, 0, 16)
	titleLabel.Position = UDim2.new(0, 64, 0, 14)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = THEME.titleColor
	titleLabel.TextSize = 13
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	titleLabel.ZIndex = 12
	titleLabel.Parent = frame

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -74, 0, 22)
	textLabel.Position = UDim2.new(0, 64, 0, 32)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text
	textLabel.TextColor3 = THEME.textColor
	textLabel.TextSize = 11
	textLabel.Font = Enum.Font.Gotham
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextWrapped = true
	textLabel.ZIndex = 12
	textLabel.Parent = frame

	local data = { frame = frame, frameHeight = frameHeight, dismissed = false }
	table.insert(activeNotifs, data)

	closeBtn.MouseButton1Click:Connect(function()
		dismissNotif(frame, data)
	end)

	if btnCount > 0 then
		local divider = Instance.new("Frame")
		divider.Size = UDim2.new(1, 0, 0, 1)
		divider.Position = UDim2.new(0, 0, 0, 58)
		divider.BackgroundColor3 = THEME.border
		divider.BorderSizePixel = 0
		divider.ZIndex = 11
		divider.Parent = frame

		for i, btnConfig in ipairs(buttons) do
			if type(btnConfig) ~= "table" then btnConfig = {} end
			local btnText = btnConfig.Text or "Button"
			if type(btnText) ~= "string" then btnText = tostring(btnText) end
			local btnW = btnCount == 2 and 0.5 or 1
			local btnX = btnCount == 2 and (i - 1) * 0.5 or 0

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(btnW, 0, 0, 34)
			btn.Position = UDim2.new(btnX, 0, 0, 59)
			btn.BackgroundTransparency = 1
			btn.BorderSizePixel = 0
			btn.Text = btnText
			btn.TextColor3 = THEME.btnText
			btn.TextSize = 12
			btn.Font = Enum.Font.GothamBold
			btn.ZIndex = 13
			btn.Parent = frame
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

			btn.MouseEnter:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.15), {
					BackgroundTransparency = 0.85,
					TextColor3 = THEME.titleColor
				}):Play()
			end)

			btn.MouseLeave:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.15), {
					BackgroundTransparency = 1,
					TextColor3 = THEME.btnText
				}):Play()
			end)

			btn.MouseButton1Click:Connect(function()
				if type(btnConfig.Callback) == "function" then
					local ok, err = pcall(btnConfig.Callback)
					if not ok then warn("NNNotify callback error: " .. tostring(err)) end
				end
				dismissNotif(frame, data)
			end)
		end

		if btnCount == 2 then
			local vDivider = Instance.new("Frame")
			vDivider.Size = UDim2.new(0, 1, 0, 34)
			vDivider.Position = UDim2.new(0.5, 0, 0, 59)
			vDivider.BackgroundColor3 = THEME.border
			vDivider.BorderSizePixel = 0
			vDivider.ZIndex = 12
			vDivider.Parent = frame
		end
	end

	local progressBg = Instance.new("Frame")
	progressBg.Size = UDim2.new(1, -20, 0, 3)
	progressBg.Position = UDim2.new(0, 10, 0, frameHeight - 10)
	progressBg.BackgroundColor3 = THEME.progressBg
	progressBg.BorderSizePixel = 0
	progressBg.ZIndex = 11
	progressBg.Parent = frame
	Instance.new("UICorner", progressBg).CornerRadius = UDim.new(1, 0)

	local progressBar = Instance.new("Frame")
	progressBar.Size = UDim2.new(1, 0, 1, 0)
	progressBar.BackgroundColor3 = THEME.accent
	progressBar.BorderSizePixel = 0
	progressBar.ZIndex = 12
	progressBar.Parent = progressBg
	Instance.new("UICorner", progressBar).CornerRadius = UDim.new(1, 0)

	local targetPos = getSlotPos(#activeNotifs)
	local bounceOver = UDim2.new(targetPos.X.Scale, targetPos.X.Offset - 12, targetPos.Y.Scale, targetPos.Y.Offset)
	local bounceBack = UDim2.new(targetPos.X.Scale, targetPos.X.Offset + 4, targetPos.Y.Scale, targetPos.Y.Offset)

	TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = bounceOver
	}):Play()
	task.delay(0.4, function()
		if data.dismissed or not frame.Parent then return end
		TweenService:Create(frame, TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = bounceBack
		}):Play()
	end)
	task.delay(0.53, function()
		if data.dismissed or not frame.Parent then return end
		TweenService:Create(frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = targetPos
		}):Play()
	end)

	TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
		Size = UDim2.new(0, 0, 1, 0)
	}):Play()

	task.delay(duration, function()
		dismissNotif(frame, data)
	end)
end

_nnEnv.NNNotify = createNotif
NNNotify = createNotif
