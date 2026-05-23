local _nnEnv = _G or {}
if type(getgenv) == "function" then
	local ok, env = pcall(getgenv)
	if ok and type(env) == "table" then _nnEnv = env end
end

local function _nnWarn(message)
	if type(warn) == "function" then warn(message) end
end

local function _nnSendInitErrorNotif()
	local okStarterGui, StarterGui = pcall(function()
		return game and game:GetService("StarterGui")
	end)
	if not okStarterGui or not StarterGui then return end
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "notif error",
			Text = "pls reexecute"
		})
	end)
end

local function _nnClock()
	if type(os) == "table" and type(os.clock) == "function" then return os.clock() end
	if type(time) == "function" then return time() end
	if type(tick) == "function" then return tick() end
	return 0
end

local _nnNow = _nnClock()
local _nnLock = _nnEnv.__NNNotifyExecutionLock
if type(_nnLock) == "table" then
	if _nnLock.permanent or _nnLock.loaded then
		_nnWarn("NNNotify: script already loaded")
		return _nnEnv.NNNotify
	end
	if _nnLock.initializing then
		_nnWarn("NNNotify: initialization lock active")
		return _nnEnv.NNNotify
	end
end

local _nnLockToken = tostring({}) .. ":" .. tostring(_nnNow)
_nnLock = {
	token = _nnLockToken,
	startedAt = _nnNow,
	initializing = true,
	loaded = false,
	permanent = false
}
_nnEnv.__NNNotifyExecutionLock = _nnLock

