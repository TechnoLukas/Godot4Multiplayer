extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var shooting = false

@onready var mesh = $CSGMesh3D
@onready var camera = $Camera3D
@onready var camera_raycast = $Camera3D/raycast
@onready var anim_player = $AnimationPlayer
@onready var effect = $Camera3D/Pistol/GPUParticles3D

@onready var tagwd = $tagviewport/window
@onready var invwd = $invwd
@onready var invwd_ui = $invwd/UI/Control

var invwd_rtshift = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	

func _ready():
	print("no authority")
	if not is_multiplayer_authority(): return
	print("authority")
	change_color.rpc_id(1,multiplayer.get_unique_id())
	
	tagwd.get_node("nick").text=Global.nickname
	#tagwd.get_node("color").color=Global.color
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	position=Vector3(randf_range(-5,5),2,randf_range(-5,5))
	visible=true
	camera.current=true

func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("ui_focus_next"):
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
	
	if shooting:
		shoot()

func shoot():
	var scene = preload("res://paintball.tscn")
	var instance = scene.instantiate()
	instance.position=$Camera3D/Pistol/Marker3D.global_position
	get_parent().add_child(instance)

@rpc
func change_color(peer_id):
	pass

	
