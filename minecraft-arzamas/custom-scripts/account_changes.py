#!/usr/bin/python

import mysql.connector
import subprocess
import time

while True:
    try:
        with mysql.connector.connect(
            host="database.shared_default",
            database="minecraft_easy_auth",
            user="root",
            password="password"
        ) as connection:
            with connection.cursor() as cursor:
                SELECT_UNPROCESSED_QUERY = f"""
                SELECT
                    id, 
                    username,
                    password,
                    action,
                    generate_minecraft_offline_uuid(username) as offline_uuid,
                    generate_easy_auth_offline_uuid(username) as easy_auth_uuid
                FROM account_changes
                WHERE
                    row_update_timestamp >= NOW() - INTERVAL 1 DAY
                    AND processed = 'N'
                ORDER BY id ASC;"""
                cursor.execute(SELECT_UNPROCESSED_QUERY)
                result = cursor.fetchall()
                if len(result) > 0:
                    for row in result:
                        UPDATE_PROCESSED_QUERY = f"""
                        UPDATE account_changes
                        SET
                            processed = 'Y',
                            row_update_timestamp = now()
                        WHERE
                            id = { str(row[0]) };"""
                        match row[3]:
                            case "I":
                                print("Получена заявка id=" + str(row[0]) + " на создание аккаунта для " + str(row[1]))
                                process = subprocess.run(["mcrcon", "auth register " + str(row[5]) + " " + str(row[2])])
                                if process.returncode != 0:
                                    raise Exception(process)
                                cursor.execute(UPDATE_PROCESSED_QUERY)
                                print("Обработана заявка id=" + str(row[0]) + " на создание аккаунта для " + str(row[1]))
                            case "U":
                                print("Получена заявка id=" + str(row[0]) + " на обновление пароля для " + str(row[1]))       
                                process = subprocess.run(["mcrcon", "auth update " + str(row[5]) + " " + str(row[2])])
                                if process.returncode != 0:
                                    raise Exception(process)
                                cursor.execute(UPDATE_PROCESSED_QUERY)
                                print("Обработана заявка id=" + str(row[0]) + " на обновление пароля для " + str(row[1]))
                            case "D":
                                print("Получена заявка id=" + str(row[0]) + " на удаление аккаунта для " + str(row[1]))
                                RCON_COMMAND = "mcrcon 'auth remove " + str(row[5]) + "'"
                                process = subprocess.run(["mcrcon", "auth remove " + str(row[5])])
                                if process.returncode != 0:
                                    raise Exception(process)
                                cursor.execute(UPDATE_PROCESSED_QUERY)
                                print("Обработана заявка id=" + str(row[0]) + " на удаление аккаунта для " + str(row[1]))
                            case _:
                                print("Получена заявка id=" + str(row[0]) + " с неизвестным действием " + str(row[3]) + " для " + str(row[1]))
                                UPDATE_ERROR_QUERY = f"""
                                UPDATE account_changes
                                SET
                                    processed = 'E',
                                    row_update_timestamp = now()
                                    WHERE id = { str(row[0]) };"""
                                cursor.execute(UPDATE_ERROR_QUERY)
                        connection.commit()
                        # Ожидание для корректного обновления кэша EasyAuth
                        time.sleep(1)
        # Проверка заявок раз в минуту
        time.sleep(60)
    except mysql.connector.Error as e:
        print(e)
    except Exception as e:
        print(e)
