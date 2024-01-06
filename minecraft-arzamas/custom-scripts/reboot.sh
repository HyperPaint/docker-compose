#!/bin/sh

log() {
  # ISO-8601
  echo "[$(date '+%FT%TZ')] [$0] $1"
}

error() {
  # ISO-8601
  echo "[$(date '+%FT%TZ')] [$0] $1" 1>&2
}

log "[RCON] Запланирована перезагрузка через $REBOOT_TIME_TO_WAIT секунд!"
mcrcon "tellraw @a {\"text\":\"Запланирована перезагрузка через $REBOOT_TIME_TO_WAIT секунд!\",\"color\":\"$TELLRAW_COLOR\"}" || error "$MCRCON_CONNECTION_FAILED"

for i in $(seq "$REBOOT_TIME_TO_WAIT_STEP" "$REBOOT_TIME_TO_WAIT_STEP" "$(echo "$REBOOT_TIME_TO_WAIT" - "$REBOOT_TIME_TO_WAIT_STEP" | bc)")
do
  sleep "$REBOOT_TIME_TO_WAIT_STEP"
  log "[RCON] Перезагрузка через $(echo "$REBOOT_TIME_TO_WAIT" - "$i" | bc) секунд"
  mcrcon "tellraw @a {\"text\":\"Перезагрузка через $(echo "$REBOOT_TIME_TO_WAIT" - "$i" | bc) секунд\",\"color\":\"$TELLRAW_COLOR\"}" || error "$MCRCON_CONNECTION_FAILED"
done

sleep "$REBOOT_TIME_TO_WAIT_STEP"
log "[RCON] Перезагрузка!"
mcrcon "tellraw @a {\"text\":\"Перезагрузка!\",\"color\":\"$TELLRAW_COLOR\"}" || error "$MCRCON_CONNECTION_FAILED"

sleep 1

mcrcon "stop" || error "$MCRCON_CONNECTION_FAILED"
