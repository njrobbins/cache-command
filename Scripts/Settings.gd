extends Node

# This file can be accessed by doing Settings.<variable-name> anywhere in code

# Global Game Variables
var cash = 75
var level = 1
var paused = false

# Tower Defense Variables
var drones_destroyed = 0
var td_level = 1
var tower_type_selected = "copperhead"
# Keeps a list of all the positions currently occupied by a tower on a level
var tower_positions = {
	"1": [],
	"2": [],
	"3": [],
}

# Keeps a list of dictionaries containing information about each placed tower
var current_towers_info = {
	"1": [],
	"2": [],
	"3": [],
}
var tower_costs = {
	"copperhead": 25,
	"steel": 100,
	"moon": 100,
	"doubletrouble": 100,
}
var mob_time = 0.5

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
