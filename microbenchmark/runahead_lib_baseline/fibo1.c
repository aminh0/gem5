#include "runahead.h"
#include <stdio.h>

volatile int array[1000000] __attribute__((aligned(64)));

int fibo(int n) {
    // non-recursive Fibonacci
    int a = 0, b = 1, c;
    for (int i = 0; i < n; i++) {
        c = a + b;
        a = b;
        b = c;
    }
    return a;
}

int main() {
    int temp;
    for (int i = 0; i < 20000; i++) {
        runahead_to(st);
            temp = fibo(i);
        st:
            array[i] = temp;
        runahead_fence();
    }
    printf("Done!\n");
}