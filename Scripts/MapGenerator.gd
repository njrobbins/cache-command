extends Reference

class_name Game
class MapGen:
	extends Reference

	static func getNeighbors(grid, row, col, num=1):
		"""Returns a count of all surrounding neighbors that are == to num argument. 8 possible neighbors"""
	
		var count = 0
		if grid[row - 1][col] == num:  # left
			count += 1
		if grid[row + 1][col] == num:  # right
			count += 1
		if grid[row][col - 1] == num:  # up
			count += 1
		if grid[row][col + 1] == num:  # down
			count += 1
	
		if grid[row - 1][col - 1] == num:  # left up
			count += 1
		if grid[row + 1][col - 1] == num:  # right up
			count += 1
		if grid[row - 1][col + 1] == num:  # left down
			count += 1
		if grid[row + 1][col + 1] == num:  # right down
			count += 1
	
		if count > 4:
			grid[row][col] = num
	
	
	static func smooth(grid, num=1, check=0):
		"""Smooths out grid. Checks each specified check # and decides whether to change it to the num
		   argument if it doesn't have the required number of neighbors"""
		for i in range(1, len(grid) - 1):
			for j in range(1, len(grid[i]) - 1):
				if grid[i][j] == check:
					getNeighbors(grid, i, j, num)
	
		return grid
	
	
	static func genMapFromSeed(rows, columns, _seeed="seed", fillrate=32):
		"""Generates a grid from a random seed, can specify rows, columns, seed, fill rate"""
		randomize()
		var grid = []
		for _i in range(columns + 30):
			grid.append([])
	
	
		for i in grid:
			for _x in range(rows + 30):
				if (range(1,101)[randi()%range(1,101).size()] < fillrate):
					i.append(1)
				else:
					i.append(0)
					
		for i in range(rows):
			# Fill top and bottom rows
			grid[0][i] = 0
			grid[len(grid) - 1][i] = 0

		for i in range(columns):
			grid[i][0] = 0
			grid[i][len(grid[0]) - 1] = 0
	
		return grid
	
	
	static func generateMap(grid):
		"""Runs the smooth operations"""
	
		var changes = 0
	
		while changes < 6:
			grid = smooth(grid)
			grid = smooth(grid, 0, 1)
			changes += 1
	
		return grid
	
	
	static func getMap(rows, columns, seeed="rand", fillrate=55):
		var seedmap = genMapFromSeed(rows, columns, seeed, fillrate)
		var grid = generateMap(seedmap)
	
		return grid
	
	
