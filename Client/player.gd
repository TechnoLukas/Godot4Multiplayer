extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var placing = false
var removing = false

@export var connection =false

@export var mesh:CSGMesh3D
@export var nicklabel:Label

@onready var camera = $Camera3D
@onready var camera_raycast = $Camera3D/raycast
@onready var anim_player = $AnimationPlayer

@onready var tagwd = $tagviewport/window
@onready var invwd = $invwd
@onready var hint = $hint
@onready var voxelmn = $voxelmenu


@onready var chat = $Chat
@onready var chat_window=$Chat/ScrollContainer/Messages
@onready var message_node=$Chat/ScrollContainer/Messages/templatemsg
@onready var msg_input=$Chat/Input/bg/message_input
@onready var chat_scroll=$Chat/ScrollContainer

var voxel=null
var place_on_edges=false
var mouse_focus = false

var invwd_rtshift = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var voxel_delay = 5
var voxel_delay_cr = 0
var mouse_sensitivity = 0.005

func _enter_tree():
	name=str(get_multiplayer_authority())
	
func _ready():
	if not is_multiplayer_authority(): return
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	camera.current=true
	invwd.visible=false
	connection=true
	hint.visible=true
	tagwd.visible=false
	chat.visible=true
	voxelmn.visible=true
	
func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_released("focus"):
		if(DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_HIDDEN):
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
			mouse_focus=false
		elif(DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_VISIBLE):
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
			mouse_focus=true
			msg_input.release_focus()
			
		msg_input.release_focus()
	if Input.is_action_just_pressed("open_chat"):
		chat.visible=not(chat.visible)
	if event is InputEventMouseMotion and mouse_focus:
		rotate_y(-event.relative.x*mouse_sensitivity)
		camera.rotate_x(-event.relative.y*mouse_sensitivity)
		camera.rotation.x=clamp(camera.rotation.x,-PI/2,PI/2)
		
	if Input.is_action_just_pressed("place") and mouse_focus:
			anim_player.stop()
			anim_player.play("place")
			placing = true
	if Input.is_action_just_released("place") and mouse_focus:
			anim_player.stop()
			placing = false
			
	if Input.is_action_just_pressed("remove") and mouse_focus:
			anim_player.stop()
			anim_player.play("place")
			removing = true
	if Input.is_action_just_released("remove") and mouse_focus:
			anim_player.stop()
			removing = false
		
	if Input.is_action_just_pressed("inventory"):
		invwd.visible =! invwd.visible
		invwd_rtshift = rotation_degrees.y
		invwd.rotation_degrees.y = rotation_degrees.y - invwd_rtshift

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and mouse_focus:
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and mouse_focus:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if anim_player.current_animation == "place" :
		pass
	elif input_dir != Vector2.ZERO and is_on_floor() and mouse_focus:
		anim_player.play("walk")
	else:
		anim_player.play("idle")

	move_and_slide()
	
	invwd.rotation_degrees.y = 	-rotation_degrees.y+invwd_rtshift
	var snp = 0.1
	if placing and voxel_delay_cr>voxel_delay and camera_raycast.get_collider()==null:
		var markerpos=$Camera3D/Pistol/Marker3D.global_position
		
		get_parent().get_parent().share_point_properties.rpc_id(1,Vector3(snappedf(markerpos.x,snp),snappedf(markerpos.y,snp),snappedf(markerpos.z,snp)),mesh.mesh.material.albedo_color)
		voxel_delay_cr=0
	elif placing and voxel_delay_cr>voxel_delay and camera_raycast.get_collider()!=null:
		if str(camera_raycast.get_collider()).split(":")[0]=="voxel":
			if place_on_edges:
				var target_pos=camera_raycast.get_collider().get_parent().position
				var collision_pos=camera_raycast.get_collision_point()
				var dis=collision_pos-target_pos
				var norm_dis=dis.normalized()
				var shift=Vector3(snappedf(norm_dis.x,1)/10,snappedf(norm_dis.y,1)/10,snappedf(norm_dis.z,1)/10)
				var pos=target_pos+shift
				print(target_pos," ",collision_pos," ",dis," ",shift)
				get_parent().get_parent().share_point_properties.rpc_id(1,Vector3(pos.x,pos.y,pos.z),mesh.mesh.material.albedo_color)
			else:
				var target_pos=camera_raycast.get_collider().get_parent().position
				var collision_pos=camera_raycast.get_collision_point()
				var dis=collision_pos-target_pos
				var norm_dis=dis.normalized()
				var dis_snap=Vector3(snappedf(dis.x,0.01),snappedf(dis.y,0.01),snappedf(dis.z,0.01))
				var shift=Vector3(0,0,0)
				print("1",dis_snap)
				print(abs(snappedf(dis.x,0.01))*2.)
				if abs(snappedf(dis.x,0.01)) == 0.05: shift.x=snappedf(dis.x,0.01)*2.; 
				if abs(snappedf(dis.y,0.01)) == 0.05: shift.y=snappedf(dis.y,0.01)*2.; 
				if abs(snappedf(dis.z,0.01)) == 0.05: shift.z=snappedf(dis.z,0.01)*2.; 
				var pos=target_pos+shift
				print("2",shift)
				get_parent().get_parent().share_point_properties.rpc_id(1,Vector3(pos.x,pos.y,pos.z),mesh.mesh.material.albedo_color)

			"""
			var collision_pos=camera_raycast.get_collision_point()#camera_raycast.get_collider().get_parent().global_position
			var angle = camera.global_position.angle_to(collision_pos)	
			var dis=camera.global_position.distance_to(collision_pos)
			var x = dis * sin(deg_to_rad(angle))
			var y = -dis * cos(deg_to_rad(angle))
			
			var pos =collision_pos+(camera_raycast.get_collision_point().direction_to(camera.global_position))/18
			print(x," ",y," ",pos," ",camera.position)
			get_parent().get_parent().share_point_properties.rpc_id(1,Vector3(snappedf(pos.x,snp),snappedf(pos.y,snp),snappedf(pos.z,snp)),mesh.mesh.material.albedo_color)
			"""
		else:
			var collision_pos=camera_raycast.get_collision_point()#camera_raycast.get_collider().get_parent().global_position
			var angle = camera.global_position.angle_to(collision_pos)	
			var dis=camera.global_position.distance_to(collision_pos)
			var x = dis * sin(deg_to_rad(angle))
			var y = -dis * cos(deg_to_rad(angle))
			
			var pos =collision_pos+(camera_raycast.get_collision_point().direction_to(camera.global_position))/18
			get_parent().get_parent().share_point_properties.rpc_id(1,Vector3(snappedf(pos.x,snp),snappedf(pos.y,snp),snappedf(pos.z,snp)),mesh.mesh.material.albedo_color)

		voxel_delay_cr=0
	elif voxel_delay_cr<=voxel_delay:
		voxel_delay_cr=voxel_delay_cr+1
		
	if connection:
		remote_process.rpc(global_position,global_rotation,camera.global_rotation,invwd.global_rotation,anim_player.current_animation,invwd.visible)
	else:
		queue_free()
		print("queue_free()")
	
	if chat_scroll.has_focus():
		var scroll = chat_scroll.get_v_scroll_bar()
		var scroll_max = scroll.max_value
		chat_scroll.scroll_vertical = scroll_max
		
	
	# Highlight
	var collider
	if camera_raycast.get_collider()!=null and str(camera_raycast.get_collider()).split(":")[0]=="voxel":
		collider=camera_raycast.get_collider().get_parent()
	else:
		collider=null
		
	if voxel!=collider:
		print("new")
		if voxel!=null: 
			voxel.get_node("voxel").material.albedo_color=voxel.get_node("outline").material.albedo_color
			voxel.get_node("outline").material.albedo_color=Color(1,1,1)
			voxel.get_node("outline").visible=false
		voxel=collider
		if voxel!=null: 
			voxel.get_node("outline").visible=true
			voxel.get_node("outline").material.albedo_color=voxel.get_node("voxel").material.albedo_color
			voxel.get_node("voxel").material.albedo_color=Color(1,1,1)

	
		
