#include "stdlib.h"
#include "stdio.h"
#include "string.h"
#include "stddef.h"

#include <time.h>
#include <sys/time.h>

#define SIZES_CASES 13
int COPIES = 8192 * 100 * 100;

int SIZES[SIZES_CASES] = {2, 4, 8, 16, 32, 128, 256, 512, 1024, 2048, 4096, 8192, 8192 * 2};
char* DST[SIZES_CASES];
char* SRC[SIZES_CASES];

void setup() {
    for (int i = 0; i < SIZES_CASES; i++) {
        SRC[i] = (char*) malloc(SIZES[i]);
        DST[i] = (char*) malloc(SIZES[i]);
    }
}

inline void test_memcpy(char* d, char *s, int c) { memcpy(d, s, c); }

extern void test_loop(char* d, char* s, int c);

extern void test_movs(char *d, char *s, int c);

extern void test_loop_8s(char *d, char *s, int c);

extern void test_movs_8s(char *d, char *s, int c);

extern void test_opt(char *d, char *s, int c);

#define TEST_CASES 6
void (*testfs[TEST_CASES])(char*, char*, int) 
    = {&test_memcpy, &test_loop, &test_movs, &test_loop_8s, &test_movs_8s, &test_opt};

int main() {
    setup();

    struct timespec start, stop;

    for (int s = 0; s < SIZES_CASES; s++) {
        printf("%d ", SIZES[s]);
        for (int t = 0; t < TEST_CASES; t++) {
            int its = 100;
            void (*func)(char*, char*, int) = testfs[t];

            clock_gettime(CLOCK_REALTIME, &start);
            for (int i = 0; i < its; i++) func(DST[s], SRC[s], SIZES[s]);
            clock_gettime(CLOCK_REALTIME, &stop);
            double result = (stop.tv_sec - start.tv_sec) * 1e6 + (stop.tv_nsec - start.tv_nsec) / 1e3;

            printf("%f ", result);
        }
        printf("\n");
    }
}