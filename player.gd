extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var mesh = $CSGMesh3D
@onready var camera = $Camera3D
@onready var anim_player = $AnimationPlayer

@onready var fltwd = $SubViewport/window

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	

func _ready():
	if not is_multiplayer_authority(): return
	
	fltwd.get_node("nick").text=Global.nickname
	fltwd.get_node("color").color=Global.color
	#fltwd.get_node("nick").theme.set_color()
	
	mesh.material.albedo_color=Global.color
	#mesh.mesh.material.albedo_color=fltwd.get_node("color").color
	print(mesh.material.albedo_color)
	
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
		
	if Input.is_action_just_pressed("shoot") and anim_player.current_animation != "shoot" and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		play_shoot_effects()#.rpc()

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

func play_shoot_effects():
	anim_player.stop()
	anim_player.play("shoot")
