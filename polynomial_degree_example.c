#include <stddef.h>
#include <stdio.h>

// Testowana funkcja w asemblerze
int polynomial_degree(int const *y, size_t n);

static const int poly0[] = {-9, 0, 9, 18, 27};
static const int degree0 = 1;

static const int poly1[] = {1, 4, 9, 16, 25, 36, 49, 64, 81};
static const int degree1 = 2;

static const int poly2[] = {777};
static const int degree2 = 0;

static const int poly3[] = {5, 5};
static const int degree3 = 0;

static const int poly4[] = {0};
static const int degree4 = -1;

static const int poly5[] = {0, 0, 0, 0};
static const int degree5 = -1;

static const int poly6[] = {
  1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1,
  1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1,
  1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1,
  1, -1, 1, -1, 1, -1};
static const int degree6 = 65;

#define TEST(t) {poly##t, SIZE(poly##t), degree##t}
#define SIZE(x) (sizeof (x) / sizeof (x)[0])

typedef struct {
  int const *y;
  size_t    n;
  int       d;
} test_data_t;

static const test_data_t test_data[] = {
  TEST(0),
  TEST(1),
  TEST(2),
  TEST(3),
  TEST(4),
  TEST(5),
  TEST(6),
};

int main() {
  for (size_t test = 0; test < SIZE(test_data); ++test) {
    int d = polynomial_degree(test_data[test].y, test_data[test].n);
    if (d == test_data[test].d)
      printf("test %zu passed\n", test);
    else
      printf("test %zu failed with result %d\n", test, d);
  }
}
