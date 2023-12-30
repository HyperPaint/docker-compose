#!/bin/bash

number=0

# Массив
info[$number]='[{"text":"Ходят слухи, что у сервера есть ","color":"gold"},{"text":"группа","underlined":true,"color":"gold","clickEvent":{"action":"open_url","value":"https://vk.com/arzamasservermine"},"hoverEvent":{"action":"show_text","contents":"ссылка"}},{"text":" и ","color":"gold"},{"text":"чатик","underlined":true,"color":"gold","clickEvent":{"action":"open_url","value":"https://vk.me/join/7DLqLHiGgXmHM5eZbsz64MN7ULZRtNAUt5w="},"hoverEvent":{"action":"show_text","contents":"ссылка"}},{"text":" в ВК","color":"gold"}]';
number="$(echo "$number + 1" | bc)";

# Выбор случайного и вывод
current="$(echo "$RANDOM % ${#info[@]}" | bc)"

mcrcon "tellraw @a ${info[$current]}"
