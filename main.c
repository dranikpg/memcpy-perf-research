#include "stdlib.h"
#include "stdio.h"
#include "string.h"
#include "stddef.h"

#include <time.h>
#include <sys/time.h>

#define SIZES_CASES 13
int COPIES = 8192 * 100 * 100;

int SIZES[SIZES_CASES] = {2, 4, 8, 16, 32, 128, 256, 512, 1024, 2048, 4096, 8192, 8192 * 2};
char* SRC[SIZES_CASES];

void setup() {
    for (int i = 0; i < SIZES_CASES; i++) {
        SRC[i] = (char*) malloc(SIZES[i]);
    }
}

void test_memset(char* d, int c, size_t n) { memset(d, c, n); }

extern void test_loop(char* d, int c, size_t n);

extern void test_loopq(char* d, int c, size_t n);

extern void test_repstosb(char* d, int c, size_t n);

extern void test_repstosq(char* d, int c, size_t n);

#define TEST_CASES 5
void (*testfs[TEST_CASES])(char*, int, size_t) 
    = {&test_memset, test_loop, test_loopq, test_repstosb, test_repstosq};

int main() {
    setup();

    struct timespec start, stop;

    for (int s = 0; s < SIZES_CASES; s++) {
        printf("%d ", SIZES[s]);
        for (int t = 0; t < TEST_CASES; t++) {
            int its = 100;
            void (*func)(char*, int, size_t) = testfs[t];

            clock_gettime(CLOCK_REALTIME, &start);
            for (int i = 0; i < its; i++) func(SRC[s], 1, SIZES[s]);
            clock_gettime(CLOCK_REALTIME, &stop);
            double result = (stop.tv_sec - start.tv_sec) * 1e6 + (stop.tv_nsec - start.tv_nsec) / 1e3;

            printf("%f ", result);
        }
        printf("\n");
    }
}