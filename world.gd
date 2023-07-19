extends Node3D

@onready var main_menu = $Menu

@onready var nicknamenp = $Menu/VBoxContainer/nicknamenp
@onready var colornp = $Menu/VBoxContainer/ColorRect/HBoxContainer/Panel/ColorPickerButton

const Player=preload("res://player.tscn")
const PORT=9999

var peer = WebSocketMultiplayerPeer.new()

func _init():
	peer.supported_protocols = ["ludus"]
	
func _on_joinbt_pressed():
	main_menu.hide()
	multiplayer.multiplayer_peer = null
	peer.create_client("ws://" + $Menu/VBoxContainer/addressinp.text + ":" + str(PORT))
	multiplayer.multiplayer_peer = peer
	
	Global.nickname=nicknamenp.text
	Global.color=colornp.color