local function _nnInit()
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
	local RunService   = _nnRef("RunService")
	local HttpService  = _nnRef("HttpService")

	if not Players then error("NNNotify: Players service unavailable", 2) end
	if not TweenService then error("NNNotify: TweenService unavailable", 2) end
	if not RunService then error("NNNotify: RunService unavailable", 2) end
	if type(task) ~= "table" or type(task.spawn) ~= "function" or type(task.delay) ~= "function" then error("NNNotify: task library unavailable", 2) end

	local LocalPlayer = Players.LocalPlayer
	if not LocalPlayer then error("NNNotify: LocalPlayer unavailable", 2) end
	local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if not PlayerGui then
		local okPlayerGui, waitedPlayerGui = pcall(function()
			return LocalPlayer:WaitForChild("PlayerGui", 10)
		end)
		if okPlayerGui then PlayerGui = waitedPlayerGui end
	end

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

	local guiParent = _nnPickParent()
	if not guiParent then error("NNNotify: Gui parent unavailable", 2) end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "NNNotifGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	_nnProtect(ScreenGui)
	ScreenGui.Parent = guiParent
	local lockForGui = _nnEnv.__NNNotifyExecutionLock
	if type(lockForGui) == "table" and lockForGui.token == _nnLockToken then
		lockForGui.gui = ScreenGui
	end

	local NOTIF_WIDTH = 320
	local NOTIF_HEIGHT = 84
	local NOTIF_HEIGHT_BTN = 116
	local GAP = 8
	local SIDE_PADDING = 16
	local BOTTOM_PADDING = 24
	local activeNotifs = {}
	local DEFAULT_FONT = Enum.Font.GothamBold
	local FONT_OPTIONS = {
		{ Name = "GothamBold", Font = Enum.Font.GothamBold },
		{ Name = "Gotham", Font = Enum.Font.Gotham },
		{ Name = "SourceSansBold", Font = Enum.Font.SourceSansBold },
		{ Name = "ArialBold", Font = Enum.Font.ArialBold },
		{ Name = "Arcade", Font = Enum.Font.Arcade },
		{ Name = "Fantasy", Font = Enum.Font.Fantasy },
	}
	local FONT_FILE = "nnfont.json"

	local function getFontByName(name)
		if type(name) ~= "string" then return DEFAULT_FONT, "GothamBold" end
		for _, option in ipairs(FONT_OPTIONS) do
			if option.Name == name then
				return option.Font, option.Name
			end
		end
		return DEFAULT_FONT, "GothamBold"
	end

	local function canUseFontFile()
		return type(isfile) == "function" and type(readfile) == "function" and type(writefile) == "function"
	end

	local function loadSavedFont()
		if not canUseFontFile() or not HttpService then return DEFAULT_FONT, "GothamBold" end
		local okExists, exists = pcall(isfile, FONT_FILE)
		if not okExists or not exists then return DEFAULT_FONT, "GothamBold" end
		local okRead, content = pcall(readfile, FONT_FILE)
		if not okRead or type(content) ~= "string" or content == "" then return DEFAULT_FONT, "GothamBold" end
		local okDecode, decoded = pcall(function()
			return HttpService:JSONDecode(content)
		end)
		if okDecode and type(decoded) == "table" then
			return getFontByName(decoded.Font or decoded.font or decoded.Name or decoded.name)
		end
		return DEFAULT_FONT, "GothamBold"
	end

	local function saveFont(name)
		if not canUseFontFile() then return end
		local payload = '{"Font":"' .. tostring(name) .. '"}'
		if HttpService then
			local okEncode, encoded = pcall(function()
				return HttpService:JSONEncode({ Font = name })
			end)
			if okEncode and type(encoded) == "string" then payload = encoded end
		end
		pcall(writefile, FONT_FILE, payload)
	end

	local currentFont, currentFontName = loadSavedFont()
	saveFont(currentFontName)

	local function applyFont(font, targets)
		if type(typeof) ~= "function" or typeof(font) ~= "EnumItem" then font = DEFAULT_FONT end
		for _, obj in ipairs(targets) do
			if obj and obj.Parent then
				obj.Font = font
			end
		end
	end

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

	local function getNotifIndex(data)
		for i, d in ipairs(activeNotifs) do
			if d == data then return i end
		end
		return nil
	end

	local function ensureScreenGui()
		if ScreenGui and ScreenGui.Parent then return true end
		local parent = _nnPickParent()
		if not parent then return false end
		local ok = pcall(function()
			ScreenGui.Parent = parent
		end)
		return ok and ScreenGui.Parent ~= nil
	end

	local function releaseExecutionLock(notifyFunc)
		local lock = _nnEnv.__NNNotifyExecutionLock
		if type(lock) == "table" and lock.token == _nnLockToken then
			_nnEnv.__NNNotifyExecutionLock = nil
		end
		if notifyFunc == nil or _nnEnv.NNNotify == notifyFunc then
			_nnEnv.NNNotify = nil
		end
	end

	local function stopTween(tween)
		if tween then
			pcall(function()
				tween:Cancel()
			end)
		end
	end

	local function playFrameTween(data, tweenInfo, props)
		if not data or data.dismissed or not data.frame or not data.frame.Parent then return nil end
		data.positionToken = (data.positionToken or 0) + 1
		stopTween(data.positionTween)
		local tween = TweenService:Create(data.frame, tweenInfo, props)
		data.positionTween = tween
		tween:Play()
		return tween, data.positionToken
	end

	local function repositionAll()
		local totalOffset = 0
		for i, data in ipairs(activeNotifs) do
			local frameHeight = data and data.frameHeight or NOTIF_HEIGHT
			local pos = UDim2.new(1, -(NOTIF_WIDTH + SIDE_PADDING), 1, -(frameHeight + BOTTOM_PADDING) - totalOffset)
			if data and data.frame and data.frame.Parent and not data.dismissed then
				playFrameTween(data, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					Position = pos
				})
			end
			totalOffset = totalOffset + frameHeight + GAP
		end
	end

	local function dismissNotif(frame, data)
		if not data or data.dismissed then return end
		data.dismissed = true
		data.paused = true
		stopTween(data.positionTween)
		stopTween(data.dismissTween)

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

		local currentPos = frame.Position
		local exitPos = UDim2.new(1, NOTIF_WIDTH + 30, currentPos.Y.Scale, currentPos.Y.Offset)
		local tween = TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Position = exitPos
		})
		data.dismissTween = tween
		local completedConnection = nil
		completedConnection = tween.Completed:Connect(function()
			if completedConnection then
				completedConnection:Disconnect()
				completedConnection = nil
			end
			for i, d in ipairs(activeNotifs) do
				if d.frame == frame then
					table.remove(activeNotifs, i)
					break
				end
			end
			pcall(function()
				frame:Destroy()
			end)
			repositionAll()
		end)
		tween:Play()
	end

	local function createNotif(config)
		if not ensureScreenGui() then
			_nnWarn("NNNotify: ScreenGui unavailable")
			releaseExecutionLock(createNotif)
			return nil
		end
		if type(config) ~= "table" then config = {} end
		local title = config.Title or "Notification"
		local text = config.Text or ""
		local duration = config.Duration or 4
		local buttons = config.Buttons or {}
		if type(title) ~= "string" then title = tostring(title) end
		if type(text) ~= "string" then text = tostring(text) end
		if type(duration) ~= "number" or duration ~= duration or duration < 0 or duration == math.huge or duration == -math.huge then duration = 4 end
		if type(buttons) ~= "table" then buttons = {} end
		if #buttons > 2 then buttons = { buttons[1], buttons[2] } end
		local btnCount = #buttons
		local textTargets = {}

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
		closeBtn.Size = UDim2.new(0, 28, 0, 28)
		closeBtn.Position = UDim2.new(1, -34, 0, 6)
		closeBtn.BackgroundTransparency = 1
		closeBtn.BorderSizePixel = 0
		closeBtn.Text = ""
		closeBtn.ZIndex = 13
		closeBtn.Parent = frame

		local closeIcon = Instance.new("TextLabel")
		closeIcon.Size = UDim2.new(0, 42, 0, 42)
		closeIcon.Position = UDim2.new(0.5, -21, 0.5, -22)
		closeIcon.BackgroundTransparency = 1
		closeIcon.BorderSizePixel = 0
		closeIcon.Text = "×"
		closeIcon.TextColor3 = Color3.fromRGB(80, 80, 80)
		closeIcon.TextSize = 36
		closeIcon.Font = currentFont
		closeIcon.ZIndex = 14
		closeIcon.Parent = closeBtn
		table.insert(textTargets, closeIcon)

		closeBtn.MouseEnter:Connect(function()
			TweenService:Create(closeIcon, TweenInfo.new(0.15), {
				TextColor3 = Color3.fromRGB(200, 200, 200)
			}):Play()
		end)

		closeBtn.MouseLeave:Connect(function()
			TweenService:Create(closeIcon, TweenInfo.new(0.15), {
				TextColor3 = Color3.fromRGB(80, 80, 80)
			}):Play()
		end)

		local iconFrame = Instance.new("Frame")
		iconFrame.Size = UDim2.new(0, 36, 0, 36)
		iconFrame.Position = UDim2.new(0, 20, 0, 18)
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
		titleLabel.Size = UDim2.new(1, -142, 0, 16)
		titleLabel.Position = UDim2.new(0, 64, 0, 18)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = title
		titleLabel.TextColor3 = THEME.titleColor
		titleLabel.TextSize = 13
		titleLabel.Font = currentFont
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
		titleLabel.ZIndex = 12
		titleLabel.Parent = frame
		table.insert(textTargets, titleLabel)

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, -84, 0, 24)
		textLabel.Position = UDim2.new(0, 64, 0, 38)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = text
		textLabel.TextColor3 = THEME.textColor
		textLabel.TextSize = 11
		textLabel.Font = currentFont
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextWrapped = true
		textLabel.ZIndex = 12
		textLabel.Parent = frame
		table.insert(textTargets, textLabel)

		local data = { frame = frame, frameHeight = frameHeight, dismissed = false, paused = false, remaining = duration, duration = duration, buttonClicked = false, positionTween = nil, positionToken = 0, dismissTween = nil }
		table.insert(activeNotifs, data)

		closeBtn.MouseButton1Click:Connect(function()
			dismissNotif(frame, data)
		end)

		local function pauseTimer()
			if data.dismissed or data.paused then return end
			data.paused = true
		end

		local function resumeTimer()
			if data.dismissed or not data.paused then return end
			data.paused = false
		end

		local aaFrame = Instance.new("Frame")
		aaFrame.Size = UDim2.new(0, 26, 0, 26)
		aaFrame.Position = UDim2.new(1, -66, 0, 7)
		aaFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		aaFrame.BorderSizePixel = 0
		aaFrame.ZIndex = 13
		aaFrame.Parent = frame
		Instance.new("UICorner", aaFrame).CornerRadius = UDim.new(1, 0)

		local aaStroke = Instance.new("UIStroke")
		aaStroke.Color = Color3.fromRGB(255, 255, 255)
		aaStroke.Thickness = 1.25
		aaStroke.Transparency = 0.15
		aaStroke.Parent = aaFrame
		pcall(function() aaStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border end)

		local aaBtn = Instance.new("TextButton")
		aaBtn.Size = UDim2.new(1, 0, 1, 0)
		aaBtn.BackgroundTransparency = 1
		aaBtn.BorderSizePixel = 0
		aaBtn.Text = "Aa"
		aaBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		aaBtn.TextSize = 14
		aaBtn.Font = currentFont
		aaBtn.ZIndex = 14
		aaBtn.Parent = aaFrame
		table.insert(textTargets, aaBtn)

		local dropdownWidth = 136
		local dropdownHeight = 30 + (#FONT_OPTIONS * 26) + 10
		local dropdown = Instance.new("Frame")
		dropdown.AnchorPoint = Vector2.new(0.5, 0.5)
		dropdown.Size = UDim2.new(0, 0, 0, 0)
		dropdown.Position = UDim2.new(0.5, 0, 0, -(dropdownHeight / 2) - 8)
		dropdown.BackgroundColor3 = THEME.bg
		dropdown.BackgroundTransparency = 1
		dropdown.BorderSizePixel = 0
		dropdown.ClipsDescendants = true
		dropdown.Visible = false
		dropdown.ZIndex = 20
		dropdown.Parent = frame
		Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 12)

		local dropdownStroke = Instance.new("UIStroke")
		dropdownStroke.Color = Color3.fromRGB(255, 255, 255)
		dropdownStroke.Thickness = 1
		dropdownStroke.Transparency = 1
		dropdownStroke.Parent = dropdown
		pcall(function() dropdownStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border end)

		local dropdownTitle = Instance.new("TextLabel")
		dropdownTitle.Size = UDim2.new(1, -40, 0, 24)
		dropdownTitle.Position = UDim2.new(0, 12, 0, 5)
		dropdownTitle.BackgroundTransparency = 1
		dropdownTitle.Text = "Font"
		dropdownTitle.TextColor3 = THEME.titleColor
		dropdownTitle.TextSize = 15
		dropdownTitle.Font = currentFont
		dropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
		dropdownTitle.ZIndex = 21
		dropdownTitle.Parent = dropdown
		table.insert(textTargets, dropdownTitle)

		local dropdownClose = Instance.new("TextButton")
		dropdownClose.Size = UDim2.new(0, 24, 0, 24)
		dropdownClose.Position = UDim2.new(1, -30, 0, 5)
		dropdownClose.BackgroundTransparency = 1
		dropdownClose.BorderSizePixel = 0
		dropdownClose.Text = ""
		dropdownClose.ZIndex = 22
		dropdownClose.Parent = dropdown

		local dropdownCloseIcon = Instance.new("TextLabel")
		dropdownCloseIcon.Size = UDim2.new(0, 34, 0, 34)
		dropdownCloseIcon.Position = UDim2.new(0.5, -17, 0.5, -18)
		dropdownCloseIcon.BackgroundTransparency = 1
		dropdownCloseIcon.BorderSizePixel = 0
		dropdownCloseIcon.Text = "×"
		dropdownCloseIcon.TextColor3 = Color3.fromRGB(180, 180, 180)
		dropdownCloseIcon.TextSize = 30
		dropdownCloseIcon.Font = currentFont
		dropdownCloseIcon.ZIndex = 23
		dropdownCloseIcon.Parent = dropdownClose
		table.insert(textTargets, dropdownCloseIcon)

		local selectedFont = currentFont
		local selectedFontName = currentFontName
		local dropdownOpen = false
		local dropdownClosing = false
		local dropdownTween = nil
		local dropdownTweenToken = 0
		local fontButtons = {}

		local function setFontButtonsActive(active)
			for _, fontButton in ipairs(fontButtons) do
				if fontButton and fontButton.Parent then
					fontButton.Active = active
					fontButton.AutoButtonColor = active
				end
			end
		end

		local function closeDropdown()
			if not dropdown.Visible or dropdownClosing then return end
			dropdownOpen = false
			dropdownClosing = true
			setFontButtonsActive(false)
			dropdownTweenToken = dropdownTweenToken + 1
			local closeToken = dropdownTweenToken
			stopTween(dropdownTween)
			dropdownTween = TweenService:Create(dropdown, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1
			})
			dropdownTween:Play()
			TweenService:Create(dropdownStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Transparency = 1
			}):Play()
			local completedConnection = nil
			completedConnection = dropdownTween.Completed:Connect(function()
				if completedConnection then
					completedConnection:Disconnect()
					completedConnection = nil
				end
				if closeToken ~= dropdownTweenToken or dropdownOpen or data.dismissed or not dropdown.Parent then return end
				dropdownClosing = false
				dropdown.Visible = false
				resumeTimer()
			end)
		end

		local function openDropdown()
			if dropdownOpen or data.dismissed then return end
			dropdownOpen = true
			dropdownClosing = false
			setFontButtonsActive(true)
			dropdownTweenToken = dropdownTweenToken + 1
			pauseTimer()
			dropdown.Visible = true
			dropdown.Size = UDim2.new(0, 0, 0, 0)
			dropdown.BackgroundTransparency = 1
			dropdownStroke.Transparency = 1
			stopTween(dropdownTween)
			dropdownTween = TweenService:Create(dropdown, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, dropdownWidth, 0, dropdownHeight),
				BackgroundTransparency = 0
			})
			dropdownTween:Play()
			TweenService:Create(dropdownStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Transparency = 0.25
			}):Play()
		end

		aaBtn.MouseEnter:Connect(function()
			TweenService:Create(aaFrame, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			}):Play()
			TweenService:Create(aaStroke, TweenInfo.new(0.15), {
				Transparency = 0
			}):Play()
		end)

		aaBtn.MouseLeave:Connect(function()
			TweenService:Create(aaFrame, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			}):Play()
			TweenService:Create(aaStroke, TweenInfo.new(0.15), {
				Transparency = 0.15
			}):Play()
		end)

		aaBtn.MouseButton1Click:Connect(function()
			openDropdown()
		end)

		dropdownClose.MouseEnter:Connect(function()
			TweenService:Create(dropdownCloseIcon, TweenInfo.new(0.15), {
				TextColor3 = Color3.fromRGB(230, 230, 230)
			}):Play()
		end)

		dropdownClose.MouseLeave:Connect(function()
			TweenService:Create(dropdownCloseIcon, TweenInfo.new(0.15), {
				TextColor3 = Color3.fromRGB(180, 180, 180)
			}):Play()
		end)

		dropdownClose.MouseButton1Click:Connect(function()
			closeDropdown()
		end)

		for i, option in ipairs(FONT_OPTIONS) do
			local fontBtn = Instance.new("TextButton")
			fontBtn.Size = UDim2.new(1, -16, 0, 24)
			fontBtn.Position = UDim2.new(0, 8, 0, 30 + ((i - 1) * 26))
			fontBtn.BackgroundColor3 = THEME.btnBg
			fontBtn.BackgroundTransparency = option.Name == currentFontName and 0.1 or 0.45
			fontBtn.BorderSizePixel = 0
			fontBtn.Text = option.Name
			fontBtn.TextColor3 = THEME.titleColor
			fontBtn.TextSize = 11
			fontBtn.Font = currentFont
			fontBtn.TextXAlignment = Enum.TextXAlignment.Center
			fontBtn.ZIndex = 21
			fontBtn.Parent = dropdown
			Instance.new("UICorner", fontBtn).CornerRadius = UDim.new(0, 8)
			table.insert(textTargets, fontBtn)
			table.insert(fontButtons, fontBtn)

			fontBtn.MouseEnter:Connect(function()
				TweenService:Create(fontBtn, TweenInfo.new(0.15), {
					BackgroundTransparency = 0.08
				}):Play()
			end)

			fontBtn.MouseLeave:Connect(function()
				TweenService:Create(fontBtn, TweenInfo.new(0.15), {
					BackgroundTransparency = option.Font == selectedFont and 0.1 or 0.45
				}):Play()
			end)

			fontBtn.MouseButton1Click:Connect(function()
				if data.dismissed or dropdownClosing or not dropdownOpen then return end
				selectedFont = option.Font
				selectedFontName = option.Name
				currentFont = option.Font
				currentFontName = option.Name
				saveFont(option.Name)
				applyFont(option.Font, textTargets)
				for _, child in ipairs(dropdown:GetChildren()) do
					if child:IsA("TextButton") and child ~= dropdownClose then
						child.BackgroundTransparency = child == fontBtn and 0.1 or 0.45
					end
				end
				closeDropdown()
			end)
		end

		if btnCount > 0 then
			local divider = Instance.new("Frame")
			divider.Size = UDim2.new(1, 0, 0, 1)
			divider.Position = UDim2.new(0, 0, 0, 66)
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
				btn.Position = UDim2.new(btnX, 0, 0, 67)
				btn.BackgroundTransparency = 1
				btn.BorderSizePixel = 0
				btn.Text = btnText
				btn.TextColor3 = THEME.btnText
				btn.TextSize = 15
				btn.Font = currentFont
				btn.ZIndex = 13
				btn.Parent = frame
				table.insert(textTargets, btn)
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
					if data.dismissed or data.buttonClicked then return end
					data.buttonClicked = true
					data.paused = true
					dismissNotif(frame, data)
					if type(btnConfig.Callback) == "function" then
						task.spawn(function()
							local ok, err = pcall(btnConfig.Callback)
							if not ok then _nnWarn("NNNotify callback error: " .. tostring(err)) end
						end)
					end
				end)
			end

			if btnCount == 2 then
				local vDivider = Instance.new("Frame")
				vDivider.Size = UDim2.new(0, 1, 0, 34)
				vDivider.Position = UDim2.new(0.5, 0, 0, 67)
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

		local _, entranceToken = playFrameTween(data, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Position = bounceOver
		})
		task.delay(0.4, function()
			if data.dismissed or not frame.Parent or data.positionToken ~= entranceToken then return end
			local idx = getNotifIndex(data)
			if not idx then return end
			local currentTargetPos = getSlotPos(idx)
			local currentBounceBack = UDim2.new(currentTargetPos.X.Scale, currentTargetPos.X.Offset + 4, currentTargetPos.Y.Scale, currentTargetPos.Y.Offset)
			local _, bounceToken = playFrameTween(data, TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = currentBounceBack
			})
			task.delay(0.13, function()
				if data.dismissed or not frame.Parent or data.positionToken ~= bounceToken then return end
				local finalIdx = getNotifIndex(data)
				if not finalIdx then return end
				playFrameTween(data, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = getSlotPos(finalIdx)
				})
			end)
		end)

		if duration <= 0 then
			progressBar.Size = UDim2.new(0, 0, 1, 0)
			dismissNotif(frame, data)
		else
			task.spawn(function()
				local fixedStep = 1 / 60
				local maxFrameDt = 0.25
				local accumulator = 0
				local last = _nnClock()
				while not data.dismissed and data.remaining > 0 and frame.Parent do
					local heartbeatDt = RunService.Heartbeat:Wait()
					local now = _nnClock()
					local dt = type(heartbeatDt) == "number" and heartbeatDt or now - last
					last = now
					if dt < 0 then dt = 0 end
					if dt > maxFrameDt then dt = maxFrameDt end
					if not data.paused then
						accumulator = accumulator + dt
						while accumulator >= fixedStep and data.remaining > 0 do
							data.remaining = data.remaining - fixedStep
							accumulator = accumulator - fixedStep
						end
						if data.remaining < 0 then data.remaining = 0 end
						local ratio = data.remaining / data.duration
						if ratio < 0 then ratio = 0 end
						if ratio > 1 then ratio = 1 end
						if progressBar and progressBar.Parent then
							progressBar.Size = UDim2.new(ratio, 0, 1, 0)
						end
					end
				end
				if not data.dismissed then
					dismissNotif(frame, data)
				end
			end)
		end
	end

	pcall(function()
		ScreenGui.Destroying:Connect(function()
			for i = #activeNotifs, 1, -1 do
				local data = activeNotifs[i]
				if data then
					data.dismissed = true
					data.paused = true
					stopTween(data.positionTween)
					stopTween(data.dismissTween)
				end
				activeNotifs[i] = nil
			end
			releaseExecutionLock(createNotif)
		end)
	end)

	_nnEnv.NNNotify = createNotif
	NNNotify = createNotif

end

local _nnTraceback = debug and type(debug.traceback) == "function" and debug.traceback or function(err)
	return tostring(err)
end

local _nnOk, _nnErr = xpcall(_nnInit, _nnTraceback)
if _nnOk then
	local lock = _nnEnv.__NNNotifyExecutionLock
	if type(lock) == "table" and lock.token == _nnLockToken then
		lock.initializing = false
		lock.loaded = true
		lock.permanent = true
		lock.NNNotify = _nnEnv.NNNotify
	end
else
	local lock = _nnEnv.__NNNotifyExecutionLock
	if type(lock) == "table" and lock.token == _nnLockToken then
		if lock.gui then
			pcall(function()
				lock.gui:Destroy()
			end)
		end
		lock.initializing = false
		lock.loaded = false
		lock.permanent = false
		lock.failed = true
		lock.error = tostring(_nnErr)
		_nnEnv.__NNNotifyExecutionLock = nil
	end
	_nnSendInitErrorNotif()
	error(_nnErr, 0)
end

return _nnEnv.NNNotify
