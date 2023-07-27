extends Panel

@onready var nicknamefd = $HBoxContainer/nickaname
@onready var peer_idfd = $HBoxContainer/peer_id
@onready var colorfd = $HBoxContainer/color

func _ready():
	name=str(get_multiplayer_authority())

func _on_kickbt_pressed():
	get_parent().get_parent().get_parent().remove_player.rpc(int(peer_idfd.text))
	
func set_proprties(nick,id,color):
	nicknamefd.text=nick
	peer_idfd.text=str(id)
	
@rpc("unreliable")
func remote_process(_authority_position,_authority_rotation,_authority_cam_rotation, _authority_invwd_rotation, _authority_anim_player_current_animation, _authority_invwd_visible):
	pass
