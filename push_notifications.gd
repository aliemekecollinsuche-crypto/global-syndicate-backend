extends Node

# Firebase Cloud Messaging / Native Push Plugin Reference
var push_plugin = null
var device_token : String = ""

# Signal emitted when device token is generated or refreshed
signal device_token_registered(token)
signal notification_received(title, body, payload)

func _ready():
	if Engine.has_singleton("GodotFCMPlugin"):
		push_plugin = Engine.get_singleton("GodotFCMPlugin")
		_connect_notification_signals()
		push_plugin.initialize()
		print("Push Notification Plugin Initialized.")
	else:
		print("Push Notification Plugin not present on desktop/simulated build.")

func _connect_notification_signals():
	push_plugin.token_received.connect(_on_token_received)
	push_plugin.notification_opened.connect(_on_notification_opened)

func _on_token_received(token: String):
	device_token = token
	print("Registered Device Token: ", device_token)
	emit_signal("device_token_registered", device_token)
	_sync_token_with_backend(device_token)

# Send device token to Node.js backend (server.js) so backend can target this device
func _sync_token_with_backend(token: String):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	var endpoint = "http://localhost:3000/api/notifications/register-device"
	var headers = ["Content-Type: application/json"]
	var payload = JSON.stringify({
		"playerId": "CURRENT_PLAYER_UUID",
		"deviceToken": token
	})
	
	http_request.request(endpoint, headers, HTTPClient.METHOD_POST, payload)

func _on_notification_opened(payload_json: String):
	var json = JSON.new()
	if json.parse(payload_json) == OK:
		var data = json.data
		var title = data.get("title", "ALERT")
		var body = data.get("body", "Sovereign Event Active!")
		print("Notification Clicked: ", title, " - ", body)
		emit_signal("notification_received", title, body, data)
