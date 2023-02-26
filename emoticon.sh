#!/bin/bash

# Define an array of complex emoticons
EMOTICONS=(
    "¯\_(ツ)_/¯" "(╯°□°）╯︵ ┻━┻" "(ง'̀-'́)ง" "( ͡° ͜ʖ ͡°)" "(╯︵╰,)"
    "(っ◕‿◕)っ" "(ಥ﹏ಥ)" "(ง •̀_•́)ง" "(づ｡◕‿‿◕｡)づ" "(╬ಠ益ಠ)"
    "(ʘ‿ʘ)" "(╯°Д°）╯︵/(.□ . \)" "( ͡°👅 ͡°)" "(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧" "(ಠ‿ಠ)"
    "( ͡°⊖ ͡°)" "(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧" "(ง'̀-'́)ง" "(ʘ‿ʘ)" "(◕ᴗ◕✿)"
    "(✿◠‿◠)" "(╯°□°)╯︵ ʞooqǝɔɐɟ" "(ง'̀-'́)ง╭∩╮(ಠ۝ಠ)╭∩╮(ง'̀-'́)ง"
    "┬┴┬┴┤(･_├┬┴┬┴" "( ͡❛ ͜ʖ ͡❛)" "(╯°□°)╯︵ ┻━┻ ︵ ╯(°□° ╯)" "( ͡~ ͜ʖ ͡°)"
    "(ﾉ≧∀≦)ﾉ ‥…━━━★" "( ･_･)♡" "( ͡° ͜ʖ ͡°)╭∩╮" "( ͡• ͜ʖ ͡•)"
    "٩(◕‿◕｡)۶" "( ͠° ͟ʖ ͡°)" "(ง'̀-'́)ง✧" "┌( ಠ‿ಠ)┘" "(≧◡≦)"
    "(ง ื▿ ื)ว" "ಠ_ಠ" "(ง •̀_•́)งง" "ᕙ(⇀‸↼‶)ᕗ" "(ง°ل͜°)ง"
    "(⊙_◎)" "(⊙_◎)ノ" "(ﾉﾟ0ﾟ)ﾉ~" "ᕕ( ᐛ )ᕗ" "(≧∇≦)/"
    "(づ￣ ³￣)づ" "✌(-‿-)✌" "(ง^ᗜ^)ง" "ᕕ(⌐■_■)ᕗ ♪♬"
)

#GENERATE AND PRINT ONE EMOTICON
# Generate a random number between 0 and the length of the array
#RANDOM_INDEX=$((RANDOM % ${#EMOTICONS[@]}))

# Print the emoticon at the random index
#echo ${EMOTICONS[$RANDOM_INDEX]}

#GENERATE AND PRINT TWO EMOTICON
# Generate two random numbers between 0 and the length of the array
RANDOM_INDEX_1=$((RANDOM % ${#EMOTICONS[@]}))
RANDOM_INDEX_2=$((RANDOM % ${#EMOTICONS[@]}))

# Make sure the two random indexes are not equal
while [ $RANDOM_INDEX_2 -eq $RANDOM_INDEX_1 ]
do
    RANDOM_INDEX_2=$((RANDOM % ${#EMOTICONS[@]}))
done

# Print the two emoticons separated by a tab space
echo -e "${EMOTICONS[$RANDOM_INDEX_1]}\t${EMOTICONS[$RANDOM_INDEX_2]}"