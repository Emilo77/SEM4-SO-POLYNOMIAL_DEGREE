#include <stdint-gcc.h>
#include "stdio.h"
#include "polynomial_degree.c"
#include "limits.h"

int main() {
    const int* str;
    size_t n = 100;
    uint64_t res = polynomial_degree(str, n);


    printf("res = %lu\n", res);

}