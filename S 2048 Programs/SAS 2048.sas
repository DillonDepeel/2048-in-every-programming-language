data Game;
    length field $16 fieldSize 8 command $1 error $50 lastIndexX 8 lastIndexY 8 score 8 finishScore 8;
    field = repeat(' ', 16);
    fieldSize = 4;
    finishScore = 2048;
    score = 0;
    call addNumber();
    call render();
    do while(1);
        command = lowcase(call readchar('Use WASD, q exits'));
        call cls();
        if(call processCommand()) then do;
            call addNumber();
        end;
        else do;
            if(nmiss(call getFreeList()) = 0) then do;
                error = 'No options left!, You Lose!!';
            end;
            else do;
                error = 'Invalid move, try again!';
            end;
        end;
        call render();
    end;
    stop;
run;

/* Functions */
/* Insert a number in an empty spot on the field */
%macro addNumber();
    freeList = call getFreeList();
    if(nmiss(freeList) = 0) then return;
    index = ceil(rand('uniform') * nmiss(freeList));
    nr = (rand('uniform') < 0.1) * 2 + 2;
    x = freeList[index].x;
    y = freeList[index].y;
    substr(field, (x-1)*fieldSize+y, 1) = put(nr, 1.);
%mend;

/* Get empty positions in the field */
%macro getFreeList();
    freeList = {};
    do i = 1 to fieldSize;
        do j = 1 to fieldSize;
            if(missing(input(substr(field, (i-1)*fieldSize+j, 1), 1.))) then do;
                freeList = catx(',', freeList, catt('{x=', i, ',y=', j, '}'));
            end;
        end;
    end;
    freeList = input(freeList, $50.);
%mend;

/* Render the game */
%macro render();
    put 'Score: ' score;
    do i = 1 to fieldSize;
        do j = 1 to fieldSize;
            put (substr(field, (i-1)*fieldSize+j, 1)) 1. @;
        end;
        put;
    end;
    if(length(error) > 0) then put error;
%mend;

/* Clear the console */
%macro cls();
    put 'cls';
%mend;

/* Process the user command */
%macro processCommand();
    return 0;
%mend;

/* Read a character from the console */
%macro readchar(prompt);
    put prompt;
    infile stdin;
    input @;
    return substr(_infile_, 1, 1);
%mend;
