def corp(place; corp; score): 
    if(corp != null) then
    {
        "place": place,
        "corp": corp,
        "score": score
    } 
    else empty end;

def percentage_games_with_place(place; $games): 
      map(select(.place == place )) 
    | length 
    | if (. > 0) then 
        . / ($games | length)
        | . * 10000 | floor | . / 100 
        else null end;

[."games-production"[]]
| group_by(.players)[]
| map(
        .corporations as $corps
        | .scores as $scores
        | .corporationScores = 
            reduce range(5) as $place([];
                . + [corp($place+1; 
                        $corps[$place]; 
                        $scores[$place])])
        | .corporationScores[] + {players}
    )
| group_by(.corp)
| map(
     {
     corporation: .[0].corp,
     totalGames: length,
     place1: percentage_games_with_place(1; .),
     place2: percentage_games_with_place(2; .),
     place3: percentage_games_with_place(3; .),
     place4: percentage_games_with_place(4; .),
     place5: percentage_games_with_place(5; .)
    } 
    | with_entries(select(.value != null))
)
| .