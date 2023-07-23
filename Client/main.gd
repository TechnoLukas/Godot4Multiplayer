extends Node3D

const PORT=9999
const IPADRESS="192.168.8.129"

var peer = WebSocketMultiplayerPeer.new()

func _init():
	peer.supported_protocols = ["ludus"]

"""
func add_player(peer_id):
	var player = preload("res://player.tscn").instantiate()
	player.set_multiplayer_authority(peer_id)
	add_child(player)
"""
@rpc
func add_connected_player():
	print("client")
	set_multiplayer_authority(multiplayer.get_unique_id())
	print(is_multiplayer_authority(), " ", multiplayer.get_unique_id())
	spawn_player.rpc_id(1)

@rpc("any_peer")
func spawn_player():
	print("host")


func _on_join_pressed():
	peer.create_client("ws://" + IPADRESS + ":" + str(PORT))
	multiplayer.multiplayer_peer = peer
