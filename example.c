#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

int polynomial_degree(const int *y, int n);

#define test(n, ans, y...)                                                     \
  {                                                                            \
    int tab[n] = y;                                                            \
    assert(polynomial_degree(tab, n) == ans);                                  \
  }

void fill_arr(int *arr, int n) {
  for (int i = 1; i < n; i++) {
    arr[i] = i;
  }
}

void print_arr(int *arr, int n) {
  for (int i = 0; i < 10; i++) {
    printf("arr[%d] = %d  ", i, arr[i]);
  }
  printf("\n");

//  for (int i = 0; i < n - 1; i++) {
//    printf("%d ", arr[i] - arr[i + 1]);
//  }
//  printf("\n");
}


int main() {
  int n = 1000;
  int *arr = malloc(n * sizeof(int));
  fill_arr(arr, n);
  print_arr(arr, n);


  printf("res = %d\n", polynomial_degree(arr, n));

  //  assert(polynomial_degree(arr, n) == 1);
}
