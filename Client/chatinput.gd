extends LineEdit
	
func _unhandled_input(_event):
	if not is_multiplayer_authority(): return
	
	if Input.is_action_just_pressed("ui_cancel"):
		if has_focus():
			release_focus()
		
	
