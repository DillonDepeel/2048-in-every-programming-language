class Tile {
    var value: Int
    var isBlocked: Bool
    
    init() {
        self.value = 0
        self.isBlocked = false
    }
}

enum MoveDirection {
    case up, down, left, right
}

class G2048 {
    private var isDone: Bool
    private var isWon: Bool
    private var isMoved: Bool
    private var score: Int
    private let empty = " "
    private var board = [[Tile]]()
    private let rand = Int.random(in: 0...Int.max)
    
    init() {
        self.isDone = false
        self.isWon = false
        self.isMoved = true
        self.score = 0
        self.initializeBoard()
    }
    
    private func initializeBoard() {
        for y in 0...3 {
            var row = [Tile]()
            for x in 0...3 {
                row.append(Tile())
            }
            self.board.append(row)
        }
    }
    
    func loop() {
        addTile()
        while true {
            if isMoved { addTile() }
            drawBoard()
            if isDone { break }
            waitKey()
        }
        let endMessage = isWon ? "You've made it!" : "Game Over!"
        print(endMessage)
    }
    
    func drawBoard() {
        print("Score: \(score)\n")
        for y in 0...3 {
            print("+------+------+------+------+\n")
            print("| ")
            for x in 0...3 {
                if board[x][y].value == 0 {
                    print(empty.padding(toLength: 4, withPad: " ", startingAt: 0), terminator: "")
                } else {
                    print("\(board[x][y].value)".padding(toLength: 4, withPad: " ", startingAt: 0), terminator: "")
                }
                print(" | ", terminator: "")
            }
            print()
        }
        print("+------+------+------+------+\n\n")
    }
    
    private func waitKey() {
        isMoved = false
        print("(W) Up (S) Down (A) Left (D) Right")
        if let input = readLine()?.first {
            switch input {
            case "W":
                move(.up)
            case "A":
                move(.left)
            case "S":
                move(.down)
            case "D":
                move(.right)
            default:
                break
            }
        }
        for y in 0...3 {
            for x in 0...3 {
                board[x][y].isBlocked = false
            }
        }
    }
    
    private func addTile() {
        for y in 0...3 {
            for x in 0...3 {
                if board[x][y].value != 0 { continue }
                var a = 0
                var b = 0
                repeat {
                    a = Int.random(in: 0...3)
                    b = Int.random(in: 0...3)
                } while board[a][b].value != 0
                let r = Double.random(in: 0...1)
                board[a][b].value = r > 0.89 ? 4 : 2
                if canMove() { return }
            }
        }
        isDone = true
    }
    
    private func canMove() -> Bool {
        for y in 0...3 {
            for x in 0...3 {
                if board[x][y].value == 0 { return true }
            }
        }
        for y in 0...3 {
            for x in 0...3 {
                if testAdd(x + 1, y, board[x][y].value) ||
                    testAdd(x - 1, y, board[x][y].value) ||
                    testAdd(x, y + 1, board[x][y].value) ||
                    testAdd(x, y - 1, board[x][y].value) { return true }
            }
        }
        return false
    }
    
    private func testAdd(_ x: Int, _ y: Int, _ value: Int) -> Bool {
        if x < 0 || x > 3 || y < 0 || y > 3 { return false }
        return board[x][y].value == value
    }
    
    private func moveVertically(_ x: Int, _ y: Int, _ d: Int) {
        if board[x][y + d].value != 0 &&
            board[x][y + d].value == board[x][y].value &&
            !board[x][y].isBlocked &&
            !board[x][y + d].isBlocked {
            board[x][y].value = 0
            board[x][y + d].value *= 2
            score += board[x][y + d].value
            board[x][y + d].isBlocked = true
            isMoved = true
        } else if board[x][y + d].value == 0 && board[x][y].value != 0 {
            board[x][y + d].value = board[x][y].value
            board[x][y].value = 0
            isMoved = true
        }
        if d > 0 {
            if y + d < 3 { moveVertically(x, y + d, 1) }
        } else {
            if y + d > 0 { moveVertically(x, y + d, -1) }
        }
    }
    
    private func moveHorizontally(_ x: Int, _ y: Int, _ d: Int) {
        if board[x + d][y].value != 0 &&
            board[x + d][y].value == board[x][y].value &&
            !board[x + d][y].isBlocked &&
            !board[x][y].isBlocked {
            board[x][y].value = 0
            board[x + d][y].value *= 2
            score += board[x + d][y].value
            board[x + d][y].isBlocked = true
            isMoved = true
        } else if board[x + d][y].value == 0 && board[x][y].value != 0 {
            board[x + d][y].value = board[x][y].value
            board[x][y].value = 0
            isMoved = true
        }
        if d > 0 {
            if x + d < 3 { moveHorizontally(x + d, y, 1) }
        } else {
            if x + d > 0 { moveHorizontally(x + d, y, -1) }
        }
    }
    
    private func move(_ direction: MoveDirection) {
        switch direction {
        case .up:
            for x in 0...3 {
                var y = 1
                while y < 4 {
                    if board[x][y].value != 0 { moveVertically(x, y, -1) }
                    y += 1
                }
            }
        case .down:
            for x in 0...3 {
                var y = 2
                while y >= 0 {
                    if board[x][y].value != 0 { moveVertically(x, y, 1) }
                    y -= 1
                }
            }
        case .left:
            for y in 0...3 {
                var x = 1
                while x < 4 {
                    if board[x][y].value != 0 { moveHorizontally(x, y, -1) }
                    x += 1
                }
            }
        case .right:
            for y in 0...3 {
                var x = 2
                while x >= 0 {
                    if board[x][y].value != 0 { moveHorizontally(x, y, 1) }
                    x -= 1
                }
            }
        }
    }
}

func runGame() {
    let game = G2048()
    game.loop()
    checkRestart()
}

func checkRestart() {
    print("(N) New game (P) Exit")
    while true {
        if let input = readLine()?.first {
            switch input {
            case "N":
                runGame()
            case "P":
                return
            default:
                clearLastLine()
            }
        }
    }
}

func clearLastLine() {
    print("\u{1B}[1A\u{1B}[K", terminator: "")
}

runGame()
