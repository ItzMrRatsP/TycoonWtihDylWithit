--!strict

local CollectionService = game:GetService("CollectionService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")

local GamePasses =
	require(ServerStorage.Server.Monetization.Components.GamePasses)
local Global = require(ReplicatedStorage.Shared.Global)

local Money = require(ServerStorage.Server.Money.Components.Money)
local Player = require(ServerStorage.Server.Player.Components.Player)
local PlayerEntityTracker =
	require(ReplicatedStorage.Shared.Modules.PlayerEntityTracker)

local ButtonOrderLUT =
	require(ServerStorage.Server.Plots.Modules.ButtonOrderLUT)
local DepencyMapper = require(ServerStorage.Server.Plots.Modules.DepencyMapper)

local Types = require(ServerStorage.Server.Plots.Modules.Types)

local RevealInfo =
	TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local Buttons = {}

local B_0 = 100
local GROWTH_RATE = 0.05 -- very cool grow rate :cool:

local function calcButtonCost(order): number
	return math.ceil(B_0 * math.exp(GROWTH_RATE * order) / 1) -- how we caculat
end

function Buttons.registerButtons(tycoon: Types.Tycoon): { Types.ButtonData }
	local cache: { Types.ButtonData } = {}
	local lut: { [string]: Types.ButtonData } = {}

	for _, button: Instance in tycoon.buttons:GetChildren() do
		if not button:IsA("BasePart") then continue end

		local buttonData: Types.ButtonData? =
			Buttons.registerButton(button, tycoon.gamepassCache)
		if not buttonData then continue end

		lut[buttonData.id] = buttonData
		table.insert(cache, buttonData)
	end

	for _, buttonData in cache do
		Buttons.registerFunctions(buttonData, lut)
	end

	return cache, lut
end

local currencyEnum = Global.Util.arrayToDict {
	"Cash",
	"Money",
	"Robux",
}

local currencyText = {
	["Money"] = "$",
	["Robux"] = utf8.char(0xE002),
}

-- want to make a function for hiding too? sure
function Buttons.reveal(id, tycoon: Types.Tycoon)
	local find: Instance = tycoon.idToInstance[id]
	if not find then return end

	find.Parent = tycoon.model

	if not find:IsA("Model") then return end
	Global.Util.TweenModelSize(find, RevealInfo, { Scale = 1 }):Play()
	-- this is it..
end

function Buttons.hide(id, tycoon: Types.Tycoon)
	local find = tycoon.idToInstance[id]
	if not find then
		warn("Tried to hide", id, "that has no instance in lut!")
		return
	end

	find.Parent = tycoon.repVersion

	if not find:IsA("Model") then return end
	find:ScaleTo(0.05)
end

function Buttons.validateButton(button: BasePart): Types.ButtonData?
	local name: string = button:GetAttribute("Name") :: string? or "NULL"
	local currencyAttribute: string? =
		button:GetAttribute("Currency") :: string?
	local costAttribute: number? = button:GetAttribute("Cost") :: number?
	local dependentsAttribute: string? =
		button:GetAttribute("Dependents") :: string?
	local initialState: boolean | unknown = button:GetAttribute("InitialState")
		or false

	local addIncomeAttribute: number? =
		button:GetAttribute("addIncome") :: number?

	if not (currencyAttribute and costAttribute and addIncomeAttribute) then
		warn(`Button {button} is missing an attribute and was not registered.`)
		return
	end

	if not currencyEnum[currencyAttribute] then
		warn(
			`Button {button} does not have a valid Currency attribute and was not registered.`
		)
		return
	end

	local dependentString = if dependentsAttribute
		then string.split(dependentsAttribute, ",")
		else {}

	return {
		initialState = initialState,
		name = name,
		addIncome = addIncomeAttribute,
		dependents = dependentString,
		currency = currencyAttribute,
		cost = costAttribute,
	} :: Types.ButtonData
end

