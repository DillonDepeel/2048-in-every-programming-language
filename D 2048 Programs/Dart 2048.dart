class Tile {
  int pos;
  int val;
  Puzzle puzzle;
  bool merging;

  Tile(this.pos, this.val, this.puzzle) {
    this.merging = false;
  }

  int getCol() {
    return (this.pos % 4).round();
  }

  int getRow() {
    return (this.pos / 4).floor();
  }

  void show() {
    int padding = this.merging ? 0 : 5;
    double size = 0.25 * width;
    noStroke();
    colorMode(HSB, 255);
    fill(
        10 * (11 - log(this.val) / log(2)).toInt(),
        50 + (15 * log(this.val) / log(2)).toInt(),
        200);
    rect(this.getCol() * size + padding, this.getRow() * size + padding,
        size - 2 * padding, size - 2 * padding);
    fill(255);
    textSize(0.1 * width);
    textAlign(CENTER, CENTER);
    text(this.val, (this.getCol() + 0.5) * size, (this.getRow() + 0.5) * size);
  }

  bool move(int dir) {
    int col = this.getCol() + (1 - 2 * (dir < 0)) * (dir.abs() % 4);
    int row = this.getRow() +
        (1 - 2 * (dir < 0)) * (dir.abs() / 4).floor();
    Tile target = this.puzzle.getTile(this.pos + dir);

    if (col < 0 ||
        col > 3 ||
        row < 0 ||
        row > 3) {
      /* target position out of bounds */
      return false;
    } else if (target != null) {
      /* tile blocked by other tile */
      if (this.merging || target.merging || target.val != this.val) return false;

      /* merge with target tile (equal values):*/
      target.val += this.val;
      target.merging = true;
      this.puzzle.score += target.val;
      this.puzzle.removeTile(this);
      return true;
    }

    /* move tile: */
    this.pos += dir;
    return true;
  }
}

class Puzzle {
  List<Tile> tiles;
  int dir;
  int score;
  bool hasMoved;
  List<int> validPositions;

  Puzzle() {
    this.tiles = [];
    this.dir = 0;
    this.score = 0;
    this.hasMoved = false;
    this.validPositions = List.generate(16, (index) => index);
  }

  List<int> getOpenPositions() {
    return this
        .validPositions
        .where((i) => this.tiles.map((x) => x.pos).indexOf(i) == -1)
        .toList();
  }

  Tile getTile(int pos) {
    List<Tile> filteredTiles = this.tiles.where((x) => x.pos == pos).toList();
    return filteredTiles.isNotEmpty ? filteredTiles[0] : null;
  }

  void removeTile(Tile tile) {
    this.tiles.remove(tile);
  }

  bool winCondition() {
    return this.tiles.any((x) => x.val == 2048);
  }

  bool validMoves() {
    /* return true if there are empty spaces */
    if (this.tiles.length < 16) return true;

    /* otherwise check for neighboring tiles with the same value */
    bool res = false;
    this.tiles.sort((x, y) => x.pos - y.pos);
    for (int i = 0; i < 16; i++)
      res = res ||
          ((i % 4 < 3)
              ? this.tiles[i].val == this.tiles[i + 1].val
              : false) ||
          ((i < 12) ? this.tiles[i].val == this.tiles[i + 4].val : false);
    return res;
  }

  void checkGameState() {
    if (this.winCondition()) {
      print('You win!');
    } else if (!this.validMoves()) {
      print('You Lose!');
      this.restart();
    }
  }

  void restart() {
    this.tiles = [];
    this.dir = 0;
    this.score = 0;
    this.hasMoved = false;
    this.generateTile();
    this.generateTile();
  }

  void show() {
    background(200);
    fill(255);
    textSize(0.05 * width);
    textAlign(CENTER, TOP);
    text("SCORE: " + this.score.toString(), 0.5 * width, width);

    for (Tile tile in this.tiles) tile.show();
  }

  void animate() {
    if (this.dir == 0) return;

    /* move all tiles in a given direction */
    bool moving = false;
    this.tiles.sort((x, y) => this.dir * (y.pos - x.pos));
    for (Tile tile in this.tiles) moving = moving || tile.move(this.dir);

    /* check if the move is finished and generate a new tile */
    if (this.hasMoved && !moving) {
      this.dir = 0;
      this.generateTile();

      for (Tile tile in this.tiles) tile.merging = false;
    }
    this.hasMoved = moving;
  }

  void generateTile() {
    List<int> positions = this.getOpenPositions();
    int pos = positions[(positions.length * (random.nextDouble())).floor()];
    int val = 2 + (2 * (random.nextDouble() * 1.11)).floor();
    this.tiles.add(Tile(pos, val, this));
  }

  void keyHandler(int key) {
    if (key == UP_ARROW)
      this.dir = -4;
    else if (key == DOWN_ARROW)
      this.dir = 4;
    else if (key == RIGHT_ARROW)
      this.dir = 1;
    else if (key == LEFT_ARROW)
      this.dir = -1;
  }
}

Puzzle game;

void setup() {
  createCanvas(400, 420);
  game = Puzzle();
}

/* game loop: */

void draw() {
  game.checkGameState();
  game.animate();
  game.show();
}

void keyPressed() {
  game.keyHandler(keyCode);
}
