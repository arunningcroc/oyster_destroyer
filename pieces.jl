module Pieces
abstract type Piece end
struct Direction
    x::Int
    y::Int
end
struct Pawn <: Piece
    color::String
    hasmoved::Bool
    movedirs::Array{Direction,1}
    moverange::Int
end
struct Knight <: Piece
    color::String
    movedirs::Array{Direction,1}
    moverange::Int
end
struct Rook <: Piece
    color::String
    movedirs::Array{Direction,1}
    moverange::Int
end
struct Queen <: Piece
    color::String
    movedirs::Array{Direction,1}
    moverange::Int
end
struct King <: Piece
    color::String
    movedirs::Array{Direction,1}
    moverange::Int
end
struct Bishop <: Piece
    color::String
    movedirs::Array{Direction,1}
    moverange::Int
    Bishop(color,moverange) = get_directions
end

    
function Knight(color::String, moverange::Int)
    dirs = [Direction(2,1),Direction(-2,1),Direction(2,-1),Direction(1,-2),
            Direction(1,2),Direction(-1,2),Direction(-1,-2),Direction(-2,-1)]
    return Knight(color,dirs,moverange)
end
function Bishop(color::String, moverange::Int)
    dirs = [Direction(-1,-1),Direction(1,1),Direction(1,-1),Direction(-1,1)]
    return Bishop(color,dirs,moverange)
end
function King(color::String, moverange::Int)
    dirs = [Direction(1,1),Direction(-1,1),Direction(1,0),Direction(-1,0),
            Direction(0,-1),Direction(0,1),Direction(1,-1),Direction(-1,-1)]
    return King(color,dirs,moverange)
end
function Queen(color::String, moverange::Int)
    dirs = [Direction(1,1),Direction(-1,1),Direction(1,0),Direction(-1,0),
            Direction(0,-1),Direction(0,1),Direction(1,-1),Direction(-1,-1)]
    return Queen(color,dirs,moverange)
end

end 