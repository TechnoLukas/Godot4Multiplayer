extends Panel

@onready var nicknamefd = $HBoxContainer/nickaname
@onready var peer_idfd = $HBoxContainer/peer_id
@onready var colorfd = $HBoxContainer/color



func _on_kickbt_pressed():
	get_parent().get_parent().get_parent().remove_player.rpc(int(peer_idfd.text))
	
func set_proprties(nick,id,color):
	nicknamefd.text=nick
	peer_idfd.text=str(id)
