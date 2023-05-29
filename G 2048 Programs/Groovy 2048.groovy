import java.util.Random

final int SIZE = 4
final int DOWN = 0
final int UP = 1
final int LEFT = 2
final int RIGHT = 3
final int MOVES = 4

class Game {
    int[][] tiles = new int[SIZE][SIZE]
}

int random_spot() {
    return new Random().nextInt(SIZE)
}

int random_value() {
    return (new Random().nextInt(10) == 0) ? 4 : 2
}

void print(Game g) {
    println("--------------------------")
    for (int j = SIZE - 1; j >= 0; --j) {
        print("|")
        for (int i = 0; i < SIZE; ++i) {
            if (g.tiles[i][j] != 0)
                printf("%4d  ", g.tiles[i][j])
            else
                printf("      ")
        }
        println("|")
    }
    println("--------------------------")
}

void twist(Game g) {
    Game g2 = new Game()
    for (int i = 0; i < SIZE; ++i)
    for (int j = 0; j < SIZE; ++j)
        g2.tiles[i][j] = g.tiles[j][i]
    g.tiles = g2.tiles
}

void flip(Game g) {
    Game g2 = new Game()
    for (int i = 0; i < SIZE; ++i)
    for (int j = 0; j < SIZE; ++j)
        g2.tiles[i][j] = g.tiles[i][SIZE - j - 1]
    g.tiles = g2.tiles
}

void begin(Game g) {
    Game g2 = new Game()
    g.tiles = g2.tiles
    g.tiles[random_spot()][random_spot()] = random_value()
    g.tiles[random_spot()][random_spot()] = random_value()
}

void fall_column(int[] a, int[] b) {
    int prev = 0
    int j = 0
    for (int i = 0; i < SIZE; ++i)
        if (a[i] != 0) {
            if (a[i] == prev) {
                b[j - 1] *= 2
                prev = 0
            } else {
                b[j++] = a[i]
                prev = a[i]
            }
        }
}

void fall(Game g) {
    Game g2 = new Game()
    for (int i = 0; i < SIZE; ++i)
        fall_column(g.tiles[i], g2.tiles[i])
    g.tiles = g2.tiles
}

int same(Game a, Game b) {
    for (int i = 0; i < SIZE; ++i)
    for (int j = 0; j < SIZE; ++j)
        if (a.tiles[i][j] != b.tiles[i][j])
            return 0
    return 1
}

int tryfalling(Game g) {
    Game g2 = new Game(g)
    fall(g)
    if (same(g, g2))
        return 0
    return 1
}

void popup(Game g) {
    int i, j
    while (true) {
        i = random_spot()
        j = random_spot()
        if (g.tiles[i][j] == 0) {
            g.tiles[i][j] = random_value()
            return
        }
    }
}

void move(Game g, int way) {
    if (way / 2 == 1)
        twist(g)
    if (way % 2 == 1)
        flip(g)
    if (tryfalling(g))
        popup(g)
    if (way % 2 == 1)
        flip(g)
    if (way / 2 == 1)
        twist(g)
}

int read_move() {
    String keys = "kijl"
    int c
    int i
    while (Character.isWhitespace(c = System.in.read())) {}
    if (c == -1)
        return c
    for (i = 0; i < MOVES; ++i)
        if (c == keys.charAt(i))
            return i
    return -1
}

void take_stdin() {
    def backup = System.console().reader().getTerminal()
    def current = backup.settings
    current.setFlag(TerminalFlag.ICANON, false)
    current.setFlag(TerminalFlag.ECHO, false)
    backup.setSettings(current)
}

void give_stdin() {
    def backup = System.console().reader().getTerminal()
    backup.setSettings(backup.settings)
}

void main() {
    int c
    Game g = new Game()
    begin(g)
    print(g)
    take_stdin()
    while ((c = read_move()) != -1) {
        move(g, c)
        print(g)
    }
    give_stdin()
}
