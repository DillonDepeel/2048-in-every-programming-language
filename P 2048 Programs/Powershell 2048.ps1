#========================================================================
# 2048
#
# Powershell version created by: Micky Balladelli
# Original code in JavaScript by: Gabriele Cirulli (https://github.com/gabrielecirulli/2048)
#
# Disclaimer: code is provided as is, without support. Use at your own risk.
#
#========================================================================
 
# constant declaration 
$gridSize = 4
$startTile = 2
$score = 0
$up = 3
$left = 0
$down = 1
$right = 2
 
function GetVector
{
	param ($direction)
 
	$map = 	@( @{"row" = 0; "col"= -1}; # 0  Left
    	  	@{ "row" = 1; "col" = 0 };  # 1  Down
    		@{ "row" = 0; "col" = 1 };  # 2  Right
   			@{ "row"= -1; "col" = 0 })  # 3  Up
 
	return $map[$direction]
}
 
function WithinBounds
{
	param ($row, $col)
 
	if ( ($row -ge 0 -and $row -lt $gridSize) -and
		 ($col -ge 0 -and $col -lt $gridSize))
	{
		return $true
	}
	else
	{
		return $false
	}
}
 
function ColorTiles
{
	param ($grid)
 
	foreach ($row in $grid)
	{
		foreach ($cell in $row)
		{
			switch ($cell.label.text)
			{
				default
				{
					$cell.label.BackColor = "#faf8ef"
					$cell.label.BackColor = "#3c3a32"
					$cell.label.ForeColor = [System.Drawing.Color]::Silver
					$cell.label.ForeColor = "#776e65"
					$cell.label.BackColor = [System.Drawing.Color]::Silver
				}
				"2"
				{
					$cell.label.BackColor = "#eee4da"
					$cell.label.ForeColor = [System.Drawing.Color]::DimGray
				}
				"4"
				{
					$cell.label.BackColor = "#ede0c8"
					$cell.label.ForeColor = [System.Drawing.Color]::DimGray
				}
				"8"
				{
					$cell.label.ForeColor = "#f9f6f2"
					$cell.label.BackColor = "#f2b179"
				}
				"16"
				{
					$cell.label.ForeColor = "#f9f6f2"
					$cell.label.BackColor = "#f59563"
				}
				"32"
				{
					$cell.label.ForeColor = "#f9f6f2"
					$cell.label.BackColor = "#f67c5f"
				}
				"64"
				{
					$cell.label.ForeColor = "#f9f6f2"
					$cell.label.BackColor = "#f65e3b"
				}
				"128"
				{
					$cell.label.ForeColor = "#f9f6f2"
					$cell.label.BackColor = "#edcf72"
				}
				"256"
				{
					$cell.label.ForeColor = "#f9f6f2"
					$cell.label.BackColor = "#edcc61"
				}
				"512"
				{
					$cell.label.ForeColor = "#f9f6f2"
					$cell.label.BackColor = "#edc850"
				}
				"1024"
				{
					$cell.label.ForeColor = "#f9f6f2"
					$cell.label.BackColor = "#edc53f"
				}
				"2048"
				{
					$cell.label.ForeColor = "#f9f6f2"
					$cell.label.BackColor = "#edc22e"
				}
				"4096"
				{
					$cell.label.ForeColor = "#f9f6f2"
					$cell.label.BackColor = "#edcf72"
				}
				"8192"
				{
					$cell.label.ForeColor = "#f9f6f2"
					$cell.label.BackColor = "#edcf72"
				}
			}
		}
	}
}
 
function FindFarthestPosition
{
	param ($grid, $cell, $vector, $gridSize) 
 
	# Progress towards the vector direction until an obstacle is found
 
	do
	{
		$previous = $cell;
		$row = $previous.row + $vector.row 
		$col = $previous.col + $vector.col
	} 
	while ((WithinBounds $row $col $gridSize) -and ($cell = $grid[$row][$col]) -and  $cell.empty)
 
	return @{ "farthest" = $previous;
		      "next"	 = $cell 		# Used to check if a merge is required
		    }
}
 
