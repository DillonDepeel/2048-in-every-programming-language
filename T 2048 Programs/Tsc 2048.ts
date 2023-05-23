enum Direction {
    Up,
    Down,
    Left,
    Right,
  }
  
  class Tile {
    value: number;
  
    constructor(value: number) {
      this.value = value;
    }
  }
  
  class Board {
    size: number;
    tiles: Tile[][];
  
    constructor(size: number) {
      this.size = size;
      this.tiles = [];
  
      for (let i = 0; i < size; i++) {
        this.tiles[i] = [];
        for (let j = 0; j < size; j++) {
          this.tiles[i][j] = new Tile(0);
        }
      }
    }
  
    generateRandomTile(): void {
      const emptyTiles: [number, number][] = [];
      for (let i = 0; i < this.size; i++) {
        for (let j = 0; j < this.size; j++) {
          if (this.tiles[i][j].value === 0) {
            emptyTiles.push([i, j]);
          }
        }
      }
  
      if (emptyTiles.length === 0) {
        return;
      }
  
      const randomIndex = Math.floor(Math.random() * emptyTiles.length);
      const [row, col] = emptyTiles[randomIndex];
      this.tiles[row][col].value = Math.random() < 0.9 ? 2 : 4;
    }
  
    move(direction: Direction): void {
      // Implement the logic to move the tiles in the specified direction
      // Update the board and generate a new random tile
    }
  }
  
  class Game {
    board: Board;
  
    constructor(size: number) {
      this.board = new Board(size);
      this.board.generateRandomTile();
      this.board.generateRandomTile();
    }
  
    play(direction: Direction): void {
      this.board.move(direction);
      // Implement the logic to handle player's moves and game over condition
    }
  }
  
  // Create a new game with a 4x4 board
  const game = new Game(4);
  
  // Example: Move tiles to the right
  game.play(Direction.Right);
  