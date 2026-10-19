extends Node

# Base API Configuration
var api_url : String = "http://localhost:3000/api" # Change to production domain when live
var http_request : HTTPRequest

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

# Function to Pay UTN Toll Gate Fee
func pay_utn_toll(player_id: String, route_id: String, toll_fee: int):
	var endpoint = api_url + "/utn/pay-toll"
	var headers = ["Content-Type: application/json"]
	var payload = JSON.stringify({
		"playerId": player_id,
		"routeId": route_id,
		"tollFee": toll_fee
	})
	
	var err = http_request.request(endpoint, headers, HTTPClient.METHOD_POST, payload)
	if err != OK:
		print("Error initializing HTTP request: ", err)

# Signal callback handling API responses
func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(body.get_string_from_utf8())
		if parse_result == OK:
			var response = json.data
			print("UTN Gate Authorization Success: ", response.get("message"))
	else:
		print("UTN Gate Lock Triggered! Response Code: ", response_code)
