#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

struct list_elem;

typedef struct list_elem {
    int32_t value;
    struct list_elem *next;
} list_elem_t;

int *count1(FILE *f)
{
    list_elem_t *ptr = NULL, *hd = NULL;
    int32_t sum = 0;
    size_t sz = 0;
    int32_t *res = NULL;
    int32_t i;

    while (!feof(f))
    {
        fscanf(f, "%"SCNd32, &i);
        if (i < 0)
        {
            ptr = calloc(1, sizeof(list_elem_t));
            ptr->value = sum;
            ptr->next = hd;
            hd = ptr;
            sz++;
            sum = 0;
        }
        else
        {
            sum += i;
        }
    }
    res = calloc(sz + 1, sizeof(int32_t));
    res[0] = sz;
    list_elem_t *s;
    for (s = hd, i = 1; s; s = s->next)
    {
        res[i++] = s->value;
    }
    return res;
}

int compar(void *a, void *b)
{
    int32_t ia = *(int32_t *)a, ib = *(int32_t *)b;
    return ia < ib ? -1 : (ia > ib ? 1 : 0);
}

int main(int argc, char **argv)
{
    FILE *f = fopen("input1.txt", "r");
    int32_t *lst = NULL;
    if (!f) return -1;

    lst = count1(f);
    int32_t sz = lst[0];
    qsort(lst + 1, sz, sizeof(int32_t), compar);
    if (argc > 1)
    {
        printf("%d\n", lst[sz] + lst[sz-1] + lst[sz-2]);
    }
    else
    {
        printf("%d\n", lst[sz]);
    }
    return 0;
}
