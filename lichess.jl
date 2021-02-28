using JSON
using PyCall
using Chess
include("evaluate.jl")
include("search.jl")
function wait_for_challenge(http)
    
    s = http.Session()
    r = s.get(url,headers=headers,stream=true)
    for line in r.iter_lines()
        if(chomp(line) != "")
            println("Found a challenge.")
            r.close()
            return line
        else
            println("No new challenges.")
        end
    end
end
function accept_game(http,id::String)
    url = "https://lichess.org/api/challenge/"*id*"/accept"
    headers = Dict([("Authorization","Bearer mH7mhWYahnBc7IB0")])
    r = http.post(url,headers=headers)
end
function decline_game(http,id::String)
    url = "https://lichess.org/api/challenge/"*id*"/decline"
    headers = Dict([("Authorization","Bearer mH7mhWYahnBc7IB0")])
    r = http.post(url,headers=headers)
end
function wait_for_game(http)
    url = "https://lichess.org/api/stream/event"
    headers = Dict([("Authorization","Bearer mH7mhWYahnBc7IB0")])
    finalline = get_challenge(http)
    di = JSON.parse(finalline)
    if di["challenge"]["timeControl"]["limit"] >= 170 && di["challenge"]["timeControl"]["increment"] >= 1.5
        accept_game(http,di["challenge"]["id"])
        make_lichess_move(http,di["challenge"]["id"],"e2e4")
        return di["challenge"]["id"]
    else
        #If the game was not acceptable, decline and wait again
        decline_game(http,di["challenge"]["id"])
        wait_for_game(http)
    end
end
function make_lichess_move(http,id::String,move::String)
    url = "https://lichess.org/api/bot/game/"*id*"/move/"*move
    headers = Dict([("Authorization","Bearer mH7mhWYahnBc7IB0")])
    r = http.post(url,headers=headers)
    return r.status_code
end
function wait_for_moves(http, id::String)
    url = "https://lichess.org/api/bot/game/stream/"*id
    headers = Dict([("Authorization","Bearer mH7mhWYahnBc7IB0")])
    s = http.Session()
    r = s.get(url,headers=headers,stream=true)
    global prevmoves = ""
    for line in r.iter_lines()
        if line != ""
            state = JSON.parse(line)
        else
            continue
        end

        moves = ""
        if state["type"] == "gameFull"
            moves = state["state"]["moves"]
        else
            moves = state["moves"]
        end
        a = Chess.startboard()
        allmoves = String.(split(moves))
        if(prevmoves == allmoves)
            continue
        end
        prevmoves = allmoves
        
        Chess.domoves!(a,allmoves...)
        if Chess.sidetomove(a) == WHITE
            legalmoves = Chess.moves(a)
            if Chess.ischeckmate(a)
                r.close()
                println("Lost the game, damn!")
                break
            else
                nextpositions = map(x -> Chess.domove(a,x),legalmoves)
                println("Searching for best move..")
                highestid = findmax(map(x -> alphabeta(x,4,-50000,50000,true),nextpositions))[2]
                println("Search completed" )
                println(Chess.tostring(legalmoves[highestid]))
                r = make_lichess_move(http,id,Chess.tostring(legalmoves[highestid]))
                println(r)
                continue
            end
        else
            continue
        end
        
        

    end
end
http = PyCall.pyimport("requests")
function play_game(http)
    id = wait_for_game(http)
    wait_for_moves(http,id)

end
play_game(http)
