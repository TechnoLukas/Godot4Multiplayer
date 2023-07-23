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
	print("server started")

func player_connected(peer_id):
	print(peer_id, " connected")
	#add_connected_player.rpc_id(peer_id)
	
func add_player(peer_id):
	var player = preload("res://player.tscn").instantiate()
	player.set_multiplayer_authority(peer_id)
	add_child(player)
	
@rpc
func add_connected_player(peer_id):
	pass
