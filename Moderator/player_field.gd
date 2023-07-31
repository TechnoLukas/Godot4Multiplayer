extends Panel

@onready var nicknamefd = $HBoxContainer/nickaname
@onready var peer_idfd = $HBoxContainer/peer_id
@onready var colorfd = $HBoxContainer/color

func _on_kickbt_pressed():
	get_parent().get_parent().get_parent().remove_player.rpc(int(peer_idfd.text))
	
func set_properties(nick,id,color):
	nicknamefd.text=nick
	peer_idfd.text=str(id)
	
	var stbx = colorfd.get_theme_stylebox("StyleBoxFlat").duplicate()
	stbx.draw_center=true
	stbx.bg_color=color
	stbx.border_color=color
	stbx.corner_radius_bottom_left = 10
	stbx.corner_radius_bottom_right = 10
	stbx.corner_radius_top_left = 10
	stbx.corner_radius_top_right = 10
	colorfd.add_theme_stylebox_override("panel",stbx)
	


