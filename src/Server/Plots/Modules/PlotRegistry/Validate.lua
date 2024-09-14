export type Validator = (plotModel: Model, ret: {}) -> {}?

local function createValidator(key: string, childName: string): Validator
	return function(plotModel, ret)
		local find = plotModel:FindFirstChild(childName, true)
		if not find then
			warn(`Failed to find {childName} in plotModel.`)
			return
		end
		ret[key] = find
		return ret
	end
end

local validators: { Validator } = {
	createValidator("buttons", "Buttons"),
	createValidator("spawn", "Spawn"),
	createValidator("models", "Models"),
	-- createValidator("door", "TycoonDoor"),
	createValidator("claim", "PayoutButton"),
	createValidator("indicator", "CashIndicator"),
}

local function validate(plotModel)
	local ret = {}

	for _, validator in validators do
		ret = validator(plotModel, ret)
		if not ret then return nil end
	end

	return ret
end

return validate
