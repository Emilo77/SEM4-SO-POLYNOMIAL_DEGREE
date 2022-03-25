nasm -f elf64 -o polynomial_degree.o polynomial_degree.asm
gcc -c -std=c17 -O2 -o example.o example.c
gcc -o example example.o polynomial_degree.o
./example
