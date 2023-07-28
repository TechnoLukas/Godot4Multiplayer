extends Control

@onready var list = $"../Panel"
var database

const PORT=7777
var peer = WebSocketMultiplayerPeer.new()
var y = 0
var ys = 55

func _init():
	pass
	#peer.supported_protocols = ["ludus"]
	
func _ready():
	peer.create_client("ws://" + "localhost" + ":" + str(PORT))
	multiplayer.multiplayer_peer = peer

func spawn_player(peer_id,properties):
	var player = preload("res://player.tscn").instantiate()
	player.set_multiplayer_authority(peer_id)
	add_child(player)
	player.position.y=y
	y=y+ys
	player.set_proprties(properties.nickname,peer_id,properties.color)

@rpc
func sharedatabase(dt):
	database = dt
	print(database)
