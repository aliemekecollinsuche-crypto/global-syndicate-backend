extends Node2D

# Territory Attributes
@export var zone_id : String = "USA_TEXAS_01"
@export var country_code : String = "USA"
@export var controlling_leader_id : String = ""

# DEFCON State Management
enum DefconLevel { NORMAL = 3, ELEVATED = 2, LOCKDOWN = 1 }
var current_defcon : DefconLevel = DefconLevel.NORMAL

# Called when a heist or breach is detected in this state
func trigger_sector_lockdown():
	current_defcon = DefconLevel.LOCKDOWN
	print("DEFCON 1 LOCKDOWN TRIGGERED: Zone ", zone_id)
	_seal_utn_border_gates(true)

# Called when the sector threat is neutralized
func normalize_sector():
	current_defcon = DefconLevel.NORMAL
	print("DEFCON 3 NORMALIZED: Zone ", zone_id)
	_seal_utn_border_gates(false)

# Internal helper to lock/unlock local UTN glass tube gates
func _seal_utn_border_gates(locked : bool):
	var gates = get_tree().get_nodes_in_group("utn_gates_" + zone_id)
	for gate in gates:
		if gate.has_method("set_gate_lock"):
			gate.set_gate_lock(locked)
