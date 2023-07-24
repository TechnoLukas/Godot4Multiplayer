extends Node3D

func _ready():
	name=str(get_multiplayer_authority())

@rpc("unreliable")
func remote_set_position(_authority_position):
	pass
