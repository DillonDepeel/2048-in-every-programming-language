class Grid
  constructor: (size) ->
    @size = size
    @grid = new Array(size)
    for i in [0...size]
      @grid[i] = new Array(size)
      for j in [0...size]
        @grid[i][j] = 0

  addRandomTile: ->
    availableCells = []
    for i in [0...@size]
      for j in [0...@size]
        if @grid[i][j] is 0
          availableCells.push [i, j]

    if availableCells.length > 0
      [randomI, randomJ] = availableCells[Math.floor(Math.random() * availableCells.length)]
      @grid[randomI][randomJ] = if Math.random() < 0.9 then 2 else 4

  moveLeft: ->
    moved = false
    for i in [0...@size]
      for j in [1...@size]
        if @grid[i][j] isnt 0
          k = j - 1
          while k >= 0 and @grid[i][k] is 0
            @grid[i][k] = @grid[i][k + 1]
            @grid[i][k + 1] = 0
            k--
            moved = true
          if k >= 0 and @grid[i][k] is @grid[i][k + 1]
            @grid[i][k] *= 2
            @grid[i][k + 1] = 0
            moved = true
    moved

  moveRight: ->
    moved = false
    for i in [0...@size]
      for j in [@size - 2...-1] by -1
        if @grid[i][j] isnt 0
          k = j + 1
          while k < @size and @grid[i][k] is 0
            @grid[i][k] = @grid[i][k - 1]
            @grid[i][k - 1] = 0
            k++
            moved = true
          if k < @size and @grid[i][k] is @grid[i][k - 1]
            @grid[i][k] *= 2
            @grid[i][k - 1] = 0
            moved = true
    moved

  moveUp: ->
    moved = false
    for j in [0...@size]
      for i in [1...@size]
        if @grid[i][j] isnt 0
          k = i - 1
          while k >= 0 and @grid[k][j] is 0
            @grid[k][j] = @grid[k + 1][j]
            @grid[k + 1][j] = 0
            k--
            moved = true
          if k >= 0 and @grid[k][j] is @grid[k + 1][j]
            @grid[k][j] *= 2
            @grid[k + 1][j] = 0
            moved = true
    moved

  moveDown: ->
    moved = false
    for j in [0...@size]
      for i in [@size - 2...-1] by -1
        if @grid[i][j] isnt 0
          k = i + 1
          while k < @size and @grid[k][j] is 0
            @grid[k][j] = @grid[k - 1][j]
            @grid[k - 1][j] = 0
            k++
            moved = true
          if k < @size and @grid[k][j] is @grid[k - 1][j]
            @grid[k][j] *= 2
            @grid[k - 1][j] = 0
            moved = true
    moved

  hasWon: ->
    for i in [0...@size]
      for j in [0...@size]
        if @grid[i][j] is 2048
          return true
    false

  hasLost: ->
    for i in [0...@size]
      for j in [0...@size]
        if @grid[i][j] is 0
          return false
    for i in [0...@size]
      for j in [0...@size - 1]
        if @grid[i][j] is @grid[i][j + 1]
          return false
    for i in [0...@size - 1]
      for j in [0...@size]
        if @grid[i][j] is @grid[i + 1][j]
          return false
    true

class Game
  constructor: (size) ->
    @grid = new Grid(size)
    @grid.addRandomTile()
    @grid.addRandomTile()

  printGrid: ->
    for i in [0...@grid.size]
      for j in [0...@grid.size]
        console.log @grid.grid[i][j]

  move: (direction) ->
    moved = false
    switch direction
      when 'left' then moved = @grid.moveLeft()
      when 'right' then moved = @grid.moveRight()
      when 'up' then moved = @grid.moveUp()
      when 'down' then moved = @grid.moveDown()

    if moved
      @grid.addRandomTile()

    @printGrid()
    if @grid.hasWon()
      console.log 'You win!'
    else if @grid.hasLost()
      console.log 'Game over!'

game = new Game(4)
