#include <stdint-gcc.h>
#include "stdio.h"
#include <stdlib.h>
#include <assert.h>

int polynomial_degree(int const *y, size_t n);


#define test(n, ans, y...) { \
    int tab[n] = y;          \
    assert(polynomial_degree(tab, n) == ans); \
}


void fillArr(int *arr, size_t n, int k) {
    for (int i = 0; i < n; i++) {
        arr[i] = i;
    }
    for (int i = 0; i < 20; i++) {
        arr[i] = 2 * arr[i - 1] + 1;
    }
    arr[0] = 2;
}

void printArr(int *arr, size_t n) {
    for(int i = 0; i < 10; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    for(int i = 0; i < 9; i++) {
        printf("%d ", arr[i] - arr[i + 1]);
    }
    printf("\n");
}


int main() {

    size_t n = 100;
    int *arr = malloc(sizeof(int) * n);
    fillArr(arr, n, 0);
    int res = polynomial_degree(arr, n);

    printArr(arr, n);
    printf("res = %d\n", res);
    free(arr);
//
//
//    test(1, 0, { 777 });
//    test(2, 0, {5, 5});
//    test(1, -1, {0});
//    test(1, 0, {-2});
//    test(1, 0, {-1});
//    test(1, 0, {47});
//    test(1, 0, {15});
//    test(1, 0, {5});
//    test(1, 0, {28});
//    test(1, 0, {28});
//    test(1, 0, {30});
//    test(1, 0, {8});
//    test(1, 0, {39});
//    test(1, 0, {27});
//    test(1, 0, {57});
//    test(2, 0, {39, 39});
//    test(2, 0, {23, 23});
//    test(2, 0, {37, 37});
//    test(2, 0, {54, 54});
//    test(2, 0, {48, 48});
//    test(2, 0, {37, 37});
//    test(2, 0, {17, 17});
//    test(2, 0, {45, 45});
//    test(2, 0, {32, 32});
//    test(2, 0, {19, 19});
//    test(3, 0, {48, 48, 48});
//    test(3, 0, {33, 33, 33});
//    test(3, 0, {2, 2, 2});
//    test(3, 0, {11, 11, 11});
//    test(3, 0, {28, 28, 28});
//    test(3, 0, {5, 5, 5});
//    test(3, 0, {25, 25, 25});
//    test(3, 0, {15, 15, 15});
//    test(3, 0, {50, 50, 50});
//    test(3, 0, {37, 37, 37});

}