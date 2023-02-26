cat pokedex.json | jq '.[] | . + {type: .type[]} | {(.type): {(.id|tostring): .}} |.[][]|=(.|del(.type, .id))' | jq -s 'reduce .[] as $p ({}; . * $p)'
