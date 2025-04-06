const global neighbours = [[1, 5, 6, -1, -1, -1, -1, -1],
                            [0, 2, 5, 6, 7, -1, -1, -1],
                            [1, 3, 6, 7, 8, -1, -1, -1],
                            [2, 4, 7, 8, 9, -1, -1, -1],
                            [3, 8, 9, -1, -1, -1, -1, -1],
                            [0, 1, 6, 10, 11, -1, -1, -1],
                            [0, 1, 2, 5, 7, 10, 11, 12],
                            [1, 2, 3, 6, 8, 11, 12, 13],
                            [2, 3, 4, 7, 9, 12, 13, 14],
                            [3, 4, 8, 13, 14, -1, -1, -1],
                            [5, 6, 11, 15, 16, -1, -1, -1],
                            [5, 6, 7, 10, 12, 15, 16, 17],
                            [6, 7, 8, 11, 13, 16, 17, 18],
                            [7, 8, 9, 12, 14, 17, 18, 19],
                            [8, 9, 13, 18, 19, -1, -1, -1],
                            [10, 11, 16, 20, 21, -1, -1, -1],
                            [10, 11, 12, 15, 17, 20, 21, 22],
                            [11, 12, 13, 16, 18, 21, 22, 23],
                            [12, 13, 14, 17, 19, 22, 23, 24],
                            [13, 14, 18, 23, 24, -1, -1, -1],
                            [15, 16, 21, -1, -1, -1, -1, -1],
                            [15, 16, 17, 20, 22, -1, -1, -1],
                            [16, 17, 18, 21, 23, -1, -1, -1],
                            [17, 18, 19, 22, 24, -1, -1, -1],
                            [18, 19, 23, -1, -1, -1, -1, -1]]

const global neighboursBitmask = [(1 << 1) + (1 << 5) + (1 << 6),
                            (1 << 0) + (1 << 2) + (1 << 5) + (1 << 6) + (1 << 7),
                            (1 << 1) + (1 << 3) + (1 << 6) + (1 << 7) + (1 << 8),
                            (1 << 2) + (1 << 4) + (1 << 7) + (1 << 8) + (1 << 9),
                            (1 << 3) + (1 << 8) + (1 << 9),
                            (1 << 0) + (1 << 1) + (1 << 6) + (1 << 10) + (1 << 11),
                            (1 << 0) + (1 << 1) + (1 << 2) + (1 << 5) + (1 << 7) + (1 << 10) + (1 << 11) + (1 << 12),
                            (1 << 1) + (1 << 2) + (1 << 3) + (1 << 6) + (1 << 8) + (1 << 11) + (1 << 12) + (1 << 13),
                            (1 << 2) + (1 << 3) + (1 << 4) + (1 << 7) + (1 << 9) + (1 << 12) + (1 << 13) + (1 << 14),
                            (1 << 3) + (1 << 4) + (1 << 8) + (1 << 13) + (1 << 14),
                            (1 << 5) + (1 << 6) + (1 << 11) + (1 << 15) + (1 << 16),
                            (1 << 5) + (1 << 6) + (1 << 7) + (1 << 10) + (1 << 12) + (1 << 15) + (1 << 16) + (1 << 17),
                            (1 << 6) + (1 << 7) + (1 << 8) + (1 << 11) + (1 << 13) + (1 << 16) + (1 << 17) + (1 << 18),
                            (1 << 7) + (1 << 8) + (1 << 9) + (1 << 12) + (1 << 14) + (1 << 17) + (1 << 18) + (1 << 19),
                            (1 << 8) + (1 << 9) + (1 << 13) + (1 << 18) + (1 << 19),
                            (1 << 10) + (1 << 11) + (1 << 16) + (1 << 20) + (1 << 21),
                            (1 << 10) + (1 << 11) + (1 << 12) + (1 << 15) + (1 << 17) + (1 << 20) + (1 << 21) + (1 << 22),
                            (1 << 11) + (1 << 12) + (1 << 13) + (1 << 16) + (1 << 18) + (1 << 21) + (1 << 22) + (1 << 23),
                            (1 << 12) + (1 << 13) + (1 << 14) + (1 << 17) + (1 << 19) + (1 << 22) + (1 << 23) + (1 << 24),
                            (1 << 13) + (1 << 14) + (1 << 18) + (1 << 23) + (1 << 24),
                            (1 << 15) + (1 << 16) + (1 << 21),
                            (1 << 15) + (1 << 16) + (1 << 17) + (1 << 20) + (1 << 22),
                            (1 << 16) + (1 << 17) + (1 << 18) + (1 << 21) + (1 << 23),
                            (1 << 17) + (1 << 18) + (1 << 19) + (1 << 22) + (1 << 24),
                            (1 << 18) + (1 << 19) + (1 << 23)]

