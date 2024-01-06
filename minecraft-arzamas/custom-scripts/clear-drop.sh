#!/bin/sh

log() {
  # ISO-8601
  echo "[$(date '+%FT%TZ')] [$0] $1"
}

error() {
  # ISO-8601
  echo "[$(date '+%FT%TZ')] [$0] $1" 1>&2
}

log "$CHECK"
result=$(mcrcon "execute if entity @e[type=minecraft:item]" || error "$MCRCON_CONNECTION_FAILED")
result=$(echo "$result" | tr -d "\n\r")
log "$result"

# Проверка прошла
if [ "$(echo "$result" | grep -c "Test passed")" -eq 1 ]; then
  # Количество предметов больше установленного лимита
  if [ "$(echo "$result" | grep -ioE "count:\s[0-9]+" | grep -ioE "[0-9]+")" -gt "$CLEAR_DROP_CHECK_TRIGGER" ]; then
    log "$CHECK_SUCCESS"

    log "[RCON] Зафиксировано аномальное количество выброшенных предметов!"
    mcrcon "tellraw @a {\"text\":\"Зафиксировано аномальное количество выброшенных предметов!\",\"color\":\"$TELLRAW_COLOR\"}" || error "$MCRCON_CONNECTION_FAILED"
    log "[RCON] Запланирована очистка через $CLEAR_DROP_TIME_TO_WAIT секунд!"
    mcrcon "tellraw @a {\"text\":\"Запланирована очистка через $CLEAR_DROP_TIME_TO_WAIT секунд!\",\"color\":\"$TELLRAW_COLOR\"}" || error "$MCRCON_CONNECTION_FAILED"

    for i in $(seq "$CLEAR_DROP_TIME_TO_WAIT_STEP" "$CLEAR_DROP_TIME_TO_WAIT_STEP" "$(echo "$CLEAR_DROP_TIME_TO_WAIT" - "$CLEAR_DROP_TIME_TO_WAIT_STEP" | bc)")
    do
      sleep "$CLEAR_DROP_TIME_TO_WAIT_STEP"
      log "[RCON] Очистка через $(echo "$CLEAR_DROP_TIME_TO_WAIT" - "$i" | bc) секунд"
      mcrcon "tellraw @a {\"text\":\"Очистка через $(echo "$CLEAR_DROP_TIME_TO_WAIT" - "$i" | bc) секунд\",\"color\":\"$TELLRAW_COLOR\"}" || error "$MCRCON_CONNECTION_FAILED"
    done

    sleep "$CLEAR_DROP_TIME_TO_WAIT_STEP"
    log "[RCON] Очистка!"
    mcrcon "tellraw @a {\"text\":\"Очистка!\",\"color\":\"$TELLRAW_COLOR\"}" || error "$MCRCON_CONNECTION_FAILED"

    sleep 1

    mcrcon "kill @e[type=minecraft:item]" || error "$MCRCON_CONNECTION_FAILED"
  else 
    log "$CHECK_FAILED"
  fi
else
  log "$CHECK_FAILED"
fi
