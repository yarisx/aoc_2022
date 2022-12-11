#include <stdio.h>
#include <inttypes.h>

#define LINES   240 // I cheated and used wc -l

extern int elvproc(int8_t *, size_t, int32_t *, size_t);

int main(void)
{
    FILE *f = fopen("input.txt", "r");
    int8_t  ops[LINES] = {0};
    int32_t res[LINES/20] = {0}, sum = 0;
    size_t  i = 0, res_size = LINES/20;

    while (!feof(f))
    {
        fscanf(f, "%"SCNd8"\n", &ops[i++]);
    }

    sum = elvproc(ops, i, res, res_size);
    printf("Sum of %lu lines is is %"PRId32"\n", i, sum);

    return 0;
}
