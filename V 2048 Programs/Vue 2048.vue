<template>
  <div>
    <canvas ref="canvas" @keydown="keyHandler"></canvas>
  </div>
</template>

<script>
/* Tile object: */

function Tile(pos, val, puzzle){
  this.pos     = pos;
  this.val     = val;
  this.puzzle  = puzzle;
  this.merging = false;
  
  this.getCol = () => Math.round(this.pos % 4);
  this.getRow = () => Math.floor(this.pos / 4);
  
  /* draw tile on a P5.js canvas: */
  
  this.show = function(){
    let padding = this.merging ? 0 : 5;
    let size = 0.25*this.puzzle.width;
    this.puzzle.ctx.fillStyle = 'hsl(' + 10*(11 - Math.log2(this.val)) + ',' + (50 + 15*Math.log2(this.val)) + '%,' + 200 + '%)';
    this.puzzle.ctx.fillRect(this.getCol()*size + padding, this.getRow()*size + padding, size - 2*padding, size - 2*padding);
    this.puzzle.ctx.fillStyle = 'white';
    this.puzzle.ctx.font = 'bold ' + 0.1*this.puzzle.width + 'px Arial';
    this.puzzle.ctx.textAlign = 'center';
    this.puzzle.ctx.fillText(this.val, (this.getCol() + 0.5)*size, (this.getRow() + 0.5)*size);
  }
  
  /* move tile in a given direction: */
  
  this.move = function(dir){
    let col = this.getCol() + (1 - 2*(dir < 0))*Math.abs(dir)%4;
    let row = this.getRow() + (1 - 2*(dir < 0))*Math.floor(Math.abs(dir)/4);
    let target = this.puzzle.getTile(this.pos + dir);
    
    if (col < 0 || col > 3 || row < 0 || row > 3) {
      /* target position out of bounds */
      return false;
    } else if (target){
      /* tile blocked by other tile */
      if(this.merging || target.merging || target.val !== this.val)
        return false;
      
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

/* Puzzle object: */

function Puzzle(){
  this.tiles    = [];
  this.dir      = 0;
  this.score    = 0;
  this.hasMoved = false;
  this.validPositions = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
  
  this.getOpenPositions = () => this.validPositions.filter(i => this.tiles.map(x => x.pos).indexOf(i) === -1);
  this.getTile          = pos => this.tiles.filter(x => x.pos === pos)[0];
  this.removeTile       = tile => this.tiles.splice(this.tiles.indexOf(tile), 1);
  this.winCondition     = () => this.tiles.some(x => x.val === 2048);

  /* check for valid moves: */
  
  this.validMoves = function(){
    /* return true if there are empty spaces */
    if(this.tiles.length < 16)
      return true;
    
    /* otherwise check for neighboring tiles with the same value */
    let res = false;
    this.tiles.sort((x,y) => x.pos - y.pos);
    for(let i = 0; i < 16; i++)
      res = res || ( (i%4 < 3) ? this.tiles[i].val === this.tiles[i+1].val : false )
              || ( (i  < 12) ? this.tiles[i].val === this.tiles[i+4].val : false );
    return res;
  }
  
  /* check win and lose condition: */
  
  this.checkGameState = function(){
    if(this.winCondition()){
      alert('You win!');
    } else if (!this.validMoves()){
      alert('You Lose!');
      this.restart();
    }
  }
  
  this.restart = function(){
    this.tiles    = [];
    this.dir      = 0;
    this.score    = 0;
    this.hasMoved = false;
    this.generateTile();
    this.generateTile();
  }
  
  /* draw the board on the canvas: */
  
  this.show = function(){
    this.ctx.fillStyle = 'rgb(200, 200, 200)';
    this.ctx.fillRect(0, 0, this.width, this.width + 20);
    this.ctx.fillStyle = 'white';
    this.ctx.font = 'bold ' + 0.05*this.width + 'px Arial';
    this.ctx.textAlign = 'center';
    this.ctx.fillText('SCORE: ' + this.score, 0.5*this.width, this.width);
    
    for(let tile of this.tiles)
      tile.show();
  }
  
  /* update the board: */
  
  this.animate = function(){
    if(this.dir === 0)
      return;
    
    /* move all tiles in a given direction */
    let moving = false;
    this.tiles.sort((x,y) => this.dir*(y.pos - x.pos));
    for(let tile of this.tiles)
      moving = moving || tile.move(this.dir);
    
    /* check if the move is finished and generate a new tile */
    if(this.hasMoved && !moving){
      this.dir = 0;
      this.generateTile();
      
      for(let tile of this.tiles)
        tile.merging = false;
    } 
    this.hasMoved = moving;
  }
  
  this.generateTile = function(){
    let positions = this.getOpenPositions();
    let pos       = positions[Math.floor(Math.random()*positions.length)];
    let val       = 2 + 2*Math.floor(Math.random()*1.11);
    this.tiles.push(new Tile(pos, val, this));
  }
  this.generateTile();
  this.generateTile();
  
  /* process key inputs: */
  
  this.keyHandler = function(e){
    if      (e.keyCode === 38) this.dir = -4
    else if (e.keyCode === 40) this.dir = 4
    else if (e.keyCode === 39) this.dir = 1
    else if (e.keyCode === 37) this.dir = -1;
  }
  
  /* initialize canvas and start game loop: */
  
  this.canvas = this.$refs.canvas;
  this.ctx = this.canvas.getContext('2d');
  this.width = 400;
  this.canvas.width = this.width;
  this.canvas.height = this.width + 20;
  
  this.gameLoop = function(){
    this.checkGameState();
    this.animate();
    this.show();
    window.requestAnimationFrame(this.gameLoop.bind(this));
  }
  window.requestAnimationFrame(this.gameLoop.bind(this));
}

export default {
  mounted(){
    this.puzzle = new Puzzle();
  }
}
</script>
