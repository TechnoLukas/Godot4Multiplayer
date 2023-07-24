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

func spawn_player(peer_id):
	var player = preload("res://player.tscn").instantiate()
	player.set_multiplayer_authority(peer_id)
	add_child(player)

@rpc
func spawn_new_player(peer_id):
	spawn_player(peer_id)

	
@rpc
func spawn_old_players(peer_ids):
	print(peer_ids)
	for peer_id in peer_ids:
		spawn_player(peer_id)