function Buttons.registerButton(button, gamepassCache): Types.ButtonData?
	local data: Types.ButtonData? =
		Buttons.validateButton(button) :: Types.ButtonData?
	if not data then return end

	data.id = button.Name
	data.button = button
	data.owned = false

	if data.currency ~= "Robux" then
		local cost: number = data.button:GetAttribute("Price") :: number

		if not cost then
			warn("Please add attribute 'Price' to this button!")
			return
		end

		data.cost = cost
	end

	local DetailGui = data.button:FindFirstChild("DetailGui")
	if not DetailGui then return end

	local nameLabel = DetailGui:FindFirstChild("NameLabel") :: TextLabel?
	local costLabel = DetailGui:FindFirstChild("CostLabel") :: TextLabel?

	if not costLabel or not nameLabel then return end

	costLabel.Text = if data.currency ~= "Robux"
		then `{data.cost}{currencyText[data.currency]}`
		else `{gamepassCache[data.cost]} {currencyText[data.currency]}`

	nameLabel.Text = data.name
	if data.currency == "Robux" then costLabel:AddTag("RGBText") end

	return data :: Types.ButtonData
end

function Buttons.registerFunctions(buttonData: Types.ButtonData, lut)
	buttonData.buy = function(entity): boolean
		--[[
			-- excerpt from Server/Money/Jobs/MoneyAdder.lua
			Profiles.addDefaultData("PlayerData", Money.Key, {
				value = 0,
			})
		]]
		local player = Player.get(entity)

		if buttonData.currency == "Robux" then
			--- prompt product

			if
				MarketplaceService:UserOwnsGamePassAsync(
					player.UserId,
					buttonData.cost
				)
			then
				return true
			else
				MarketplaceService:PromptGamePassPurchase(
					player,
					buttonData.cost
				)
			end

			return false
		end

		if player:GetAttribute("InfMoney") then return true end

		local moneyComp = Money.get(entity)
		local playerMoney = moneyComp.value

		if playerMoney < buttonData.cost then return false end

		moneyComp.value -= buttonData.cost
		buttonData.owned = true

		-- bought
		return true
	end

	local function areAllIdsOwned(tycoon, ids)
		for _, id: string in ids do
			-- its this part >> 100%
			local btn = lut[id]
			if not btn then
				warn("NO BUTTON")
				continue
			end
			if not btn.owned then
				warn("YOU DON'T OWN THE BUTTON!")
				return false
			end
		end

		return true
	end

	local function checkDependents(tycoon)
		for _, dependent: string in buttonData.dependents do
			local dependentDepedencyMap = DepencyMapper[dependent]
			if not dependentDepedencyMap then
				warn("No dependency map found for", dependent)
				continue
			end

			-- check if all the requirements are met for a button to be revealed

			local canReveal = areAllIdsOwned(tycoon, dependentDepedencyMap)

			-- If the dependent does not have all requirements met then we can't reveal it.
			if not canReveal then
				warn("Can't reveal :sob:")
				continue
			end

			local dependentData = lut[dependent]
			if dependentData and dependentData.owned then continue end

			Buttons.reveal(dependent, tycoon)
		end
	end

	buttonData.activate = function(tycoon: Types.Tycoon)
		Buttons.hide(buttonData.id, tycoon)
		buttonData.owned = true
		tycoon.saved[buttonData.id] = buttonData.id

		tycoon.income.perSecond += buttonData.addIncome

		checkDependents(tycoon)
	end

	buttonData.deactivate = function(tycoon: Types.Tycoon)
		if buttonData.initialState then
			Buttons.reveal(buttonData.id, tycoon)
		else
			Buttons.hide(buttonData.id, tycoon)
		end

		for _, id in buttonData.dependents do
			Buttons.hide(id, tycoon)
		end
	end

	return buttonData
end

function Buttons.hookUp(tycoon: Types.Tycoon) -- better, 100%
	for _, buttonData in tycoon.buttonData do
		buttonData.button.Touched:Connect(function(hit)
			local model = hit:FindFirstAncestorOfClass("Model")
			if not model then
				warn("[Button] No model")
				return
			end
			local player: Player? = Players:GetPlayerFromCharacter(model)
			if not player then
				warn("[Button] No player")
				return
			end

			print("HERE!")

			local entity: number = PlayerEntityTracker.get(player)
			if not entity then
				warn("NO ENTITY")
				return
			end
			if tycoon.owner ~= entity then
				print(entity)
				print(tycoon.owner)
				warn("INVALID OWNER")
				return
			end

			print(buttonData)
			if buttonData.buy(entity) then buttonData.activate(tycoon) end
		end)
	end
end

return Buttons
