extends Node3D

const PORT=9999

var peer = WebSocketMultiplayerPeer.new()
var playerloadingprog = {}
var database = {}
var pointsdatabase = []

@onready var list = $player_list

func _init():
	pass
	#peer.supported_protocols = ["ludus"]

func _ready():
	load_pointdatabase()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer=peer
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	get_tree().set_auto_accept_quit(false)
	
	moderator_server.connect("command", _command)

func peer_connected(peer_id):
	ping_player.rpc_id(peer_id,peer_id)

func peer_disconnected(peer_id):
	remove_player.rpc(peer_id,"you got kicked from the server")
	database.erase(peer_id) 
	moderator_server.send_dict(database)
	
@rpc("any_peer")	
func share_player_properties(peer_id,nickname, color):
	playerloadingprog[peer_id]=0
	spawn_old_players.rpc_id(peer_id,database)
	loading(peer_id,nickname, color, pointsdatabase)
	

func loading(peer_id,nickname, color, pdt):
	print("pdt ",pdt)
	var loadingpointsdatabase = pdt.slice(playerloadingprog[peer_id],pdt.size()-1)
	var cut = 2 #1000
	var cut_per = snapped(100.0/((loadingpointsdatabase.size()/cut)+1),0.1)
	print("size: ",loadingpointsdatabase.size()," persantage: " ,cut_per)
	
	if pdt.size()<cut:
		print(loadingpointsdatabase)
		spawn_old_points.rpc_id(peer_id,pdt,100.0,true)
		playersp(peer_id,nickname, color)
	if loadingpointsdatabase.size()>cut:
		for i in range(loadingpointsdatabase.size()/cut):
			var finished
			var slice = loadingpointsdatabase.slice(cut*i,cut*i+cut)
			var persantage
			if i == (loadingpointsdatabase.size()/cut)-1:
				persantage=100.0
				finished=true
				playersp(peer_id,nickname, color)
				print("DONE")
			else:
				persantage = i*cut_per
				finished=false
				
			spawn_old_points.rpc_id(peer_id,slice,persantage,finished)
			playerloadingprog[peer_id]=playerloadingprog[peer_id]+slice.size()
			print("loading: ", persantage,"% ",slice.size()," ", i, "/", loadingpointsdatabase.size()/cut)
			
			if playerloadingprog[peer_id] == loadingpointsdatabase.size():
				print("loaded but something left")
			
			await get_tree().create_timer(0.001).timeout #Delay because of packs staking on the client's side.
	

func playersp(peer_id,nickname,color):
	spawn_new_player.rpc(peer_id,{"nickname":nickname,"color":color})
	spawn_player_dummy(peer_id)
	database[peer_id]={"nickname":nickname,"color":color}
	moderator_server.send_dict(database)
	
	
func spawn_player_dummy(peer_id):
	var player = preload("res://player_dummy.tscn").instantiate()
	player.set_multiplayer_authority(peer_id)
	list.add_child(player)

func _command(cmd):
	if cmd.split(" ")[0] == "kick":
		peer_disconnected(int(cmd.split(" ")[1]))
		await get_tree().create_timer(0.1).timeout
		peer.disconnect_peer(int(cmd.split(" ")[1]))
		#remove_player.rpc(int(cmd.split(" ")[1]))

@rpc("any_peer")
func share_point_properties(p_position, p_color):
	pointsdatabase.append([p_position,p_color])
	spawn_new_point.rpc([p_position,p_color])
	print(pointsdatabase.size())
	save_pointdatabase()
	

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
func remove_player(peer_id):
	if get_node_or_null(str(peer_id)):
		get_node(str(peer_id)).queue_free()
	
@rpc 
func spawn_new_point(_properties):
	pass
	
@rpc
func spawn_old_points(_database,_proggressn,_finished):
	pass
	
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_pointdatabase()
		get_tree().quit() # default behavior
		
func save_pointdatabase():
	var file = FileAccess.open("pointdatabase.bin", FileAccess.WRITE)
	var content = pointsdatabase
	file.store_var(content)

func load_pointdatabase():
	var file = FileAccess.open("pointdatabase.bin", FileAccess.READ)
	var content = file.get_as_text()
	if content == "":
		var file2 = FileAccess.open("pointdatabase.bin", FileAccess.WRITE)
		var content2 = [[Vector3(0,0,0),Color(0,0,0)]]
		file2.store_var(content2)
	content = file.get_var()
	pointsdatabase=content
