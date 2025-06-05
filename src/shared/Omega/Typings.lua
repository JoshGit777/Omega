local Typings = {}

export type NPCConfiguration = {
	CharacterStateMachine: ((self: NPC) -> nil)?,
	Functionality: (self: NPC) -> nil,
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
	SwimController: SwimController,

	MoveDirection: Vector3,

	Cache: { RBXScriptConnection & thread },

	ConfigurationModule: ModuleScript,
	Configuration: NPCConfiguration,

	State: State,

	LoadedStates: { State },

	ID: number,
}

export type Identification = {
	Registered: { [any]: any },
	LastID: number,
	Register: (self: Identification, Value: any) -> number,
	Get: (self: Identification, ID: number) -> any,
}

export type Omega = {
	Entities: {},
	ModelFolder: Folder,
	ConfigurationFolder: Configuration,
	RegisterModelFolder: (self: Omega, Folder: Folder) -> nil,
	RegisterConfigurationFolder: (self: Omega, Folder: Folder) -> nil,
	NPC: (self: Omega, Name: string, SpawnCFrame: CFrame?) -> NPC,
	Identification: Identification,
	EntityFolder: Folder,
}

return Typings
