-module(game).
-export([start/0]).

-include_lib("kernel/include/file.hrl").

-define(WIDTH, 4).
-define(HEIGHT, 4).
-define(WIN_VALUE, 2048).

-define(LETTER_CODES, [87, 65, 83, 68, 82, 81, 119, 97, 115, 100, 114, 113]).
-define(ACTIONS, [up, left, down, right, restart, exit]).

start() ->
    random:seed(erlang:now()),
    game_loop(init).

init() ->
    GameField = #game_field{height = ?HEIGHT, width = ?WIDTH, win_value = ?WIN_VALUE},
    GameField1 = reset(GameField),
    {GameField1, game}.

game() ->
    {GameField, Action} = get_user_action(),
    case Action of
        restart -> {reset(GameField), game};
        exit -> {GameField, exit};
        _ ->
            case move(GameField, Action) of
                {GameField1, true} ->
                    case is_win(GameField1) of
                        true -> {GameField1, win};
                        false ->
                            case is_gameover(GameField1) of
                                true -> {GameField1, gameover};
                                false -> {GameField1, game}
                            end
                    end;
                {GameField1, false} -> {GameField1, game}
            end
    end.

win() ->
    {GameField, Action} = get_user_action(),
    case Action of
        restart -> {reset(GameField), game};
        exit -> {GameField, exit};
        _ -> {GameField, win}
    end.

gameover() ->
    {GameField, Action} = get_user_action(),
    case Action of
        restart -> {reset(GameField), game};
        exit -> {GameField, exit};
        _ -> {GameField, gameover}
    end.

get_user_action() ->
    Char = "N",
    {ok, Keyboard} = curses:initscr(),
    curses:curs_set(0),
    while Char not in ?ACTIONS do
        Char = curses:getch(Keyboard)
    end,
    Action = lists:nth(element_position(Char), ?ACTIONS),
    curses:endwin(),
    {GameField, Action}.

element_position(Element) ->
    case lists:member(Element, ?LETTER_CODES) of
        true -> lists:nth(element_position(Element, ?LETTER_CODES), ?LETTER_CODES);
        false -> 0
    end.

reset(GameField) ->
    if GameField#game_field.score > GameField#game_field.highscore ->
        GameField1 = GameField#game_field{highscore = GameField#game_field.score};
        true -> GameField1 = GameField#game_field
    end,
    GameField2 = GameField1#game_field{score = 0, field = [[0 || _ <- lists:seq(1, GameField1#game_field.width)] || _ <- lists:seq(1, GameField1#game_field.height)]},
    GameField3 = spawn(GameField2),
    spawn(GameField3).

spawn(GameField) ->
    NewElement = if random:uniform(100) > 89 -> 4; true -> 2 end,
    {I, J} = lists:nth(random_position(GameField#game_field.field), GameField#game_field.field),
    Field = lists:sublist(GameField#game_field.field, I - 1) ++ [lists:sublist(lists:nth(GameField#game_field.field, I - 1), J - 1) ++ [NewElement] ++ lists:nthtail(J, lists:nth(GameField#game_field.field, I - 1))] ++ lists:nthtail(I, GameField#game_field.field),
    GameField#game_field{field = Field}.

move(GameField, Direction) ->
    Move = case Direction of
        up -> fun(F) -> transpose(move_row_left(transpose(F))) end;
        left -> fun(F) -> move_row_left(F) end;
        down -> fun(F) -> transpose(invert(move_row_left(invert(transpose(F))))) end;
        right -> fun(F) -> invert(move_row_left(invert(F))) end
    end,
    case move_is_possible(GameField, Direction) of
        true ->
            Field = Move(GameField#game_field.field),
            {spawn(GameField#game_field{field = Field}), true};
        false -> {GameField, false}
    end.

move_row_left(Row) ->
    Tighten = fun(R) -> lists:append([X || X <- R, X /= 0], [0 || _ <- lists:seq(1, length(R) - length([X || X <- R, X /= 0]))]) end,
    Merge = fun(R) ->
        Pair = false,
        NewRow = [],
        merge([X || X <- R], Pair, NewRow)
    end,
    Tighten(Merge(Tighten(Row))).

merge([H1, H2 | T], Pair, NewRow) ->
    case Pair of
        true ->
            case H1 == H2 of
                true ->
                    NewRow1 = NewRow ++ [0],
                    NewRow2 = NewRow1 ++ [H1 + H2],
                    Score = NewRow2 ++ [0],
                    merge(T, false, Score);
                false ->
                    NewRow1 = NewRow ++ [H1],
                    merge([H2 | T], false, NewRow1)
            end;
        false ->
            case H1 == H2 of
                true ->
                    NewRow1 = NewRow ++ [0],
                    merge(T, true, NewRow1);
                false ->
                    NewRow1 = NewRow ++ [H1],
                    merge([H2 | T], false, NewRow1)
            end
    end;
merge([H], _, NewRow) -> NewRow ++ [H];
merge([], _, NewRow) -> NewRow.

transpose(Field) ->
    lists:map(fun(I) -> lists:map(fun(J) -> lists:nth(J, I) end, lists:seq(1, length(lists:nth(I, Field)))) end, lists:seq(1, length(Field))).

invert(Field) ->
    lists:map(fun(R) -> lists:reverse(R) end, Field).

is_win(GameField) ->
    lists:any(fun(R) -> lists:any(fun(E) -> E >= GameField#game_field.win_value end, R) end, GameField#game_field.field).

is_gameover(GameField) ->
    lists:all(fun(M) -> move_is_possible(GameField, M) == false end, [up, left, down, right]).

move_is_possible(GameField, Direction) ->
    RowIsLeftMovable = fun(Row) ->
        Change = fun(I) ->
            case {lists:nth(I, Row), lists:nth(I + 1, Row)} of
                {0, _} -> true;
                {_, _} when lists:nth(I, Row) == lists:nth(I + 1, Row) -> true;
                _ -> false
            end
        end,
        lists:any(Change, lists:seq(1, length(Row) - 1))
    end,
    Check = case Direction of
        up -> fun(F) -> lists:any(RowIsLeftMovable, transpose(F)) end;
        left -> fun(F) -> lists:any(RowIsLeftMovable, F) end;
        down -> fun(F) -> lists:any(RowIsLeftMovable, transpose(invert(F))) end;
        right -> fun(F) -> lists:any(RowIsLeftMovable, invert(F)) end
    end,
    Check(GameField#game_field.field).

random_position(List) ->
    random:uniform(length(List)).

-record(game_field, {height, width, win_value, score = 0, highscore = 0, field = []}).
