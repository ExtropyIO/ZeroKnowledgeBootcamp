import subprocess
from time import sleep
import glob
import os
import sys
import hashlib

ex_map = {
    "ex1": "./exercises/cairo/ex1.cairo",
    "ex2": "./exercises/cairo/ex2.cairo",
    "ex3": "./exercises/cairo/ex3.cairo",
    "ex4": "./exercises/cairo/ex4.cairo",
    "ex5": "./exercises/cairo/ex5.cairo",
    "ex6": "./exercises/cairo/ex6.cairo",   
    "ex7": "./exercises/cairo/ex7.cairo",   
    "basic": "./exercises/contracts/basic/basic.cairo",
    "battleship": "./exercises/contracts/battleship/battleship.cairo",
    "erc20": "./exercises/contracts/erc20/erc20.cairo",
    "erc721": "./exercises/contracts/erc721/erc721.cairo",    
}

test_map = {
    "ex1": "./test/test_ex1.cairo",
    "ex2": "./test/test_ex2.cairo",
    "ex3": "./test/test_ex3.cairo",
    "ex4": "./test/test_ex4.cairo",
    "ex5": "./test/test_ex5.cairo",
    "ex6": "./test/test_ex6.cairo",   
    "ex7": "./test/test_ex7.cairo",   
    "basic": "./test/test_basic.cairo",
 "battleship": "./test/test_battleship.cairo",
    "erc20": "./test/test_erc20.cairo",
    "erc721": "./test/test_erc721.cairo",     
}

def check_exercises_finished(exercise_path):
    file_content = (open(exercise_path, "r")).read()   
    if "## I AM NOT DONE" in file_content: 
        return False
    else:
        return True

def get_latest_exercises(set_dir):

    ## Get soprted list of all exercises
    exercises = sorted(os.listdir(f"./exercises/{set_dir}"))
    print("exercises: ",exercises)
    theme = None

    ## Find latest one    
    for ids, ex in enumerate(exercises):
        if check_exercises_finished(f"./exercises/{set_dir}/{ex}") == False:
            return ex    

        ## Handle last one
        if ids == len(exercises) - 1:
            print("You reached the end of this theme.")

## Set new theme
def get_new_set():
    user_input = 0
    while True:
        try:
            user_input = int(input("Pick exercises want to work on\n\tcairo programs\t(1)\n\tcairo contracts\t(2)\n"))
            if user_input < 4:                
                if user_input == 1:
                    return 1
                elif user_input == 2:
                    return 2                
        except KeyboardInterrupt:
            sys.exit(0)    
        except:
            print("You need to input a number 1-3")
            None

def file_hash(file_path):       
    file_content = (open(file_path, "r")).read()   
    hash_object = hashlib.sha256(file_content.encode('utf-8'))
    hex_dig = hash_object.hexdigest()    
    return hex_dig   


def main_logic():

    ## Find theme to work on
    set_dir = get_new_set()

    ## Loop forever over picked theme 
    while True:                  

        latest_exercise = ""            

        ## Enumerate mappings
        for i, ex in enumerate(ex_map):
            if set_dir == 2 and ex[:2] == "ex":                
                continue 

            if check_exercises_finished(ex_map[ex]) == False:                          
                latest_exercise = ex                    
                break        

        ex_hash = ""

        ## Loop until exercise set to be finished
        while True:

            ## Set hash
            new_hash = file_hash(ex_map[ex])        

            ## If hash is different test the file
            if new_hash != ex_hash:
                ex_hash = new_hash                
                subprocess.run(["protostar", "test",test_map[ex]])

            ## Check if exit phrase removed
            if check_exercises_finished(ex_map[ex]):
                break

            sleep(0.1)
        
    
main_logic()
    
