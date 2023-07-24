extends Node3D

func _ready():
	name=str(get_multiplayer_authority())

@rpc("unreliable")
func remote_set_transform(_authority_position,_authority_rotation,_authority_cam_rotation):
	pass
