#!/bin/bash

[[ -f "calculated-winrates.json" ]] || exit 1

prepare_as_csv() {
    cat "calculated-winrates.json" |
        jq '
            map(
                map(
                        {
                        corporation: (.corporation + " (" + (.totalGames | tostring) + ")"),
                        gamesWon: .place1
                        }
                      | select(.gamesWon != null)  
                    ) 
                )'"[$1]" |
        mlr --j2c --ho cat
}

prepare_as_csv 0 | termgraph --label-before > winrate_2pl.txt
prepare_as_csv 1 | termgraph --label-before > winrate_3pl.txt
prepare_as_csv 2 | termgraph --label-before > winrate_4pl.txt
prepare_as_csv 3 | termgraph --label-before > winrate_5pl.txt
