def contain_virus(grid)
    return 0 if grid.empty?
    height = grid.size
    width = grid[0].size
    answer = 0
    (0...height).each do |i|
        (0...width).each do |j|
            if 1 == grid[i][j]
                perimeter = 4
                # check top
                perimeter -= 1 if i-1 >= 0 && 1 == grid[i-1][j]
                # check right
                perimeter -= 1 if j+1 < width && 1 == grid[i][j+1]
                # check bottom
                perimeter -= 1 if i+1 < height && 1 == grid[i+1][j]
                # check left 
                perimeter -= 1 if j-1 >= 0 && 1 == grid[i][j-1]
                answer += perimeter
            end
        end
    end
    
    answer
    
end

isInfected = [[0,1,0,0],[1,1,1,0],[0,1,0,0],[1,1,0,0]]

# Call the function and store the result in a variable
result = contain_virus(isInfected)

# Print the result
puts "Number of walls needed: #{result}"