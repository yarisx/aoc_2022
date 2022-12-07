#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

extern int list_sum(int *, size_t);
extern int total_sum(int*, size_t, int *, size_t);

int cmp(void *a, void *b)
{
    int32_t ia = *((int32_t *)a);
    int32_t ib = *((int32_t *)b);
    return a > b ? -1 : (a < b ? 1 : 0);
}

int main(void)
{
    int32_t *arr = calloc(2241, sizeof(int32_t));
    int32_t *res = calloc(245, sizeof(int32_t));
    FILE *f = fopen("input1.txt.msg", "r");
    size_t  i = 0;
    while(!feof(f))
    {
        fscanf(f, "%"SCNd32, &arr[i++]);
    }
    if (i > 2242)
    {
        printf("Smth is off: %d\n", i);
        return -1;
    }
    total_sum(arr, 2241, res, 245);

    qsort(res, 245, sizeof(int32_t), cmp);
    printf("sum is %d\n", res[0]);
    return 0;
}
