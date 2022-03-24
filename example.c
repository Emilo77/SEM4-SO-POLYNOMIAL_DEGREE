#include <assert.h>
#include "poly.c"
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int polynomial_degree(const int *y, size_t n) {
    if (n == 1 && y[0] == 0) {
        return -1;
    }
    if (n == 1) {
        return 0;
    }
    if (y[0] == y[1] && y[0] == 0) {
        return -1;
    }
    if (y[0] == y[1]) {
        return 0;
    }
    if (n == 2) {
        return 1;
    }

    int *oldArr = (int *) y;
    int minDegree = 1;
    bool oldArrIsY = true;
    int *newArr;

    while(n != 2) {
        n--;
        newArr = malloc(sizeof(int) * n);
        for(int i = 0; i < n; i++) {
            newArr[i] = oldArr[i + 1] - oldArr[i];
        }

        if(oldArrIsY) {
            oldArrIsY = false;
        } else {
            free(oldArr);
        }

        if(newArr[0] == newArr[1]) {
            free(newArr);
            return minDegree;
        }

        minDegree++;
        oldArr = newArr;
    }

    if(newArr[0] != newArr[1]) {
        free(newArr);
        return minDegree + 1;
    }
    free(newArr);
    return 69;
}

#define test(n, ans, y...) { \
	int tab[n] = y; \
	assert(polynomial_degree(tab, n) == ans); \
}

int main() {
	test(5, 1, {-9, 0, 9, 18, 27});
	test(9, 2, {1, 4, 9, 16, 25, 36, 49, 64, 81});
	test(1, 0, {777});
	test(2, 0, {5, 5});
	test(1, -1, {0});
	test(4, -1, {0, 0, 0, 0});
	test(66, 65, {1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1});
}