@rpc("unreliable")
func remote_process(authority_position,authority_rotation,authority_cam_rotation,authority_invwd_rotation,authority_anim_player_current_animation,authority_invwd_visible ):
	global_position = authority_position
	global_rotation = authority_rotation
	camera.global_rotation=authority_cam_rotation
	invwd.global_rotation=authority_invwd_rotation
	anim_player.current_animation=authority_anim_player_current_animation
	invwd.visible=authority_invwd_visible

func change_visibility(_visible):
	visible=_visible

func update_properties(n,c):
	var cc = 1-(c.r+c.g+c.b)/3.0
	tagwd.get_node("nick").text=n
	tagwd.get_node("nick").set("theme_override_colors/font_color", c)
	tagwd.get_node("nick").set("theme_override_colors/font_outline_color", Color(cc,cc,cc,1))
	mesh.mesh.material.albedo_color=c
	chat.visible=false
	#voxelmn.visible=false
	
	
func _on_message_input_text_submitted(new_text):
	send_message_rpc.rpc(nicklabel.text,new_text,tagwd.get_node("nick").get("theme_override_colors/font_color"))
	msg_input.text=""

@rpc("call_local")
func send_message_rpc(nick, message,color):
	if len(message)==0: return
	var msg = message_node.duplicate()
	var cc = 1-(color.r+color.g+color.b)/3.0
	msg.get_node("nick").text=nick+":"
	msg.get_node("nick").set("theme_override_colors/font_color", color)
	msg.get_node("nick").set("theme_override_colors/font_outline_color", Color(cc,cc,cc))
	msg.get_node("message").text=message
	msg.get_node("message").set("theme_override_colors/font_color", color)
	msg.get_node("message").set("theme_override_colors/font_outline_color", Color(cc,cc,cc))
	
	var player=get_parent().get_node(str(multiplayer.get_unique_id()))
	
	if(player.tagwd.get_node("nick").text==nick):
		msg.get_node("nick").text="> "
	
	msg.visible=true
	player.chat_window.add_child(msg)
	
	await get_tree().create_timer(0.1).timeout
	var scroll = player.chat_scroll.get_v_scroll_bar()
	var scroll_max = scroll.max_value
	player.chat_scroll.scroll_vertical = scroll_max


func _on_check_box_pressed():
	place_on_edges=!place_on_edges
	

func _on_h_slider_value_changed(value):
	voxel_delay=value
