#!/bin/sh

log() {
  # ISO-8601
  echo "[$(date '+%FT%TZ')] [$0] $1"
}

error() {
  # ISO-8601
  echo "[$(date '+%FT%TZ')] [$0] $1" 1>&2
}

backup() {
  log "[RCON] Создаётся резервная копия сервера!"
  mcrcon "tellraw @a {\"text\":\"Создаётся резервная копия сервера!\",\"color\":\"$TELLRAW_COLOR\"}" || error "$MCRCON_CONNECTION_FAILED"

  log "Сохранение мира!"
  # Принудительное сохранение мира
  mcrcon "save-all flush" || error "$MCRCON_CONNECTION_FAILED"
  log "Сохранение мира завершено"

  log "Формируется копия сервера!"
  file="$(date '+%Y-%m-%dT%H-%M-%SZ')"
  # Сделать бэкап директории-источника
  tar c $BACKUP_TAR_PARAMS -f "/root/$file.tar" -C "$BACKUP_DIRECTORY_SOURCE" .
  log "Формирование копии сервера завершено"

  log "[RCON] Резервная копия сервера создана"
  mcrcon "tellraw @a {\"text\":\"Резервная копия сервера создана\",\"color\":\"$TELLRAW_COLOR\"}" || error "$MCRCON_CONNECTION_FAILED"

  log "Архивируется копия сервера!"
  # Сжать бэкап в промежуточной директории
  gzip "/root/$file.tar"
  log "Архивирование копии сервера завершено"

  log "Резервная копия перемещается в целевой каталог!"
  # Переместить в директорию-цель
  chmod 754 "/root/$file.tar.gz"
  mv "/root/$file.tar.gz" "$BACKUP_DIRECTORY_TARGET/"
  log "Перемещение резервной копии в целевой каталог завершено"
}

cleanup() {
  if [ "$(ls "$BACKUP_DIRECTORY_TARGET" | grep -c ^)" -gt "$BACKUP_HISTORY_COUNT" ]; then
    rm -f "$BACKUP_DIRECTORY_TARGET/$(ls "$BACKUP_DIRECTORY_TARGET" | head -1)"
    cleanup
  fi
}

cleanup
backup
cleanup
