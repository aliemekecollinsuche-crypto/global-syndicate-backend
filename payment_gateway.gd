extends Node

# Google Play Billing Plugin Reference
var payment_plugin = null

# In-App Purchase SKUs (Configured in Google Play Console)
const SKU_SOVEREIGN_PASS = "gs_sovereign_monthly_pass"
const SKU_UTN_SPEED_PASS = "gs_utn_450kph_pass"
const SKU_RAM_CHARGER_PACK = "gs_vehicle_ram_charger"

signal purchase_succeeded(sku_id, purchase_token)
signal purchase_failed(error_message)

func _ready():
	if Engine.has_singleton("GodotGooglePlayBilling"):
		payment_plugin = Engine.get_singleton("GodotGooglePlayBilling")
		_connect_billing_signals()
		payment_plugin.startConnection()
		print("Google Play Billing Plugin Initialized.")
	else:
		print("Google Play Billing Plugin not available on this platform.")

func _connect_billing_signals():
	payment_plugin.connected.connect(_on_billing_connected)
	payment_plugin.connect_failed.connect(_on_billing_connect_failed)
	payment_plugin.purchases_updated.connect(_on_purchases_updated)
	payment_plugin.purchase_consumed.connect(_on_purchase_consumed)

func _on_billing_connected():
	print("Successfully connected to Google Play Store!")
	# Query available products
	payment_plugin.querySkuDetails([SKU_SOVEREIGN_PASS, SKU_UTN_SPEED_PASS, SKU_RAM_CHARGER_PACK], "inapp")

# Call this function from your UI Store screen when player taps 'Buy'
func purchase_item(sku_id: String):
	if payment_plugin:
		var response = payment_plugin.purchase(sku_id)
		if response.status != OK:
			emit_signal("purchase_failed", "Failed to initiate purchase flow.")
	else:
		print("Billing plugin not connected. Purchase simulated.")

func _on_purchases_updated(purchases: Array):
	for purchase in purchases:
		if purchase.purchase_state == 1: # 1 = PURCHASED
			print("Purchase successful for SKU: ", purchase.sku)
			# Acknowledge or consume the purchase to complete transaction
			if purchase.sku == SKU_SOVEREIGN_PASS:
				payment_plugin.acknowledgePurchase(purchase.purchase_token)
			else:
				payment_plugin.consumePurchase(purchase.purchase_token)
			
			emit_signal("purchase_succeeded", purchase.sku, purchase.purchase_token)

func _on_purchase_consumed(purchase_token):
	print("Purchase token consumed successfully: ", purchase_token)

func _on_billing_connect_failed():
	print("Failed to connect to Google Play Billing.")
