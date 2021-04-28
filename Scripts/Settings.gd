extends Node

# This file can be accessed by doing Settings.<variable-name> anywhere in code

# Global Game Variables
var level = 1
var paused = false

# Tower Defense Variables
var drones_destroyed = 0
var td_level = 1
var tower_type_selected = "copperhead"
var upgrade_panel_attached = false

# Keeps a list of all the positions currently occupied by a tower on a level
var tower_positions = {
	"1": [],
	"2": [],
	"3": [],
	"4": [],
	"5": [],
	"6": [],
	"7": [],
	"8": [],
	"9": [],
	"10": [],
}

# Keeps a list of dictionaries containing information about each placed tower
var current_towers_info = {
	"1": [],
	"2": [],
	"3": [],
	"4": [],
	"5": [],
	"6": [],
	"7": [],
	"8": [],
	"9": [],
	"10": [],
}

var tower_stats = {
	# THESE ALL REP. THE STARTING BASE STATS. Upgrade costs will dynamically change for each tower as level increases
	"copperhead": {
		"cost": 25,
		"base_range": 250, 
		"base_rate": 4,
		"range_upgrade_base_cost": 10, # How much the first upgrade costs
		"speed_upgrade_base_cost": 10,
		"range_cost_added": 5, # How much cost is added follows formula: cost += range_cost_added + level * range_cost_added
		"speed_cost_added": 5,
		"range_amt_per_level": 25, # How much range is added per level bought
		"speed_amt_per_level": 1,
	},
	"steel": {
		"cost": 100,
		"base_range": 350,
		"base_rate": 8,
		"range_upgrade_base_cost": 10,
		"speed_upgrade_base_cost": 10,
		"range_cost_added": 5, 
		"speed_cost_added": 5,
		"range_amt_per_level": 25,
		"speed_amt_per_level": 1,
	},
	"moon": {
		"cost": 75,
		"base_range": 325,
		"base_rate": 6,
		"range_upgrade_base_cost": 10,
		"speed_upgrade_base_cost": 10,
		"range_cost_added": 5, 
		"speed_cost_added": 5,
		"range_amt_per_level": 25,
		"speed_amt_per_level": 1,
	},
	"doubletrouble": {
		"cost": 150,
		"base_range": 400,
		"base_rate": 10,
		"range_upgrade_base_cost": 10,
		"speed_upgrade_base_cost": 10,
		"range_cost_added": 5, 
		"speed_cost_added": 5,
		"range_amt_per_level": 25,
		"speed_amt_per_level": 1,
	},
}

var tower_mob_stats  = {
	"normal": {
		"speed": 100,
		"hp": 10,
	},
	"big": {
		"speed": 100,
		"hp": 50,
	},
	"fast": {
		"speed": 140,
		"hp": 15,
	},
} 


var tower_map_variables = {
	"base_cash": 120, # The starting cash amount
	"refund_multiplier": 0.5, # The percentage of cash refunded by recycling a tower
	"base_hp": 20, # The amount of health the base has before game over
	"base_mob_time": 0.62, # The amount of time between each mob being spawned (i.e. a mob spawns every 0.5 seconds)
	"mob_time_multiplier_per_level": 0.95, # Adjusts mob time to be lower each level. The lower mob time the more difficult
										  # Lowering this number will drastically increase difficulty BE CAREFUL
	"starting_wave_mobs": [3, 3, 3, 3, 5], # How many mobs will spawn in each wave (i.e 4 then 4 then 4 then 4 then 6)
	"mobs_added_each_wave_per_level": 5, # How many mobs get added to each wave i.e 4 will go to 10
	"levels_til_level_swap": 5, # How many levels are played on each set of maps. i.e you'll play 5 times on the same map, then switch
	"cash_bonus_after_swap": 500, # How much money you get afer getting to a level swap. i.e 300 after 5
}
var mob_time = tower_map_variables["base_mob_time"]
var base_hp = tower_map_variables["base_hp"]
var cash = tower_map_variables["base_cash"]

# Dig Dug Variables
var base_dd_stats = {
	"player_speed": 200,
	"player_shoot_rate": 2,
	"time_added_per_wafer": 0.5,
	"cash_per_wafer": 5,
	"base_upgrade_costs": {
		"speed": 20,
		"rate": 30,
		"time": 50,
		"wafers": 50,
	}
}
var player_speed = base_dd_stats['player_speed']
var player_shoot_rate = base_dd_stats['player_shoot_rate']
var time_added_per_wafer = base_dd_stats['time_added_per_wafer']
var cash_per_wafer = base_dd_stats['cash_per_wafer']
var upgrade_costs = base_dd_stats['base_upgrade_costs']

func resetGameSettings():
	cash = tower_map_variables["base_cash"]
	level = 1
	paused = false
	# Tower Defense Variables
	drones_destroyed = 0
	td_level = 1
	mob_time = tower_map_variables["base_mob_time"]
	tower_type_selected = "copperhead"
	tower_positions = {
		"1": [],
		"2": [],
		"3": [],
		"4": [],
		"5": [],
		"6": [],
		"7": [],
		"8": [],
		"9": [],
		"10": [],
	}
	current_towers_info = {
		"1": [],
		"2": [],
		"3": [],
		"4": [],
		"5": [],
		"6": [],
		"7": [],
		"8": [],
		"9": [],
		"10": [],
	}
	# Dig Dug variables
	player_speed = base_dd_stats['player_speed']
	player_shoot_rate = base_dd_stats['player_shoot_rate']
	time_added_per_wafer = base_dd_stats['time_added_per_wafer']
	cash_per_wafer = base_dd_stats['cash_per_wafer']
	upgrade_costs = base_dd_stats['base_upgrade_costs']
