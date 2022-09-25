# Repo overview

This package contains small exercises to get you used to reading and writing Cairo code, all while abstracting away much of the legwork that revolves around development, such as compilation or deployment.
Abstraction is accomplished using a script that automatically compiles, deploys and tests `.cairo` files, so what is left is to fix the code so that it fulfils desired criteria.

There are two distinct exercise sets:

- Cairo programs
- Starknet contracts

After the invocation, the Python script will iterate over the exercises, Cairo programs and StarkNet contracts.

This form of the tutorial has been inspired by [rustlings](https://github.com/rust-lang/rustlings) repo (used for learning rust) and likewise to communicate to the script to proceed to the next exercise tag `// I am not done` at the top of the file has to be removed.

# Set-up

Precursors necessary are:

- [protostar](https://docs.swmansion.com/protostar/docs/tutorials/installation)
- [python 3.7](https://www.python.org/downloads/)
- [cairo](https://www.cairo-lang.org/docs/quickstart.html)

# Starting autoloader script

From within the main repo directory, run:

    python3 main.py

In the background, it will invoke the following command (for the first exercise)

    protostar test test/test_ex1.cairo

with the exception that the python script will recompile and retest upon saving of any `.cairo` exercise file.

**All tests should pass without any modification of the test files.**

**Hence you must only modify the `.cairo` files in the `/exercises/` directory.**

# Cairo programs exercises

Cairo is a programming language for writing provable programs, where one party can prove computational integrity to the other party without revealing computation or the input data.

These are single purpose functions that accomplish some logic, that rather than being useful to some application, forces you to think the "cairo" way. Function declarations are not to be modified, as they are invoked from within the tests. If you find a way to solve a challenge without using up all of the available parameter slots, leave some unused rather than remove them.


# Conversion helper

File `conversion.py` in the root directory can be used for conversion between felt and strings and numbers and uint256.

To use that helper iteratively interactively run:

`python3 -i conversion.py`