"""
Bitwise representation of the game board
* playerA is the position of the player making the next move, playerB is the other
* tiles is a bitmap of eliminated tiles, with `if ((1 << j) & b.tiles != 0)` we can check if the j-th is already eliminated
"""
mutable struct Board
    tiles::Int32
    playerA::Int8
    playerB::Int8
end

"""
Pretty print board
"""
Base.show(io::IO, x::Board) = begin
    turns = 25 - length(replace(bitstring(x.tiles), "0" => ""))

    (turns % 2 == 0) ? println("+--+--+") : println("+-----+")
    for i in 0 : 24
        if (i % 5 == 0)
            print("|")
        end

        if (i == x.playerA)
            (turns % 2 == 0) ? print("1") : print("2")
        elseif (i == x.playerB)
            (turns % 2 == 0) ? print("2") : print("1")
        elseif ((1 << i) & x.tiles != 0)
            print("*")
        else
            print(" ")
        end

        if (i % 5 == 4)
            println("|")
        end
    end
    (turns % 2 == 0) ? println("+--+--+") : println("+-----+")
end


"""
Check if board is valid
"""
@inline function check(b::Board)
    if (b.playerA == b.playerB)  # two players same field
        return false
    end
    if ((1 << b.playerA) & b.tiles == 0)  # player A on dead field
        return false
    end
    if ((1 << b.playerB) & b.tiles == 0)  # player B on dead field
        return false
    end

    return true
end


"""
Check if board is won for current player
"""
@inline function checkWin(b::Board)
    return ((neighboursBitmask[b.playerB + 1] & (b.tiles & ~(1 << b.playerA))) == 0)  # all legal moves for player B are covered by playerA or eliminated tiles
end


"""
Check if board is lost for current player
"""
@inline function checkLose(b::Board)
    return (neighboursBitmask[b.playerA + 1] & (b.tiles & ~(1 << b.playerB)) == 0)
end


"""
Play remaining game with uniform random moves and determine winner
"""
function rollOut!(b::Board)
    state = 0

    # make random move until game is finished
    while (state == 0)
        state = randomMove!(b)
    end

    turns = 25 - length(replace(bitstring(b.tiles), "0" => ""))
    if turns % 2 == 1
        state *= -1
    end

    if state > 0
        return true  #  player 1 has won
    else
        return false # player 2 has won
    end
end


"""
Choose uniform random legal move and report if game is finished
"""
function randomMove!(b::Board)
    # select uniform random legal move (any neighbour tile except if tile already dead or playerB on this tile)
    tileToMoveTo = rand([i for i in neighbours[b.playerA + 1] if i != -1  && ((1 << i) & b.tiles != 0) && i != b.playerB])  # uniform random legal move

    # select uniform random legal tile to remove (all tiles except already dead or has player standing on it)
    tileToEliminate = rand([i for i in 0 : 24 if ((1 << i) & b.tiles != 0) && i != b.playerA && i != b.playerB])

    b.tiles &= ~(1 << tileToEliminate)  # eliminate tile
    b.playerA = b.playerB  # switch players
    b.playerB = tileToMoveTo  # position of now waiting player


    if checkWin(b)
        return 1
    elseif checkLose(b)
        return -1
    else
        return 0
    end
end


function test()
    count = 0
    for i in 1 : 100000
        b = Board(33554431, 16, 8)
        if rollOut!(b)
            count += 1
        end
    end

    println(count)
end

test()


# TODO
"""
- Add Dictionary for Q and N
- Serialization of Dictionary
- Update Values for parent chain
"""