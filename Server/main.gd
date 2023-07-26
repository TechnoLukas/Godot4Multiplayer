extends Node3D

const Player=preload("res://player.tscn")
const PORT=9999

var peer = WebSocketMultiplayerPeer.new()
var database = {}
var pointsdatabase = {}

func _init():
	peer.supported_protocols = ["ludus"]

func _ready():
	peer.create_server(PORT)
	multiplayer.multiplayer_peer=peer
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)

func peer_connected(peer_id):
	ping_player.rpc_id(peer_id,peer_id)
	
func peer_disconnected(peer_id):
	database.erase(peer_id)
	remove_player.rpc(peer_id)
	
@rpc("any_peer")	
func share_player_properties(peer_id,nickname, color):
	spawn_old_players.rpc_id(peer_id,database)
	spawn_old_points.rpc_id(peer_id,pointsdatabase)
	database[peer_id]={"nickname":nickname,"color":color}
	spawn_new_player.rpc(peer_id,database[peer_id])
	

	spawn_fake_player(peer_id)
	print(database)
	
func spawn_fake_player(peer_id):
	var player = preload("res://player.tscn").instantiate()
	player.set_multiplayer_authority(peer_id)
	add_child(player)

@rpc("any_peer")
func share_point_properties(p_name, p_position, p_color):
	pointsdatabase[p_name]={"position":p_position,"color":p_color}
	spawn_new_point.rpc(pointsdatabase[p_name])
	

@rpc("any_peer")
func ping_player(_peer_id):
	pass

@rpc
func spawn_new_player(_peer_id,_properties):
	pass
	
@rpc
func spawn_old_players(_database):
	pass
	
@rpc
func remove_player(_peer_id):
	pass
	
@rpc
func spawn_new_point(_properties):
	pass
	
@rpc
func spawn_old_points(database):
	pass
	
