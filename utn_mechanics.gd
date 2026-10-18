extends Node

# --- UTN TOLL PROCESSING LOGIC ---
func process_utn_toll(player_id: String, route_id: String, toll_fee: int, apex_tax_rate: float) -> bool:
	var player_vault = Supabase.from("player_vaults").select("cash_balance").eq("player_id", player_id).single()
	
	if player_vault.data == null or player_vault.data["cash_balance"] < toll_fee:
		print("UTN Barrier Lock: Insufficient Vault Funds")
		return false # Deny entry / Lock Toll Gate
		
	var apex_share = int(toll_fee * apex_tax_rate)
	var controller_share = toll_fee - apex_share
	var new_balance = player_vault.data["cash_balance"] - toll_fee
	
	# 1. Deduct toll fee from player vault
	Supabase.from("player_vaults").update({"cash_balance": new_balance}).eq("player_id", player_id)
	
	# 2. Deposit tax share into destination Apex Tower vault
	Supabase.rpc("deposit_apex_tax", {"p_route_id": route_id, "p_tax_amount": apex_share})
	
	print("UTN Gate Unlocked: Toll Paid successfully")
	return true # Raise gate & allow vehicle entrance


# --- VEHICLE UTN SPEED BOOST PHYSICS ---
extends CharacterBody3D

@export var base_top_speed: float = 250.0 # Standard street speed (KPH)
@export var utn_boost_speed: float = 450.0 # Ocean tunnel boost speed (KPH)
@export var acceleration: float = 12.0

var current_max_speed: float = base_top_speed
var is_inside_utn_tunnel: bool = false

func _physics_process(delta: float) -> void:
	if is_inside_utn_tunnel:
		current_max_speed = move_toward(current_max_speed, utn_boost_speed, acceleration * delta)
	else:
		current_max_speed = move_toward(current_max_speed, base_top_speed, acceleration * delta)
		
	velocity.z = clamp(velocity.z, -current_max_speed, current_max_speed)
	move_and_slide()

# Trigger detection when entering ocean glass tunnel
func _on_utn_tunnel_area_entered(area):
	if area.is_in_group("UTN_Tube"):
		is_inside_utn_tunnel = true

func _on_utn_tunnel_area_exited(area):
	if area.is_in_group("UTN_Tube"):
		is_inside_utn_tunnel = false
