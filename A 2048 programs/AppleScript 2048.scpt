script Tile
	property value : 0
	property isBlocked : false
	
	on init()
		set value to 0
		set isBlocked to false
	end init
end script

script G2048
	property isDone : false
	property isWon : false
	property isMoved : true
	property score : 0
	property empty : " "
	property board : {{Tile}}
	property rand : (random number from 0 to (2^31 - 1))
	
	on init()
		set isDone to false
		set isWon to false
		set isMoved to true
		set score to 0
		initializeBoard()
	end init
	
	on initializeBoard()
		repeat with y from 0 to 3
			set row to {}
			repeat with x from 0 to 3
				set end of row to Tile's alloc() init()
			end repeat
			set end of board to row
		end repeat
	end initializeBoard
	
	on loop()
		addTile()
		repeat
			if isMoved then addTile()
			drawBoard()
			if isDone then exit repeat
			waitKey()
		end repeat
		set endMessage to if isWon then "You've made it!" else "Game Over!"
		log endMessage
	end loop
	
	on drawBoard()
		log "Score: " & score & "\n"
		repeat with y from 0 to 3
			log "+------+------+------+------+\n"
			log "| "
			repeat with x from 0 to 3
				if board's item x's item y's value = 0 then
					log (empty's padding to length:4 starting at:0 with pad:" ")
				else
					log (board's item x's item y's value as string's padding to length:4 starting at:0 with pad:" ")
				end if
				log " | "
			end repeat
			log "\n"
		end repeat
		log "+------+------+------+------+\n\n"
	end drawBoard
	
	on waitKey()
		set isMoved to false
		log "(W) Up (S) Down (A) Left (D) Right"
		set input to (read line as text)'s first character
		if input is "W" then
			move(MoveDirection's up)
		else if input is "A" then
			move(MoveDirection's left)
		else if input is "S" then
			move(MoveDirection's down)
		else if input is "D" then
			move(MoveDirection's right)
		end if
		repeat with y from 0 to 3
			repeat with x from 0 to 3
				set board's item x's item y's isBlocked to false
			end repeat
		end repeat
	end waitKey
	
	on addTile()
		repeat with y from 0 to 3
			repeat with x from 0 to 3
				if board's item x's item y's value ≠ 0 then
					continue repeat
				end if
				repeat
					set a to (random number from 0 to 3)
					set b to (random number from 0 to 3)
				until board's item a's item b's value = 0
				set r to (random number from 0 to 1)
				set board's item a's item b's value to if r > 0.89 then 4 else 2
				if canMove() then
					return
				end if
			end repeat
		end repeat
		set isDone to true
	end addTile
	
	on canMove()
		repeat with y from 0 to 3
			repeat with x from 0 to 3
				if board's item x's item y's value = 0 then
					return true
				end if
			end repeat
		end repeat
		repeat with y from 0 to 3
			repeat with x from 0 to 3
				if testAdd(x + 1, y, board's item x's item y's value) or testAdd(x - 1, y, board's item x's item y's value) or testAdd(x, y + 1, board's item x's item y's value) or testAdd(x, y - 1, board's item x's item y's value) then
					return true
				end if
			end repeat
		end repeat
		return false
	end canMove
	
	on testAdd(x, y, value)
		if x < 0 or x > 3 or y < 0 or y > 3 then
			return false
		end if
		return board's item x's item y's value = value
	end testAdd
	
	on moveVertically(x, y, d)
		if board's item x's item (y + d)'s value ≠ 0 and board's item x's item (y + d)'s value = board's item x's item y's value and not board's item x's item y's isBlocked and not board's item x's item (y + d)'s isBlocked then
			set board's item x's item y's value to 0
			set board's item x's item (y + d)'s value to (board's item x's item (y + d)'s value) * 2
			set score to score + (board's item x's item (y + d)'s value)
			set board's item x's item (y + d)'s isBlocked to true
			set isMoved to true
		else if board's item x's item (y + d)'s value = 0 and board's item x's item y's value ≠ 0 then
			set board's item x's item (y + d)'s value to board's item x's item y's value
			set board's item x's item y's value to 0
			set isMoved to true
		end if
		if d > 0 then
			if y + d < 3 then
				moveVertically(x, y + d, 1)
			end if
		else
			if y + d > 0 then
				moveVertically(x, y + d, -1)
			end if
		end if
	end moveVertically
	
	on moveHorizontally(x, y, d)
		if board's item (x + d)'s item y's value ≠ 0 and board's item (x + d)'s item y's value = board's item x's item y's value and not board's item (x + d)'s item y's isBlocked and not board's item x's item y's isBlocked then
			set board's item x's item y's value to 0
			set board's item (x + d)'s item y's value to (board's
