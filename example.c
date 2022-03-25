#include "stdio.h"
#include "polynomial_degree.c"

int main() {
    const int* str;
    size_t n = 100;
    int res = polynomial_degree(str, n);


    printf("res = %d\n", res);

}