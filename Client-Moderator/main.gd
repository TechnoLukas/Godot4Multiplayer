extends Control

@onready var list = $Panel2/List

const PORT=9999
var peer = WebSocketMultiplayerPeer.new()
var y = 0
var ys = 55

func _init():
	peer.supported_protocols = ["ludus"]
	
func _ready():
	peer.create_client("ws://" + "localhost" + ":" + str(PORT))
	multiplayer.multiplayer_peer = peer
	

@rpc("any_peer")
func ping_player(peer_id):
	pass

@rpc("any_peer")	
func share_player_properties():
	pass

func spawn_player(peer_id,properties):
	var player = preload("res://player.tscn").instantiate()
	list.add_child(player)
	player.position.y=y
	y=y+ys
	player.set_proprties(properties.nickname,peer_id,properties.color)

@rpc
func spawn_new_player(peer_id,properties):
	spawn_player(peer_id,properties)

@rpc
func spawn_old_players(database):
	for peer_id in database:
		spawn_player(peer_id,database[peer_id])
	
@rpc("any_peer")
func remove_player(peer_id):
	pass

@rpc("any_peer")
func share_point_properties(_p_name, _p_position, _p_color):
	pass

@rpc
func spawn_new_point(properties):
	pass
	
@rpc
func spawn_old_points(database):
	pass
	


