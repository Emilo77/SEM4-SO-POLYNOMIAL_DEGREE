#include <assert.h>

int polynomial_degree(const int *y, int n);

#define test(n, ans, y...) { \
	int tab[n] = y; \
	assert(polynomial_degree(tab, n) == ans); \
}

int main() {
	test(1, 0, {47});
	test(1, 0, {15});
	test(1, 0, {5});
	test(1, 0, {28});
	test(1, 0, {28});
	test(1, 0, {30});
	test(1, 0, {8});
	test(1, 0, {39});
	test(1, 0, {27});
	test(1, 0, {57});
	test(2, 0, {39, 39});
	test(2, 0, {23, 23});
	test(2, 0, {37, 37});
	test(2, 0, {54, 54});
	test(2, 0, {48, 48});
	test(2, 0, {37, 37});
	test(2, 0, {17, 17});
	test(2, 0, {45, 45});
	test(2, 0, {32, 32});
	test(2, 0, {19, 19});
	test(3, 0, {48, 48, 48});
	test(3, 0, {33, 33, 33});
	test(3, 0, {2, 2, 2});
	test(3, 0, {11, 11, 11});
	test(3, 0, {28, 28, 28});
	test(3, 0, {5, 5, 5});
	test(3, 0, {25, 25, 25});
	test(3, 0, {15, 15, 15});
	test(3, 0, {50, 50, 50});
	test(3, 0, {37, 37, 37});
	test(4, 2, {43, 1, 8, 64});
	test(4, 2, {52, 35, 24, 19});
	test(4, 2, {16, 63, 67, 28});
	test(4, 2, {27, 63, 65, 33});
	test(4, 2, {17, 58, 53, 2});
	test(4, 2, {33, 22, 31, 60});
	test(4, 2, {2, 32, 41, 29});
	test(4, 2, {50, 18, 8, 20});
	test(4, 0, {32, 32, 32, 32});
	test(4, 2, {18, 25, 24, 15});
	test(5, 3, {43, 14, 15, 29, 39});
	test(5, 3, {49, 19, 15, 27, 45});
	test(5, 2, {56, 53, 43, 26, 2});
	test(5, 3, {12, 5, 2, 7, 24});
	test(5, 3, {44, 25, 13, 16, 42});
	test(5, 3, {7, 2, 13, 19, -1});
	test(5, 2, {18, 55, 65, 48, 4});
	test(5, 2, {43, 39, 37, 37, 39});
	test(5, 3, {39, 39, 12, -2, 37});
	test(5, 2, {35, 52, 59, 56, 43});
	test(6, 4, {6, 6, 4, 29, 62, 36});
	test(6, 4, {55, 33, 5, 25, 64, 10});
	test(6, 4, {65, 8, 33, 66, 63, 10});
	test(6, 4, {27, 3, 28, 31, 9, 27});
	test(6, 4, {5, 64, 48, 33, 41, 40});
	test(6, 4, {61, 0, 7, 28, 35, 26});
	test(6, 4, {50, -1, 53, 53, 0, 55});
	test(6, 4, {39, 66, 55, 43, 37, 14});
	test(6, 4, {43, 34, 51, 59, 48, 33});
	test(6, 4, {1, 23, 7, 0, 15, 31});
	test(7, 5, {63, 2, 6, 24, 21, 2, 36});
	test(7, 5, {65, 12, 50, 60, 34, 17, 49});
	test(7, 5, {64, -1, 59, 57, 9, 1, 56});
	test(7, 5, {42, 17, 27, 8, 10, 62, 37});
	test(7, 5, {57, 15, 64, 62, 32, 35, 43});
	test(7, 5, {49, 67, 66, 48, 39, 48, 26});
	test(7, 5, {45, 64, 33, 40, 61, 48, 17});
	test(7, 5, {7, 2, 16, 46, 45, 9, 64});
	test(7, 5, {27, 56, 61, 21, 4, 43, 12});
	test(7, 5, {6, 47, 46, 33, 12, -2, 54});
	test(8, 6, {51, 27, 48, 5, -2, 48, 63, 58});
	test(8, 6, {10, 3, 52, 25, 2, 25, 42, 45});
	test(8, 6, {31, 34, 47, 41, 12, -1, 32, 10});
	test(8, 6, {45, 39, 44, 4, 14, 57, 27, 38});
	test(8, 6, {66, 28, 24, 60, 54, 19, 37, 24});
	test(8, 6, {0, 35, 26, 17, 11, 19, 45, 7});
	test(8, 7, {24, 25, 11, 38, 62, 48, 25, 8});
	test(8, 6, {37, 6, 19, 63, 39, -2, 66, 58});
	test(8, 6, {50, 30, 59, 48, 39, 44, 30, 50});
	test(8, 6, {16, 18, 8, 31, 40, 32, 44, 9});
	test(9, 7, {37, 46, 61, 1, 2, 22, 7, 61, 63});
	test(9, 7, {11, 21, 14, 41, 27, 10, 36, 41, 51});
	test(9, 7, {65, 51, 21, 26, 53, 49, 20, 43, 29});
	test(9, 7, {63, 1, 40, 11, 14, 30, 12, 26, 13});
	test(9, 7, {50, 27, 54, 42, 44, 48, 30, 31, 22});
	test(9, 7, {2, 16, 49, 45, 60, 53, 10, 31, 10});
	test(9, 7, {62, -1, 61, 26, 16, 19, 3, 65, 58});
	test(9, 7, {29, 51, 18, 29, 8, -2, 35, 20, 7});
	test(9, 8, {41, -2, 52, 9, 61, 52, 38, 67, 5});
	test(9, 8, {10, 2, 15, 33, 39, 46, 26, 29, 28});
	test(10, 8, {67, 4, 61, 39, 11, 13, 26, 28, 21, 64});
	test(10, 8, {43, 30, 31, 2, 17, 25, 27, 58, 16, 37});
	test(10, 8, {58, 8, 65, 35, 2, 5, 11, 13, 66, 58});
	test(10, 8, {66, 28, 13, 46, 33, 44, 57, 6, 48, 36});
	test(10, 8, {8, 22, 20, 16, 62, 64, 40, 65, 8, 26});
	test(10, 9, {19, 32, 47, 40, 47, 50, 18, 16, 11, 42});
	test(10, 8, {67, 15, 28, 24, 2, 36, 61, 7, 60, 52});
	test(10, 8, {43, 31, 38, 64, 43, 48, 53, 3, 66, 64});
	test(10, 8, {24, 64, 51, 3, 26, 56, 43, 32, 32, 0});
	test(10, 9, {11, 65, 4, 1, 57, 54, 51, 63, 38, 11});
}
