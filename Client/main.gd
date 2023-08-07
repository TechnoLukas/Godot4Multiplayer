extends Node3D

@onready var main_menu = $Menu
@onready var notification_menu = $Notification
@onready var loading_menu = $Loading

@onready var nicknamenp = $Menu/VBoxContainer/nicknamenp
@onready var colornp = $Menu/VBoxContainer/ColorRect/HBoxContainer/Panel/ColorPickerButton
@onready var progresslb = $Loading/progress

@onready var list = $player_list

var notification_text="server closed"
var kicked=false

const Player=preload("res://player.tscn")
const PORT=9999
var peer = WebSocketMultiplayerPeer.new()

func _init():
	pass
	#peer.supported_protocols = ["ludus"]
	
func _on_joinbt_pressed():
	if len(nicknamenp.text)>=2:
		main_menu.hide()
		peer.create_client("ws://" + $Menu/VBoxContainer/addressinp.text + ":" + str(PORT))
		multiplayer.multiplayer_peer = peer
		multiplayer.server_disconnected.connect(server_disconnected)
		multiplayer.connection_failed.connect(_connection_failed)

# --------- SERVER ------------------
func _connection_failed():
	show_notification("server is currently offline")

func server_disconnected():
	#print("server_disconnected")
	for i in list.get_children(): list.remove_child(i)
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
	list.add_child(player)
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
	if list.get_node_or_null(str(peer_id)):
		list.get_node(str(peer_id)).connection = false
		list.remove_child(list.get_node(str(peer_id)))
		
		
# --------- POINTS ------------------
@rpc("any_peer")
func share_point_properties(_p_position, _p_color):
	pass

@rpc
func spawn_new_point(properties):
	var point = preload("res://paintball.tscn").instantiate()
	point.position=properties[0]
	point.get_child(0).material.albedo_color=properties[1]
	get_parent().add_child(point)
	
@rpc
func spawn_old_points(database,proggressn,finished):
	loading_menu.visible=!finished
	progresslb.text="%"+str(proggressn)
	for p in database:
		var point = preload("res://paintball.tscn").instantiate()
		point.position=p[0]
		point.get_child(0).material.albedo_color=p[1]
		get_parent().add_child(point)
	
	



	



	

	


