Class Tile
    Private pos As Integer
    Private val As Integer
    Private puzzle As Puzzle
    Private merging As Boolean
    
    Public Sub New(ByVal pos As Integer, ByVal val As Integer, ByVal puzzle As Puzzle)
        Me.pos = pos
        Me.val = val
        Me.puzzle = puzzle
        Me.merging = False
    End Sub
    
    Private Function getCol() As Integer
        Return Math.Round(Me.pos Mod 4)
    End Function
    
    Private Function getRow() As Integer
        Return Math.Floor(Me.pos / 4)
    End Function
    
    Public Sub show()
        Dim padding As Integer = IIf(Me.merging, 0, 5)
        Dim size As Integer = 0.25 * Width
        ColorMode(HSB, 255)
        Fill(10 * (11 - Math.Log(Me.val, 2)), 50 + 15 * Math.Log(Me.val, 2), 200)
        Rect(Me.getCol() * size + padding, Me.getRow() * size + padding, size - 2 * padding, size - 2 * padding)
        Fill(255)
        TextSize(0.1 * Width)
        TextAlign(CENTER, CENTER)
        Text(Me.val, (Me.getCol() + 0.5) * size, (Me.getRow() + 0.5) * size)
    End Sub
    
    Public Function move(ByVal dir As Integer) As Boolean
        Dim col As Integer = Me.getCol() + (1 - 2 * (dir < 0)) * Math.Abs(dir) Mod 4
        Dim row As Integer = Me.getRow() + (1 - 2 * (dir < 0)) * Math.Floor(Math.Abs(dir) / 4)
        Dim target As Tile = Me.puzzle.getTile(Me.pos + dir)
        
        If col < 0 Or col > 3 Or row < 0 Or row > 3 Then
            ' target position out of bounds
            Return False
        ElseIf target IsNot Nothing Then
            ' tile blocked by other tile
            If Me.merging Or target.merging Or target.val <> Me.val Then
                Return False
            End If
            
            ' merge with target tile (equal values):
            target.val += Me.val
            target.merging = True
            Me.puzzle.score += target.val
            Me.puzzle.removeTile(Me)
            Return True
        End If
        
        ' move tile:
        Me.pos += dir
        Return True
    End Function
End Class

Class Puzzle
    Private tiles As List(Of Tile)
    Private dir As Integer
    Private score As Integer
    Private hasMoved As Boolean
    Private validPositions As List(Of Integer)
    
    Public Sub New()
        Me.tiles = New List(Of Tile)
        Me.dir = 0
        Me.score = 0
        Me.hasMoved = False
        Me.validPositions = New List(Of Integer) From {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}
        Me.generateTile()
        Me.generateTile()
    End Sub
    
    Private Function getOpenPositions() As List(Of Integer)
        Return Me.validPositions.Where(Function(i) Not Me.tiles.Any(Function(x) x.pos = i)).ToList()
    End Function
    
    Public Function getTile(ByVal pos As Integer) As Tile
        Return Me.tiles.FirstOrDefault(Function(x) x.pos = pos)
    End Function
    
    Public Sub removeTile(ByVal tile As Tile)
        Me.tiles.Remove(tile)
    End Sub
    
    Private Function winCondition() As Boolean
        Return Me.tiles.Any(Function(x) x.val = 2048)
    End Function
    
    Public Function validMoves() As Boolean
        ' return true if there are empty spaces
        If Me.tiles.Count < 16 Then
            Return True
        End If
        
        ' otherwise check for neighboring tiles with the same value
        Me.tiles.Sort(Function(x, y) x.pos - y.pos)
        For i As Integer = 0 To 15
            If (i Mod 4 < 3 AndAlso Me.tiles(i).val = Me.tiles(i + 1).val) OrElse
               (i < 12 AndAlso Me.tiles(i).val = Me.tiles(i + 4).val) Then
                Return True
            End If
        Next
        
        Return False
    End Function
    
    Public Sub checkGameState()
        If Me.winCondition() Then
            MsgBox("You win!")
        ElseIf Not Me.validMoves() Then
            MsgBox("You Lose!")
            Me.restart()
        End If
    End Sub
    
    Public Sub restart()
        Me.tiles = New List(Of Tile)
        Me.dir = 0
        Me.score = 0
        Me.hasMoved = False
        Me.generateTile()
        Me.generateTile()
    End Sub
    
    Public Sub show()
        Background(200)
        Fill(255)
        TextSize(0.05 * Width)
        TextAlign(CENTER, TOP)
        Text("SCORE: " & Me.score, 0.5 * Width, Width)
        
        For Each tile As Tile In Me.tiles
            tile.show()
        Next
    End Sub
    
    Public Sub animate()
        If Me.dir = 0 Then
            Return
        End If
        
        ' move all tiles in a given direction
        Dim moving As Boolean = False
        Me.tiles.Sort(Function(x, y) Me.dir * (y.pos - x.pos))
        For Each tile As Tile In Me.tiles
            moving = moving Or tile.move(Me.dir)
        Next
        
        ' check if the move is finished and generate a new tile
        If Me.hasMoved And Not moving Then
            Me.dir = 0
            Me.generateTile()
            
            For Each tile As Tile In Me.tiles
                tile.merging = False
            Next
        End If
        
        Me.hasMoved = moving
    End Sub
    
    Public Sub generateTile()
        Dim positions As List(Of Integer) = Me.getOpenPositions()
        Dim pos As Integer = positions(Math.Floor(Rnd() * positions.Count))
        Dim val As Integer = 2 + 2 * Math.Floor(Rnd() * 1.11)
        Me.tiles.Add(New Tile(pos, val, Me))
    End Sub
    
    Public Sub keyHandler(ByVal key As Integer)
        If key = 38 Then
            Me.dir = -4
        ElseIf key = 40 Then
            Me.dir = 4
        ElseIf key = 39 Then
            Me.dir = 1
        ElseIf key = 37 Then
            Me.dir = -1
        End If
    End Sub
End Class

Dim game As Puzzle

Public Sub setup()
    Randomize()
    Randomize()
    Randomize()
    Randomize()
    Randomize()
    Randomize()
    Randomize()
    Randomize()
    Randomize()
    Randomize()
    Randomize()
    Randomize()
    Randomize()
    Randomize()
    Randomize()
    Randomize()
    CreateCanvas(400, 420)
    game = New Puzzle()
End Sub

Public Sub draw()
    game.checkGameState()
    game.animate()
    game.show()
End Sub

Public Sub keyPressed()
    game.keyHandler(KeyCode)
End Sub
