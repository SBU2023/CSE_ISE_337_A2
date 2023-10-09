class Region
        attr_accessor :infected, :uninfected, :walls
        
        def initialize
            @infected = Set.new
            @uninfected = Set.new
            @walls = 0
        end
    end

def contain_virus(is_infected)
    re = is_infected.length
    ce = is_infected[0].length
    ans = 0

    while true
        holder = []
        v = Array.new(re) { Array.new(ce, false) }
        
        (0...re).each do |r|
            (0...ce).each do |c|
                if is_infected[r][c] == 1 && !v[r][c]
                    region = Region.new
                    get_region(is_infected, region, re, ce, v, r, c)
                    holder << region
                end
            end
        end
        
        index_of_max_uninfected = 0
        size_of_max_uninfected = 0
        
        holder.each_with_index do |region, i|
            if region.uninfected.size > size_of_max_uninfected
                size_of_max_uninfected = region.uninfected.size
                index_of_max_uninfected = i
            end
        end
        
        if holder.empty?
            break
        end
        
        max_set = holder[index_of_max_uninfected].infected
        
        max_set.each do |row_col|
            r = row_col / ce
            c = row_col % ce
            is_infected[r][c] = 2
        end
        
        ans += holder[index_of_max_uninfected].walls
        
        holder.each_with_index do |region, i|
            next if i == index_of_max_uninfected
            uninfected = region.uninfected
            
            uninfected.each do |row_col|
                r = row_col / ce
                c = row_col % ce
                is_infected[r][c] = 1
            end
        end
    end
    
    return ans
end

def get_region(is_infected, region, re, ce, v, r, c)
    dirs = [[0, 1], [1, 0], [0, -1], [-1, 0]]
    
    if r < 0 || c < 0 || r == re || c == ce || is_infected[r][c] == 2
        return
    end
    
    if is_infected[r][c] == 1
        if v[r][c]
            return
        end
        region.infected.add(r * ce + c)
    end
    
    if is_infected[r][c] == 0
        region.uninfected.add(r * ce + c)
        region.walls += 1
        return
    end
    
    v[r][c] = true
    
    dirs.each do |dir|
        nr = r + dir[0]
        nc = c + dir[1]
        get_region(is_infected, region, re, ce, v, nr, nc)
    end
end
