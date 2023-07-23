extends Node3D

const Player=preload("res://player.tscn")
const PORT=9999

var peer = WebSocketMultiplayerPeer.new()
var database = {}

func _init():
	peer.supported_protocols = ["ludus"]

func _ready():
	peer.create_server(PORT)
	multiplayer.multiplayer_peer=peer
	multiplayer.peer_connected.connect(peer_connected)
	print(multiplayer.get_unique_id())

func peer_connected(peer_id):
	ping_player.rpc_id(peer_id,peer_id)
	
@rpc("any_peer")
func ping_player(peer_id):
	pass
	
@rpc("any_peer")	
func share_player_properties(peer_id,nickname, color):
	database[peer_id]={"nickname":nickname,"color":color}
	print(database)
