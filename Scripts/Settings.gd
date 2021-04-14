extends Node

# This file can be accessed by doing Settings.<variable-name> anywhere in code

# Global Game Variables
var cash = 75
var level = 1
var paused = false

# Tower Defense Variables
var drones_destroyed = 0
var td_level = 1
var tower_type_selected = "normal"
var tower_positions = [] # Keeps a list of all the positions currently occupied by a tower
var current_towers_info = [] # Keeps a list of dictionaries containing information about each placed tower
var tower_costs = {
	"normal": 25,
	"type2": 100,
}

# Dig Dug Variables
var player_speed = 200
var player_shoot_rate = 2
var time_added_per_wafer = 0.5
var cash_per_wafer = 5
var upgrade_costs = {
	"speed": 20,
	"rate": 20,
	"time": 20,
	"wafers": 20,
}
