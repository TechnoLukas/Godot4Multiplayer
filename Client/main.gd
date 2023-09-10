extends Node3D

@onready var main_menu = $Menu
@onready var main_menu_3d = $Menu3D
@onready var notification_menu = $Notification
@onready var loading_menu = $Loading

@onready var nicknamenp = $Menu/VBoxContainer/Nickname/nicknamenp
@onready var colornp = $Menu/VBoxContainer/Color/ColorRect/HBoxContainer/Panel/ColorPickerButton

@onready var progresslb = $Loading/progress

@onready var player_list = $player_list
@onready var point_list = $point_list

var point_database = []

var notification_text="server closed"
var kicked=false
var loading = false

const Player=preload("res://player.tscn")
const PORT=8080
var peer = WebSocketMultiplayerPeer.new()

func _ready():
	colornp.color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
	nicknamenp.text="Player#"+str(randi_range(0,9))+str(randi_range(0,9))+str(randi_range(0,9))
	Input.start_joy_vibration(0, 1, 1, 2)
	
func _on_joinbt_pressed():
	if len(nicknamenp.text)>=2:
		main_menu.hide()
		main_menu_3d.hide()
		#peer.create_client("ws://" + $Menu/VBoxContainer/addressinp.text + ":" + str(PORT))
		#peer.create_client("ws://" + "ec2-16-171-197-200.eu-north-1.compute.amazonaws.com" + ":" + str(PORT))
		#peer.create_client("wss://" + "www.godot-games.info:8080/")
		
		#var client_trusted_cas = load("www.godot-games.info.crt")
		#var client_tls_options = TLSOptions.client(client_trusted_cas)
		
		#peer.create_client($Menu/VBoxContainer/addressinp.text + ":" + str(PORT)+"/",client_tls_options)
		peer.create_client($Menu/VBoxContainer/addressinp.text + ":" + str(PORT)+"/")
		multiplayer.multiplayer_peer = peer
		multiplayer.server_disconnected.connect(server_disconnected)
		multiplayer.connection_failed.connect(_connection_failed)

# --------- SERVER ------------------
func _connection_failed():
	print("_connection_failed")
	show_notification("server is currently offline")

func server_disconnected():
	#print("server_disconnected")
	for i in player_list.get_children(): player_list.remove_child(i)
	show_notification(notification_text)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#if not kicked:
	#	get_child(get_child_count()-1).connection = false
	#	remove_child(get_child(get_child_count()-1))
	
func show_notification(text, timer=0.0):
	notification_menu.get_node("text").text=text
	notification_menu.visible=true
	if timer != 0.0:
		await get_tree().create_timer(timer).timeout
		notification_menu.visible=false


# --------- PLAYER ------------------
@rpc("any_peer")
func ping_player(peer_id):
	share_player_properties.rpc_id(1,peer_id,nicknamenp.text,colornp.color)

@rpc("any_peer")	
func share_player_properties():
	pass

func spawn_player(peer_id,properties):
	var player = preload("res://player.tscn").instantiate()
	player.set_multiplayer_authority(peer_id)
	player.visible=false
	player.position=Vector3(randf_range(-4.5,4.5),0.3,randf_range(-4.5,4.5))
	player_list.add_child(player)
	player.update_properties(properties.nickname,properties.color)
	#await get_tree().create_timer(0.05).timeout
	player.change_visibility(true)

@rpc
func spawn_new_player(peer_id,properties):
	spawn_player(peer_id,properties)

@rpc
func spawn_old_players(database):
	for peer_id in database:
		spawn_player(peer_id,database[peer_id])
			
@rpc
func remove_player(peer_id,notifi_text):
	if peer_id==multiplayer.get_unique_id(): notification_text=notifi_text
	if player_list.get_node_or_null(str(peer_id)):
		player_list.get_node(str(peer_id)).connection = false
		player_list.remove_child(player_list.get_node(str(peer_id)))
		
		
# --------- POINTS ------------------
@rpc("any_peer")
func share_point_properties(_p_position, _p_color):
	pass
	
@rpc("any_peer")
func share_point_index_rm(_index,_node):
	pass
	
	
func get_point_index(p_position,node):
	for i in range(point_database.size()):
		if point_database[i][0]==p_position:
			share_point_index_rm.rpc_id(1,i)
			

@rpc
func spawn_new_point(properties):
	var point = preload("res://voxel.tscn").instantiate()
	point.position=properties[0]
	point.get_child(0).material.albedo_color=properties[1]
	point_list.add_child(point)
	point_database.append(properties)
	get_node("player_list").get_node(str(multiplayer.get_unique_id())).update_points_properties()
	
@rpc
func remove_point(index):
	if point_list.get_child_count()>index: point_list.remove_child(point_list.get_child(index))
	if point_database.size()>index: point_database.remove_at(index)
	
	
@rpc
func spawn_old_points(database,proggressn,finished):
	loading=!finished
	loading_menu.visible=!finished
	progresslb.text="loading %"+str(proggressn)+"\nplease wait"
	for p in database:
		var point = preload("res://voxel.tscn").instantiate()
		point.position=p[0]
		point.get_child(0).material.albedo_color=p[1]
		point_list.add_child(point)
		point_database.append(p)
		
	update_loading_stat.rpc(multiplayer.get_unique_id(),"ready")
		
@rpc("any_peer")
func update_loading_stat(_peer_id,_stat):
	pass
