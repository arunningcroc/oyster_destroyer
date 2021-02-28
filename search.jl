using Chess
include("evaluate.jl")
function minimax(node, depth::Integer, maximizingPlayer::Bool)
    if depth == 0 || Chess.ischeckmate(node)
        return evaluate_pos(node)
    end
    legalmoves = Chess.moves(node)
    nextpositions = map(x -> Chess.domove(node,x),legalmoves)
    if maximizingPlayer
        eval = -5000000
        for pos in nextpositions
            eval = max(eval, minimax(pos,depth-1,false))
        end
        return eval
    else
        eval = +5000000
        for pos in nextpositions
            eval = min(eval,minimax(pos,depth-1,true))
        end
        return eval
    end

end
function alphabeta(node, depth::Integer, alpha::Real, beta::Real, maximizingPlayer::Bool)
    if depth == 0 || Chess.ischeckmate(node)
        return evaluate_pos(node)
    end
    legalmoves = Chess.moves(node)
    nextpositions = map(x -> Chess.domove(node,x),legalmoves)
    if maximizingPlayer
        eval = -50000
        for pos in nextpositions
            eval = max(eval, alphabeta(pos,depth-1,alpha,beta,false))
            alpha = max(alpha,eval)
            if alpha >= beta
                break
            end
            
        end
        return eval
    else
        eval = +50000
        for pos in nextpositions
            eval = min(eval, alphabeta(pos,depth-1,alpha,beta,true))
            beta = min(beta,eval)
            if beta <= alpha 
                break
            end
            
        end
        return eval
    end
end