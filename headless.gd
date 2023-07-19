extends Node3D

@onready var main_menu = $Menu

const Player=preload("res://player.tscn")
const PORT=9999

var peer = WebSocketMultiplayerPeer.new()

func _init():
	peer.supported_protocols = ["ludus"]

func _ready():
	main_menu.hide()
	multiplayer.multiplayer_peer=null
	peer.create_server(PORT)
	multiplayer.multiplayer_peer=peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	player.visible=false
	add_child(player)
	
func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
