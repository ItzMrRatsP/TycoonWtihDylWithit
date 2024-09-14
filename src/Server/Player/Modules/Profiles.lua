local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- local Global = require(ReplicatedStorage.Shared.Global)
local ProfileService = require(ReplicatedStorage.Packages.ProfileService)

local Profiles = {}
local ProfileTemplates = {}
local ProfileStores = {}

function Profiles.addDefaultData(
	profileStoreName: string,
	id: string,
	defaultData: { string: any }
): ()
	if not ProfileTemplates[profileStoreName] then
		ProfileTemplates[profileStoreName] = {}
	end

	ProfileTemplates[profileStoreName][id] = defaultData
end

function Profiles.getProfileStore(profileStoreName)
	if not ProfileStores[profileStoreName] then
		local template = ProfileTemplates[profileStoreName]
		if not template then
			error(`No profile template exists with name "{profileStoreName}"`)
		end

		ProfileStores[profileStoreName] =
			ProfileService.GetProfileStore(profileStoreName, template)
	end

	return ProfileStores[profileStoreName]
end

return Profiles
