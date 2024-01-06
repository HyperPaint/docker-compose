#!/usr/bin/python

import random

from handbook import info

STORAGE = "storage.txt"
SEQUENCE_LENGTH = len(info)

plan = []


def save_plan():
    # print("Saving plan...")
    with open(STORAGE, "wt") as file:
        for item in plan:
            file.write(str(item) + "\n")
    # print("Saved " + str(plan))


def load_plan():
    # print("Loading plan...")
    with open(STORAGE, "rt") as file:
        while line := file.readline():
            plan.append(int(line))
    # print("Loaded " + str(plan))


def create_plan():
    # print("Creating plan...")
    plan.clear()
    for i in range(0, SEQUENCE_LENGTH):
        plan.append(int(i))
    random.shuffle(plan)
    # print("Created " + str(plan))


def execute_task(plan_item):
    # print("Executing " + str(plan) + " plan item...")
    info[plan_item]()
    # print("Executed " + str(plan) + " plan item")


def delete_task(plan_item):
    # print("Deleting " + str(plan) + " plan item...")
    plan.remove(plan_item)
    # print("Deleted " + str(plan) + " plan item")


try:
    load_plan()
except FileNotFoundError:
    # Файл не создан
    create_plan()
if len(plan) > 0:
    # План не закончился
    try:
        execute_task(plan[0])
    except IndexError:
        # Справочник изменился
        create_plan()
        execute_task(plan[0])
else:
    # План закончился
    create_plan()
    execute_task(plan[0])
delete_task(plan[0])
save_plan()
