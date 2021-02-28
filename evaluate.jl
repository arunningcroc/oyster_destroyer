using Chess

function evaluate_pos(position)
    whitepawns  = length(Chess.squares(Chess.pawns(position,WHITE)))
    blackpawns  = length(Chess.squares(Chess.pawns(position,BLACK)))
    whiteknights= length(Chess.squares(Chess.knights(position,WHITE)))
    blackknights= length(Chess.squares(Chess.knights(position,BLACK)))
    whitebishops= length(Chess.squares(Chess.bishops(position,WHITE)))
    blackbishops= length(Chess.squares(Chess.bishops(position,BLACK)))
    whitequeens = length(Chess.squares(Chess.queens(position,WHITE)))
    blackqueens = length(Chess.squares(Chess.queens(position,BLACK)))
    whiterooks  = length(Chess.squares(Chess.rooks(position,WHITE)))
    blackrooks  = length(Chess.squares(Chess.rooks(position,BLACK)))
    #Simple eval based on piece values for now.
    score = ( 10*(whitepawns-blackpawns)+30*(whiteknights-blackknights+whitebishops-blackbishops) 
            +50*(whiterooks-blackrooks)+90*(whitequeens-blackqueens))
    return score
end
