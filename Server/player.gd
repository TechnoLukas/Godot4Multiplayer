extends Node3D

func _ready():
	name=str(get_multiplayer_authority())

@rpc("unreliable")
func remote_process(_authority_position,_authority_rotation,_authority_cam_rotation, _authority_invwd_rotation, _authority_anim_player_current_animation, _authority_invwd_visible):
	pass

@rpc("unreliable")
func remote_ready_properties(_authority_nickname,_authority_color):
	pass
	
