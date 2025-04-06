using Random

"""
Bitwise representation of the game board
* playerA is the position of the player making the next move, playerB is the other
* tiles is a bitmap of eliminated tiles, with `if ((1 << j) & b.tiles != 0)` we can check if the j-th is already eliminated
"""
struct Board
    tiles::Int32
    playerA::Int8
    playerB::Int8
end

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
Pretty print board and indicate which player makes the next turn
"""
Base.show(io::IO, x::Board) = begin
    turns = 25 - length(replace(bitstring(x.tiles), "0" => ""))

    (turns % 2 == 0) ? println("+-(1)-+") : println("+-(2)-+")
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
    (turns % 2 == 0) ? println("+-(1)-+") : println("+-(2)-+")
end


"""
Stored information about node in game tree 
"""
mutable struct Node
    board::Board
    q::Int32  # number of wins after a visit (for current player A)
    n::Int32  # number of visits
    
    children::Dict{Pair{Int8, Int8}, Node}  # maps action to child
    parent::Union{Node, Nothing}

    function Node(board::Board, parent = nothing)
        new(board, 0, 0, Dict{Pair{Int, Int}, Node}(), parent)
    end
end


"""
Calculate Upper Confidence Bound (sqrt(2) is theoretical value, can be optimized empirically)
"""
@inline function value(node::Node, factor::Float64 = sqrt(2))
    if node.n == 0
        return Inf
    elseif isnothing(node.parent)
        throw(DomainError(node.parent, "Root node has no UCT"))
    end

    return node.q / node.n + factor * sqrt(log(node.parent.n) / node.n)
end


"""
Expand leave node with all children
"""
@inline function expand!(node::Node)
    gameFinished = true
    for move in filter(i -> i != -1 && ((1 << i) & node.board.tiles != 0) && i != node.board.playerB, neighbours[node.board.playerA + 1])  # all legal moves (any neighbour tile except if tile already dead or playerB on this tile)
        for elim in filter(i -> ((1 << i) & node.board.tiles != 0) && i != move && i != node.board.playerB, 0 : 24)  # all legal tile to remove (all tiles except already dead or has player standing on it)
            gameFinished = false
            newBoard = Board(node.board.tiles & ~(1 << elim), node.board.playerB, move)
            node.children[Pair(move, elim)] = Node(newBoard, node)
        end
    end

    return gameFinished
end


"""
Rollout current node (choose uniformly random legal moves until game is finished)
"""
@inline function rollout!(node::Node)
    board = node.board
    gameFinished = false

    while !gameFinished
        gameFinished = true

        # loop in random order over legal moves
        for move in shuffle([i for i in neighbours[board.playerA + 1] if i != -1  && ((1 << i) & board.tiles != 0) && i != board.playerB])
            elimCand = [i for i in 0 : 24 if ((1 << i) & board.tiles != 0) && i != move && i != board.playerB]

            if !isempty(elimCand)
                elim = rand(elimCand)  # random tile to eliminate
                board = Board(board.tiles & ~(1 << elim), board.playerB, move)

                gameFinished = false
                break
            end
        end
    end

    turns = 25 - length(replace(bitstring(board.tiles), "0" => ""))
    if turns % 2 == 1
        return true  # player 1 has won
    else
        return false  # player 2 has won
    end
end


"""
Select next node to expand
"""
function select(root::Node)
    node = root

    while !isempty(node.children)
        bestActs = Vector{Pair{Int8, Int8}}()
        highestUCT = -1.0

        for move in filter(i -> i != -1 && ((1 << i) & node.board.tiles != 0) && i != node.board.playerB, neighbours[node.board.playerA + 1])
            for elim in filter(i -> ((1 << i) & node.board.tiles != 0) && i != move && i != node.board.playerB, 0 : 24)
                uct = value(node.children[Pair(move, elim)])
                if uct > highestUCT
                    bestActs = [Pair(move, elim)]
                    highestUCT = uct
                elseif uct == highestUCT
                    push!(bestActs, Pair(move, elim))
                end
            end
        end

        (move, elim) = rand(bestActs)
        node = node.children[Pair(move, elim)]

        if node.n == 0
            # unexplored node
            return node
        end
    end

    # now we expand current leaf node
    if !expand!(node)
        # choose random children for simulation if game is not finished
        _, node = rand(node.children)
    end

    return node
end


"""
Backpropagate values
"""
function backProp!(node::Node, player1won::Bool)
    while !isnothing(node)
        turn = 25 - length(replace(bitstring(node.board.tiles), "0" => ""))

        if turn % 2 == 0
            node.q += player1won
        else
            node.q += 1 - player1won
        end

        node.n += 1

        node = node.parent
    end
end


"""
Choose next move based on highest N of a child (Q/N does not work, since some rarely explored actions have it)
"""
function nextMove(root::Node)
    maxN = -1
    bestMove = Pair(0, 0)

    for (action, child) in root.children
        if root.children[action].n > maxN
            bestMove = action
        end
    end

    return Board(root.board.tiles & ~(1 << bestMove[2]), root.board.playerB, bestMove[1])
end


"""
MCTS search
"""
function MCTS!(root::Node, timeLimit::Float64)
    root.parent = nothing  # delete parent link for new root

    startTime = time()
    numRoll = 0  # TODO: Temp

    while (time() - startTime) < timeLimit
        node = select(root)
        result = rollout!(node)
        backProp!(node, result)
        numRoll += 1
    end

    println(numRoll)
end


function test()
    b = Board(33554431, 16, 8)

    while true
        println(b)
        root = Node(b)
        MCTS!(root, 1.5)

        if isempty(root.children)  # game over
            break
        end

        b = nextMove(root)
    end
end

test()