#include "runahead.h"
#include <stdio.h>

volatile long long array[4][1000000];

int main() {
    int i, j;
    for (j = 0; j < 1000000; j+=8) { // load from cache every time
        runahead_to(dest);
        for (i = 0; i < 4 + j % 4; i++) {
            array[i%4][j] = i + j;
        }
        dest:
        array[j%4][j+9] = array[(j+1)%4][j+10] % 10;
        runahead_fence();
    }
    printf("Done!");
    return 0;
}