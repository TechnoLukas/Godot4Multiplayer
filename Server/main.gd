extends Node3D

const Player=preload("res://player.tscn")
const PORT=9999

var peer = WebSocketMultiplayerPeer.new()

func _init():
	peer.supported_protocols = ["ludus"]

func _ready():
	peer.create_server(PORT)
	multiplayer.multiplayer_peer=peer
	multiplayer.peer_connected.connect(player_connected)
	print(multiplayer.get_unique_id())

func player_connected(peer_id):
	add_connected_player.rpc_id(peer_id,peer_id)
	
@rpc
func add_player(peer_id):
	print("add_player ",peer_id)
	
@rpc
func add_connected_player(peer_id):
	pass
