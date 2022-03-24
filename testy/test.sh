#!/bin/bash

GREEN="\e[1;32m"
RED="\e[1;31m"
DEFAULT="\e[0m"

function test_ok {
    printf "${GREEN}OK${DEFAULT}\n"
}

function test_bad {
    printf "${RED}WRONG${DEFAULT}\n"
}

function run {
    if ! nasm -f elf64 -w+all -w+error -o polynomial_degree.o ../polynomial_degree.asm; then
        test_bad
        echo "Błąd kompilacji ../polynomial_degree.asm"
        exit 1
	fi
    if ! gcc -c -Wall -Wextra -std=c17 -O2 -o $1.o $1.c; then
        test_bad
        echo "Błąd kompilacji $1.c"
        exit 1
	fi
    if ! gcc -o $1 $1.o polynomial_degree.o; then
        test_bad
        echo "Błąd linkowania $1.o polynomial_degree.o"
        exit 1
	fi

    "./$1"
    code=$?
    
	if [ $code -eq 0 ]; then
		test_ok
		return 0
	else
		test_bad
		echo "Runtime Error"
		exit 1
	fi
}

function run_all_tests {
    for c_file in $(ls *.c); do
		name=${c_file%.c}
		echo -n "$name "
		run "$name"
    done
}

run_all_tests 2>/dev/null
