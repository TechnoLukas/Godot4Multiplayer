extends Node3D

@onready var main_menu = $Menu

@onready var nicknamenp = $Menu/VBoxContainer/nicknamenp
@onready var colornp = $Menu/VBoxContainer/ColorRect/HBoxContainer/Panel/ColorPickerButton

const Player=preload("res://player.tscn")
const PORT=9999
var peer = WebSocketMultiplayerPeer.new()

func _init():
	peer.supported_protocols = ["ludus"]
	
func _on_joinbt_pressed():
	if len(nicknamenp.text)>=2:
		main_menu.hide()
		peer.create_client("ws://" + $Menu/VBoxContainer/addressinp.text + ":" + str(PORT))
		multiplayer.multiplayer_peer = peer
	

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
	add_child(player)
	player.update_properties(properties.nickname,properties.color)
	await get_tree().create_timer(0.1).timeout
	player.change_visibility(true)

@rpc
func spawn_new_player(peer_id,properties):
	spawn_player(peer_id,properties)

@rpc
func spawn_old_players(database):
	for peer_id in database:
		spawn_player(peer_id,database[peer_id])
			
@rpc("any_peer")
func remove_player(peer_id):
	if get_node_or_null(str(peer_id)):
		get_node(str(peer_id)).queue_free()

@rpc("any_peer")
func share_point_properties(_p_name, _p_position, _p_color):
	pass

@rpc
func spawn_new_point(properties):
	var point = preload("res://paintball.tscn").instantiate()
	point.position=properties.position
	point.get_child(0).material.albedo_color=properties.color
	get_parent().add_child(point)
	
@rpc
func spawn_old_points(database):
	for p in database:
		var point = preload("res://paintball.tscn").instantiate()
		point.position=database[p].position
		point.get_child(0).material.albedo_color=database[p].color
		get_parent().add_child(point)
	


