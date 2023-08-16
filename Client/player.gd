extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var shooting = false

@export var connection =false

@export var mesh:CSGMesh3D
@export var nicklabel:Label

@onready var camera = $Camera3D
@onready var camera_raycast = $Camera3D/raycast
@onready var anim_player = $AnimationPlayer

@onready var tagwd = $tagviewport/window
@onready var invwd = $invwd
@onready var invwd_ui = $invwd/UI/Control
@onready var hint = $hint

@onready var chat = $Chat
@onready var chat_window=$Chat/Messages
@onready var message_node=$Chat/Messages/templatemsg
@onready var msg_input=$Chat/Input/bg/message_input

var invwd_rtshift = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var shooting_delay = 2
var shooting_delay_cr = 0
var message_written = false

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
	
func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("focus"):
		msg_input.release_focus()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x*.005)
		camera.rotate_x(-event.relative.y*.005)
		camera.rotation.x=clamp(camera.rotation.x,-PI/2,PI/2)
		
	if Input.is_action_just_pressed("shoot") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			anim_player.stop()
			anim_player.play("shoot")
			shooting = true
	if Input.is_action_just_released("shoot") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			anim_player.stop()
			shooting = false
		
	if Input.is_action_just_pressed("inventory"):
		invwd.visible =! invwd.visible
		invwd_rtshift = rotation_degrees.y
		invwd.rotation_degrees.y = rotation_degrees.y - invwd_rtshift

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if anim_player.current_animation == "shoot" :
		pass
	elif input_dir != Vector2.ZERO and is_on_floor() and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		anim_player.play("walk")
	else:
		anim_player.play("idle")

	move_and_slide()
	
	invwd.rotation_degrees.y = 	-rotation_degrees.y+invwd_rtshift
	
	if shooting && shooting_delay_cr>shooting_delay:
		var markerpos=$Camera3D/Pistol/Marker3D.global_position
		get_parent().get_parent().share_point_properties.rpc_id(1,markerpos,mesh.mesh.material.albedo_color)
		shooting_delay_cr=0
	elif shooting_delay_cr<=shooting_delay:
		shooting_delay_cr=shooting_delay_cr+1
		
	if connection:
		remote_process.rpc(global_position,global_rotation,camera.global_rotation,invwd.global_rotation,anim_player.current_animation,invwd.visible)
	else:
		queue_free()
		print("queue_free()")
		
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
	
	
func _on_message_input_text_submitted(new_text):
	send_message(nicklabel.text,new_text,tagwd.get_node("nick").get("theme_override_colors/font_color"))
	print(multiplayer.get_unique_id(), " sent rpc")
	print(chat.visible)
	send_message_rpc.rpc(nicklabel.text,new_text,tagwd.get_node("nick").get("theme_override_colors/font_color"))
	msg_input.text=""

func send_message(nick, message,color):
	#print(tagwd.get_node("nick").text," : ", nick, " ", message, " ", color)
	var msg = message_node.duplicate()
	var cc = 1-(color.r+color.g+color.b)/3.0
	msg.get_node("nick").text=nick+":"
	msg.get_node("nick").set("theme_override_colors/font_color", color)
	msg.get_node("nick").set("theme_override_colors/font_outline_color", Color(cc,cc,cc))
	msg.get_node("message").text=message
	msg.get_node("message").set("theme_override_colors/font_color", color)
	msg.get_node("message").set("theme_override_colors/font_outline_color", Color(cc,cc,cc))
	msg.visible=true
	chat_window.add_child(msg)
	#print(msg," : ", chat_window.get_children())

@rpc
func send_message_rpc(nick, message,color):
	print(multiplayer.get_unique_id(), " recieved rpc")
	print(chat.visible)
	
		
	
