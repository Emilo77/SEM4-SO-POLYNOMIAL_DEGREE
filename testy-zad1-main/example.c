#include <assert.h>

int polynomial_degree(const int *y, int n);

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
