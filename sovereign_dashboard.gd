extends Control

# UI Node References (Control Hierarchy)
@onready var global_tax_label = $MarginContainer/VBoxContainer/Header/TaxRevenueLabel
@onready var defcon_status_label = $MarginContainer/VBoxContainer/StatusContainer/DefconLabel
@onready var lockdown_button = $MarginContainer/VBoxContainer/Actions/GlobalLockdownBtn
@onready var http_request = $HTTPRequest

# Real-Time Telemetry Data
var total_treasury_tax : float = 0.0
var active_heist_count : int = 0

func _ready():
	lockdown_button.pressed.connect(_on_global_lockdown_pressed)
	_refresh_sovereign_telemetry()

# Fetch latest global statistics from Node.js backend
func _refresh_sovereign_telemetry():
	var endpoint = "http://localhost:3000/api/sovereign/dashboard-stats"
	var headers = ["Content-Type: application/json"]
	http_request.request(endpoint, headers, HTTPClient.METHOD_GET)

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.new()
		if json.parse(body.get_string_from_utf8()) == OK:
			var data = json.data
			total_treasury_tax = data.get("totalTaxRevenue", 0.0)
			active_heist_count = data.get("activeHeists", 0)
			_update_ui_display()

func _update_ui_display():
	global_tax_label.text = "GLOBAL TREASURY TAX: $" + str(total_treasury_tax)
	if active_heist_count > 0:
		defcon_status_label.text = "DEFCON 2: " + str(active_heist_count) + " HEIST(S) ACTIVE"
		defcon_status_label.modulate = Color(1, 0.5, 0) # Orange Alert
	else:
		defcon_status_label.text = "DEFCON 3: GLOBAL NETWORK SECURE"
		defcon_status_label.modulate = Color(0, 1, 0) # Green Operational

# Emergency Action: Trigger Global Lockdown across all 195 sectors
func _on_global_lockdown_pressed():
	print("SOVEREIGN OVERRIDE: INITIATING GLOBAL DEFCON 1 LOCKDOWN...")
	var endpoint = "http://localhost:3000/api/sovereign/trigger-global-lockdown"
	var headers = ["Content-Type: application/json"]
	var payload = JSON.stringify({"sovereignOverride": true})
	http_request.request(endpoint, headers, HTTPClient.METHOD_POST, payload)
