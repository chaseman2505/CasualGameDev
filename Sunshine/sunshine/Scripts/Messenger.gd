extends Node

var current_level: String=""
var levelComplete = false
# Called when the node enters the scene tree for the first time.

signal message_broadcasted(content: String)

func broadcast(content: String):
	current_level = content
	message_broadcasted.emit(content)
	print("Broadcast sent: ", content)
