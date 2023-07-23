extends Node3D

func _ready():
	name=str(get_multiplayer_authority())
