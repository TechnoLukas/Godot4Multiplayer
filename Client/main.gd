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
	main_menu.hide()
	peer.create_client("ws://" + $Menu/VBoxContainer/addressinp.text + ":" + str(PORT))
	multiplayer.multiplayer_peer = peer
	

@rpc("any_peer")
func ping_player(peer_id):
	print("Me %d got pinged by server" % [peer_id])
	share_player_properties.rpc_id(1,peer_id,nicknamenp.text,colornp.color)

@rpc("any_peer")	
func share_player_properties():
	pass

func spawn_player(peer_id,nickname,color):
	var player = preload("res://player.tscn").instantiate()
	player.set_multiplayer_authority(peer_id)
	player.nickname=nickname
	add_child(player)
	
@rpc
func remove_player(peer_id):
	get_node(str(peer_id)).queue_free()

@rpc
func spawn_new_player(peer_id,properties):
	spawn_player(peer_id,properties.nickname,properties.color)

	
@rpc
func spawn_old_players(database):
	for peer_id in database:
		spawn_player(peer_id,database[peer_id].nickname,database[peer_id].color)

