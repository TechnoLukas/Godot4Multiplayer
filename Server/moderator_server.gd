extends Node

const port = 4242
 
signal command(value)

var server # for holding your TCP_Server object
var connection = [] # for holding multiple connection (StreamPeerTCP) objects
var database = {}

func _ready():
	print("|----------------------- INFO -----------------------|")
	server = TCPServer.new()
	print("-- TCPServer --")
	if server.listen(port) == 0:
		print("TCPServer started at port "+str(port)); 
	else:
		print( "Failed to start server on port "+str(port) ); 

func _process( _delta ):
	if server.is_connection_available(): # check if someone's trying to connect
		var client = server.take_connection() # accept connection
		connection.append( client ) # we need to store him somewhere, that's why we created our Array
		print( "Client has connected!" + str(len(connection))); 
		send_dict(database)
		
	for i in range (len(connection)):
		connection[i].poll()
		if connection[i].get_available_bytes()>0:
			var data = connection[i].get_data(connection[i].get_available_bytes())
			if data[0]!=OK:
				print("Error data",data[0])
			else:
				#print(data[1])
				var cmd = str(data[1].get_string_from_ascii())
				command.emit(cmd)
				print(cmd)
				#var d2= JSON.parse_string(js)
				#print(d2,typeof(d2))
				# Answer to client 
				

	for client in connection:
		client.poll()#!
		if client.get_status() != client.STATUS_CONNECTED: # NOT connected
			print("Client disconnected")
			var index = connection.find( client )
			connection.pop_at( index ) # remove his connection

func send_dict(dict):
	database = dict
	var databasejs = JSON.stringify(dict).to_ascii_buffer()
	for i in range (len(connection)):
		connection[i].put_data(databasejs)# handshake
		
