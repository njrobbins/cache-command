extends Node

# This file can be accessed by doing Settings.<variable-name> anywhere in code

# Global Game Variables
var cash = 50
var level = 1

# Tower Defense Variables
var drones_destroyed = 0
var tower_type_selected = "normal"
var tower_positions = [] # Keeps a list of all the positions currently occupied by a tower
var current_towers_info = [] # Keeps a list of dictionaries containing information about each placed tower

# Dig Dug Variables
