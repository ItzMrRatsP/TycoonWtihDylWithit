export type ButtonData = {
	id: string,
	button: BasePart, -- | Model,
	owned: boolean,
	addIncome: number,
	dependents: { string },
	cost: number,
	name: string,
	currency: string,
	initialState: boolean,
	order: number,
	buy: (number) -> (),
	activate: (Tycoon) -> (),
	deactivate: (Tycoon) -> (),
}

export type Tycoon = {
	buttonData: { ButtonData },
	buttonIdLUT: { [string]: ButtonData },
	saved: { [string]: string },
	door: BasePart,
	claim: BasePart,
	income: { perSecond: number, money: number },
	idToInstance: { [string]: Instance },
	model: Model,
	owner: any,
	gamepassCache: { [number]: number },
	models: Folder,
	buttons: Folder,
	repVersion: Folder,
	spawn: BasePart,
}

return {}
