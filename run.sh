nasm -f elf64 -w+all -w+error -o polynomial_degree.o polynomial_degree.asm
gcc -c -Wall -Wextra -std=c17 -O2 -o polynomial_degree_example.o polynomial_degree_example.c
gcc -o polynomial_degree_example polynomial_degree_example.o polynomial_degree.o
./polynomial_degree_example
