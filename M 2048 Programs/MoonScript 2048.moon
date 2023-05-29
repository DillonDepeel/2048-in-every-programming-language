-- initialization
size = 4 -- board size
score = 0 -- current score
won = false -- boolean for winning
target = 2048 -- as the game title says
for r = 1, size do
  for c = 1, size do
    _G["X_" .. r .. "_" .. c] = 0
  end
end

-- add two numbers in the board
addtile()
addtile()

-- main game loop
while true do
  display()
  print("\nKeys: WASD (Slide Movement), N (New game), P (Exit)")

  -- get keypress trick
  local key = io.read(1)

  local changed = false -- boolean for changed board
  local valid_key = false -- boolean for pressing WASD
  -- process keypress
  if key == "w" then
    valid_key = true
    slide("C", "1,1," .. size, "X")
  elseif key == "a" then
    valid_key = true
    slide("R", "1,1," .. size, "X")
  elseif key == "s" then
    valid_key = true
    slide("C", size .. ",-1,1", "X")
  elseif key == "d" then
    valid_key = true
    slide("R", size .. ",-1,1", "X")
  elseif key == "n" then
    size = 4
    score = 0
    won = false
    target = 2048
    for r = 1, size do
      for c = 1, size do
        _G["X_" .. r .. "_" .. c] = 0
      end
    end
    addtile()
    addtile()
  elseif key == "p" then
    os.exit()
  end

  if not valid_key then
    goto continue
  end

  -- check if the board changed
  if changed then
    addtile()
  end

  -- check for win condition
  if won then
    print("Nice one... You WON!")
    os.exit()
  end

  -- check for lose condition
  local blank_count = 0 -- blank tile counter
  local LX = {} -- to be used for checking lose condition
  for r = 1, size do
    for c = 1, size do
      LX[r .. "_" .. c] = _G["X_" .. r .. "_" .. c]
      if _G["X_" .. r .. "_" .. c] == 0 then
        blank_count = blank_count + 1
      end
    end
  end
  local save_changed = changed -- save actual changed for test
  slide("C", "1,1," .. size, "LX")
  slide("R", "1,1," .. size, "LX")
  if not changed then
    print("No moves are possible... Game Over :(")
    os.exit()
  else
    changed = save_changed
  end

  ::continue::
end

-- add number to a random blank tile
function addtile()
  local blank_count = 0 -- blank tile counter
  local blank_tiles = {} -- create pseudo-array blank_tiles
  for r = 1, size do
    for c = 1, size do
      if _G["X_" .. r .. "_" .. c] == 0 then
        blank_count = blank_count + 1
        blank_tiles[blank_count] = "X_" .. r .. "_" .. c
      end
    end
  end
  if blank_count == 0 then
    return
  end
  local pick_tile = math.random(blank_count)
  local new_tile = blank_tiles[pick_tile]
  local rnd_newnum = math.random(10)
  -- 10% chance new number is 4, 90% chance it's 2
  if rnd_newnum == 5 then
    _G[new_tile] = 4
  else
    _G[new_tile] = 2
  end
end

-- display the board
function display()
  os.execute("cls")
  print("2048 Game in Batch\n")
  local wall = "+----"
  for c = 2, size do
    wall = wall .. "+----"
  end
  print(wall .. "+")
  for r = 1, size do
    local disp_row = "|"
    for c = 1, size do
      local curr_tile = _G["X_" .. r .. "_" .. c]
      local DX = ""
      if curr_tile == new_tile then
        DX = "  +" .. curr_tile .. "+"
      else
        DX = " " .. curr_tile
        if curr_tile < 1000 then
          DX = " " .. DX
        end
        if curr_tile < 100 then
          DX = " " .. DX
        end
        if curr_tile < 10 then
          DX = " " .. DX
        end
        if curr_tile == 0 then
          DX = "    "
        end
        DX = "|" .. DX .. "|"
      end
      disp_row = disp_row .. DX
    end
    print(disp_row)
    print(wall .. "+")
  end
  print("\nScore: " .. score)
end

-- the main slider of numbers in tiles
function slide(direction, range, table_name)
  -- A and B are used here because sliding direction is variable
  for A in range:gmatch("%d+") do
    -- first slide: removing blank tiles in the middle
    local slide_1 = {}
    local last_blank = false -- boolean if last tile is blank
    for B in range:gmatch("%d+") do
      local curr_tilenum = nil
      if direction == "R" then
        curr_tilenum = _G[table_name .. "_" .. A .. "_" .. B]
      elseif direction == "C" then
        curr_tilenum = _G[table_name .. "_" .. B .. "_" .. A]
      end
      if curr_tilenum == 0 then
        last_blank = true
      else
        slide_1[#slide_1 + 1] = curr_tilenum