function CheckAndMove
{
	param ($cell, $grid, $gridSize, $status)
 
	$moved = $false
 
	if ($cell.empty -eq $false -and $cell.moving -eq $false)
	{
		$new = FindFarthestPosition $grid $cell (GetVector $direction) $gridSize 
 
		# Check if merge is possible
		if ( ($cell.label.text -eq $new.next.label.text) -and 
		     (($cell.row -ne $new.next.row) -or ($cell.col -ne $new.next.col)) -and 
			 ($new.next.merged -eq $false))
		{
			$moved = MoveTile $cell $new.next $status
		}
		elseif (($cell.row -ne $new.farthest.row) -or ($cell.col -ne $new.farthest.col))
		{
			$moved = MoveTile $cell $new.farthest $status
		}
	}
 
	return $moved
}
 
function MoveTile
{
	param ($from, $to, $status)
 
	if ($from.label.text -eq $to.label.text -and $to.merged -eq $false)
	{
		# merging tiles is possible
		$to.label.text = (([int]$from.label.text) * 2).ToString()
		$to.merged = $true
 
		$strArray = $status.text.Split(" ")
		$scoreStr = $strArray[1];
		$score = [int] $scoreStr 
		$score += [int] $to.label.text
		$status.Text = "Score: "+$score.ToString()
	}
	else
	{
		$to.label.text = $from.label.text
	}
 
	$from.label.text = ""
	$to.empty = $false
	$from.empty = $true
	$to.moving = $true
 
	ComputeFontSize $to.label
 
	return $true
}
 
function ComputeFontSize
{
	param ($label)
 
	#recompute font size so text fits the label
 
	$fontWidth = [System.Windows.Forms.TextRenderer]::MeasureText($label.Text, (New-Object System.Drawing.Font ($label.Font.FontFamily, $label.Font.Size, $label.Font.Style))).Width
	if ($label.Width -lt $fontWidth -and $fontWidth -ne 0)
	{
		while($label.Width -lt $fontWidth)
		{
			$label.Font = New-Object System.Drawing.Font ($label.Font.FontFamily, ($label.Font.Size - 0.1), $label.Font.Style)
			$fontWidth = [System.Windows.Forms.TextRenderer]::MeasureText($label.Text, (New-Object System.Drawing.Font ($label.Font.FontFamily, $label.Font.Size, $label.Font.Style))).Width
		}
	}
	elseif ($fontWidth -ne 0 -and $label.Width -gt $fontWidth+5)
	{
		$label.Font = New-Object System.Drawing.Font ($label.Font.FontFamily, ($label.size.Height/2), $label.Font.Style)
	}
}
 
function MoveTiles
{
	param ($grid, $direction, $gridSize, $status)
 
	$moved = $false
	switch ($direction)
	{
		$down
		{
			for ($row = $gridSize -1; $row -ge 0; $row--)
			{
				for ($col = 0; $col -lt $gridSize; $col++)
				{
					$cell = $grid[$row][$col]
					$ret = CheckAndMove $cell $grid $gridSize $status
 
					if ($ret -eq $true)
					{
						$moved = $true
					}
				}
			}
		}
		$right
		{
			foreach ($row in $grid)
			{
				$traversal = $row.Clone()
				[array]::Reverse($traversal)
 
				foreach($cell in $traversal)
				{
					$ret = CheckAndMove $cell $grid $gridSize $status
					if ($ret -eq $true)
					{
						$moved = $true
					}
				}
			}
		}
		{$left, $up -contains $_}
		{
			foreach ($row in $grid)
			{
				foreach($cell in $row)
				{
					$ret = CheckAndMove $cell $grid $gridSize $status
					if ($ret -eq $true)
					{
						$moved = $true
					}
				}
			}
		}
	}
 
	# Done moving, reset the moving and merged flags
	foreach ($row in $grid)
	{
		foreach($cell in $row)
		{
			if ($cell.moving)
			{
				$cell.moving = $false
			}
			if ($cell.merged)
			{
				$cell.merged = $false
			}
 
		}
	}
	ColorTiles $grid
	return $moved 
}
 
function GetAvailableCells
{
	param ($grid)
 
	$cells = @()
	foreach ($row in $grid)
	{
		foreach($cell in $row)
		{
			if ($cell.empty)
			{
				$cells += $cell
			}
		}
	}
 
	return $cells
}
 
function CreateEmptyGrid
{
	param ($gridSize)
	$grid = @()
 
	$grid = ,@(0..($gridSize-1))
	for ($i = 1; $i -lt $gridSize; $i++)
	{
		$grid += ,@(0..($gridSize-1))
	}
 
	for ($i = 0; $i -lt $gridSize; $i++)
	{
		for ($j = 0; $j -lt $gridSize; $j++)
		{
			$grid[$i][$j] = New-Object -TypeName PSCustomObject -Property @{
			                    empty = $true;
								tile  = 0;
								row	  = $i;
								col	  = $j;
								label = $null;
								moving= $false
								merged= $false
							}
		}
 
	}
 
	return $grid
}
 
