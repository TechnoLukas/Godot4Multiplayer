extends Node3D

const PORT=9998
var peer = WebSocketMultiplayerPeer.new()

func _init():
	pass
	
func _ready():
	peer.create_client("ws://" + "localhost" + ":" + str(PORT))
	multiplayer.multiplayer_peer = peer

