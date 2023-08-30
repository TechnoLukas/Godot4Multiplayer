extends Node

var ip = "www.godot-games.info"
var port = 4242
var connection
var connected = false

func _ready():
	connection = StreamPeerTCP.new()
	connection.connect_to_host(ip, port)
	
	connection.poll()
	
	if connection.get_status() == connection.STATUS_CONNECTED:
		print("Successfully connected to the server")
		connected = true
	elif connection.get_status() == StreamPeerTCP.STATUS_CONNECTING:
		print("Trying to connect to " + ip + " : " + str(port))
	elif connection.get_status() == connection.STATUS_NONE or connection.get_status() == StreamPeerTCP.STATUS_ERROR:
		print("Error connecting to " + ip + " : " + str(port))

func _process(_delta):
	connection.poll()

	if !connected:
		if connection.get_status() == connection.STATUS_CONNECTED:
			print("Process connected to " + ip + " : " + str(port))
			connected = true
			return
	
	if connection.get_status() == connection.STATUS_NONE or connection.get_status() == connection.STATUS_ERROR:
		update_player_fields({})
		connected = false
		return
	
	if connection.get_available_bytes()>0:
		var data = connection.get_data(connection.get_available_bytes())
		if data[0]!=OK:
			print("Error data",data[0])
		else:			
			var database_deco = JSON.parse_string(data[1].get_string_from_ascii())
			var database_res = {}
			
			for i in database_deco:
				var peer = int(i)
				var nickname = database_deco[i]["nickname"]
				var colorlist = JSON.parse_string(database_deco[i]["color"].replace('(',"[").replace(')',"]"))
				var color = Color(colorlist[0],colorlist[1],colorlist[2],colorlist[3])
				database_res[peer]={"nickname":nickname,"color":color}
			update_player_fields(database_res)

func update_player_fields(database):
	var list = $Panel2/List
	var ypos = 0
	var ystep = 70
	
	for i in list.get_children():
		i.delete()
		list.remove_child(i)
		
	for i in database:
		var player_field = preload("res://player_field.tscn").instantiate()
		list.add_child(player_field)
		player_field.position.y = ypos
		ypos=ypos+ystep
		player_field.set_properties(database[i].nickname, i, database[i].color)
		
func send_command(command):
	connection.put_data(command.to_ascii_buffer())
		

		

