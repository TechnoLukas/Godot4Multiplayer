#https://github.com/Kermer/Godot/blob/master/Tutorials/tut_tcp_data_transfer.md

extends Node

const port = 4242
 

var server # for holding your TCP_Server object
var connection = [] # for holding multiple connection (StreamPeerTCP) objects
var peerstream = []
	

func _ready():
	server = TCPServer.new()
	if server.listen(port) == 0:
		print("Server started at port "+str(port)); 
		set_process(true)
	else:
		print( "Failed to start server on port "+str(port) ); 

func _process( _delta ):
	#print(server.is_listening())
	if server.is_connection_available(): # check if someone's trying to connect
		var client = server.take_connection() # accept connection
		connection.append( client ) # we need to store him somewhere, that's why we created our Array
		print( "Client has connected!" + str(len(connection))); 
		
	for i in range (len(connection)):
		connection[i].poll()
		if connection[i].get_available_bytes()>0:
			var data = connection[i].get_data(connection[i].get_available_bytes())
			if data[0]!=OK:
				print("Error data",data[0])
			else:
				var js = str(data[1].get_string_from_ascii())
				#print(data[1])
				#var dt= data[1]
				#print(dt)
				var d2:Dictionary = JSON.parse_string(js)
				print(d2,typeof(d2))
				# Answer to client 
				connection[i].put_data("Hello client".to_ascii_buffer())# handshake

	for client in connection:
		client.poll()#!
		if client.get_status() != client.STATUS_CONNECTED: # NOT connected
			print("Client disconnected")
			var index = connection.find( client )
			connection.pop_at( index ) # remove his connection

