#include <assert.h>

int polynomial_degree(const int *y, int n);

#define test(n, ans, y...) { \
	int tab[n] = y; \
	assert(polynomial_degree(tab, n) == ans); \
}

int main() {
	test(16, 15, {93, 0, 4, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0});
}
