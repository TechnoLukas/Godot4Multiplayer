#https://github.com/Kermer/Godot/blob/master/Tutorials/tut_tcp_data_transfer.md
#https://gist.github.com/WeaponsTheyFear/6d6a43cd39eee7010fc5c5a8393e5117

extends Node

# What region will we be connecting to?
var region: String = "Local"

# Dictionary of server regions containing their matching ip/port
var _server_dict: Dictionary = {
	"Local": ["127.0.0.1", 4242],
	"US": ["127.0.0.1", 4242]
}

var cnt = 0

var connection
var connected = false

func _ready():
	var ip = _server_dict[region][0]
	var port = _server_dict[region][1]
	
	#coding 
	var jstr = JSON.stringify(_server_dict)
	var jstr_ascii = jstr.to_ascii_buffer()
	#decoding
	var jstr2 = jstr_ascii.get_string_from_ascii()
	var d2:Dictionary = JSON.parse_string(jstr2)

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

func _process( delta ):
	var ip = _server_dict[region][0]
	var port = _server_dict[region][1]
	
	connection.poll()

	if !connected:
		if connection.get_status() == connection.STATUS_CONNECTED:
			print("Process connected to " + ip + " : " + str(port))
			connected = true
			return
	
	if connection.get_status() == connection.STATUS_NONE or connection.get_status() == connection.STATUS_ERROR:
		print("Server disconnected?")
		connected = false
		set_process(false)#!!!!!
		return
	
	var available_bytes: int = connection.get_available_bytes()
	if available_bytes > 0:
		#print("available bytes: ", available_bytes)
		var data: Array = connection.get_partial_data(available_bytes)
		# Check for read error.
		if data[0] != OK:
			print("Error getting data from stream: ", data[0])
		else:
			print(str(data[1].get_string_from_ascii()))
	
	cnt+=1
	if cnt >=300:
		cnt=0
		var jstr = JSON.stringify(_server_dict)
		var jstr_ascii = jstr.to_ascii_buffer()
		connection.put_data(jstr_ascii)
		#connection.put_data("Hello server".to_ascii_buffer())

		