function AddRandomTile
{
	param ($grid)
	$random = Get-Random -InputObject @('2','4')
 
	$cells = GetAvailableCells $grid
	if ($cells)
	{
		$cell = Get-Random -InputObject $cells
 
		if ($cell)
		{
			$cell.label.Text = $random
			$cell.empty = $false
			ComputeFontSize $cell.label
			ColorTiles $grid
 
		}
	}
	return $cell
}
 
$grid = CreateEmptyGrid $gridSize
 
#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
#endregion
 
$form = New-Object System.Windows.Forms.Form
 
 
function Resize
{
	param ($form, $grid)
 
	$margin = 7
	$topbottomMargin = 18
	$y = 26
	$x = $margin*3
 
	$size = New-Object System.Drawing.Size
	$size.Width = ($form.Width/$gridSize) - ($margin*3)
	$size.Height = ($form.Height/$gridSize) - ($margin*2) -$topbottomMargin 
 
	for ($i = 0; $i -lt $gridSize; $i++)
	{
		for ($j = 0; $j -lt $gridSize; $j++)
		{
			$grid[$i][$j].label.Location = New-Object System.Drawing.Point($x, $y)
			$x += ($size.Width) + $margin
			$grid[$i][$j].label.Size = $size
 
			if ($grid[$i][$j].label.Text -ne $null)
			{
				if (($size.Height/2) -gt 0)
				{
					$grid[$i][$j].label.Font = New-Object System.Drawing.Font ($grid[$i][$j].label.Font.FontFamily, ($size.Height/2), $grid[$i][$j].label.Font.Style)
				}
			}
		}
 
		$y += ($grid[0][0].label.Height) + $margin
		$x = $margin*3
	}
 
}
 
$form_keyDown= 
{
	param($sender, $e)
	if($_.KeyCode -eq "A" -and $e.Control)
	{
	$a
	}
	if($_.KeyCode -eq "Down")
	{
		if ((MoveTiles $grid $down $gridSize $status))
		{
			AddRandomTile $grid
		}
	}
	if($_.KeyCode -eq "Up")
	{
		if ((MoveTiles $grid $up $gridSize $status))
		{
			AddRandomTile $grid
		}
	}
	if($_.KeyCode -eq "Left")
	{
		if ((MoveTiles $grid $left $gridSize $status))
		{
			AddRandomTile $grid
		}
	}
	if($_.KeyCode -eq "Right")
	{
		if ((MoveTiles $grid $right $gridSize $status))
		{
			AddRandomTile $grid
		}
	}
}
 
 
# Add the output text box
for ($i = 0; $i -lt $gridSize; $i++)
{
	for ($j = 0; $j -lt $gridSize; $j++)
	{
		$grid[$i][$j].label = New-Object System.Windows.Forms.Label
		$grid[$i][$j].label.AutoSize = $false
		$grid[$i][$j].label.TextAlign =  [System.Drawing.ContentAlignment]::MiddleCenter
		$form.Controls.Add($grid[$i][$j].label)
	}
}
 
$null = AddRandomTile $grid
 
# Create the statusBar
$statusStrip = new-object System.Windows.Forms.StatusStrip
$statusStrip.Location = new-object System.Drawing.Point(0, 463)
$statusStrip.Name = "statusStrip"
$statusStrip.Size = new-object System.Drawing.Size(664, 22);
 
$status = new-object System.Windows.Forms.ToolStripStatusLabel
$status.Text = "Score: 0"
 
 
[void]$statusStrip.Items.add($status)
$status.BackColor = $statusStrip.BackColor
$form.Controls.Add($statusStrip)
 
 
# Set initial dialog size and title
$form.Size = New-Object System.Drawing.Size(600,600)
$form.Text = "2048 Powershell version"
$form.BackColor = [System.Drawing.Color]::Gray 
$form.KeyPreview = $true 
$form.Add_KeyDown($form_keyDown)
$OnResize = 
{
	Resize $form $grid
}
$form.add_Resize($OnResize)
 
$icon = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")
$Form.icon = $icon
 
#Show the Form
Resize $form $grid
ColorTiles $grid
$form.ShowDialog()| Out-Null
