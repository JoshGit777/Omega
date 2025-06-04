local Typings = {}

export type NPCConfiguration = {
	StateMachine: (self: NPC) -> nil,
	Attributes: {},
}

export type StateConfiguration = {
	Priority: number,
	StateConditionFunction: (NPC: NPC) -> boolean,
}

export type State = {
	Active: boolean,
	Priority: number,
	StateConditionFunction: (NPC: NPC) -> boolean,
	NPC: NPC,
	Update: (self: State) -> nil,
}

export type NPC = {
	RootModel: Model,
	RootPart: BasePart,
	Worker: Actor,

	ControllerManager: ControllerManager,
	GroundSensor: ControllerPartSensor,
	LadderSensor: ControllerPartSensor,
	BuoyancySensor: BuoyancySensor,
	GroundController: GroundController,
	ClimbController: ClimbController,
	AirController: AirController,

	Cache: { RBXScriptConnection & thread },

	ConfigurationModule: ModuleScript,
	Configuration: NPCConfiguration,

	State: State,

	LoadedStates: { State },
}

export type Omega = {
	Entities: {},
	ModelFolder: Folder,
	ConfigurationFolder: Configuration,
	RegisterModelFolder: (Folder: Folder) -> nil,
	RegisterConfigurationFolder: (Folder: Folder) -> nil,
	NPC: () -> NPC,
}

return Typings
