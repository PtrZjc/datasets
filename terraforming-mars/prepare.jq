def corp(place; corp; score): 
    if(corp != null) then
    {
        "place": place,
        "corp": corp,
        "score": score
    } 
    else empty end;

[."games-production"[]]
| group_by(.players)[]
| length as $totalPlaysPerPlayerCount
| map(
        .corporations as $corps
        | .scores as $scores
        | .corporationScores = 
        
        reduce range(5) as $place([];
            . + [corp($place+1; 
                      $corps[$place]; 
                      $scores[$place])])
        
    )
| .