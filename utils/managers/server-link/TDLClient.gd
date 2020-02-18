extends Node

signal message_received(type, message)

export var distant_server_url := "127.0.0.1:5700"

var _client := WebSocketClient.new()

func _ready() -> void:
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	
	_client.connect("data_received", self, "_on_data")

	var err = _client.connect_to_url(distant_server_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)


func _closed(was_clean = false) -> void:
	print("Closed, clean: ", was_clean)
	set_process(false)


func _connected(proto = "") -> void:
	print("Connected with protocol: ", proto)


func _on_data() -> void:
	var data := _client.get_peer(1).get_packet().get_string_from_utf8()
	var dict = parse_json(data)

	# Check if the message structure is valid
	if dict != null \
			and dict.type != null \
			and dict.message != null:
		var m := TDLMessage.new(dict.type, dict.message)
		emit_signal("message_received", m)


func _process(_delta) -> void:
	_client.poll()


func send_message(message : String) -> int :
	return _client.get_peer(1).put_packet(message.to_utf8())