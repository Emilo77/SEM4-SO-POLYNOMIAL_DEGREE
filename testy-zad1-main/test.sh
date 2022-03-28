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

function run_c {
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
		rm "$1" "polynomial_degree.o" "$1.o"
		return 0
	else
		test_bad
		echo "Runtime Error"
		return 0
	fi
}

function run_asm {
    if ! nasm -f elf64 -w+all -w+error -o polynomial_degree.o ../polynomial_degree.asm; then
        test_bad
        echo "Błąd kompilacji ../polynomial_degree.asm"
        exit 1
	fi
	if ! nasm -f elf64 -w+all -w+error -o $1.o $1.asm; then
        test_bad
        echo "Błąd kompilacji $1.asm"
        exit 1
	fi
	if ! ld -o $1 $1.o polynomial_degree.o; then
		test_bad
		echo "Błąd linkowania $1.o polynomial_degree.o"
		exit 1
	fi

	"./$1"
	code=$?

	if [ $code -eq 0 ]; then
		test_ok
		rm "$1" "polynomial_degree.o" "$1.o"
		return 0
	else
		test_bad
		echo "Runtime Error"
		return 0
	fi
}

function run_all_tests {
    for c_file in $(ls *.c); do
		name=${c_file%.c}
		echo -n "$name "
		run_c "$name"
    done

	for asm_file in $(ls *.asm); do
		name=${asm_file%.asm}
		echo -n "$name "
		run_asm "$name"
	done

    if ! nasm -f elf64 -w+all -w+error -o polynomial_degree.o ../polynomial_degree.asm; then
        test_bad
        echo "Błąd kompilacji ../polynomial_degree.asm"
        exit 1
	fi
	python3 'gen_antihash.py'
	echo -n 'antihash_generated_test '
	run_c 'antihash_generated_test'
	# rm 'antihash_generated_test.c'
}

ulimit -s 2200
run_all_tests 2>/dev/null
