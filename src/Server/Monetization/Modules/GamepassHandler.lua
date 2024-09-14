local MarketplaceService = game:GetService("MarketplaceService")
local GamepassHandler = {}

function GamepassHandler.getPrices(list: { number })
	local t = {}

	-- index
	for _, id in list do
		local success, result = xpcall(function()
			return MarketplaceService:GetProductInfo(id, Enum.InfoType.GamePass)
		end, warn)

		if not success then continue end
		if not result then continue end

		t[id] = result.PriceInRobux
	end -- no, this function is for prices

	return t
end

return GamepassHandler
