#include <stdio.h>
#include <inttypes.h>

#define LINES   240 // I cheated and used wc -l

extern int elvproc2(int8_t *, size_t, int8_t *);

int main(void)
{
    FILE *f = fopen("input.txt", "r");
    int8_t  ops[LINES] = {0};
    int8_t  res[LINES] = {0};
    size_t  i = 0;

    while (!feof(f))
    {
        fscanf(f, "%"SCNd8"\n", &ops[i++]);
    }

    elvproc2(ops, i, res);
    for (int j = 0; j < 6; j++)
    {
        for (int k = 0; k < i/6; k++)
        {
            if (res[40 * j + k] == 1)
                printf("•");
            else
                printf(" ");
        }
        printf(" <\n");
    }

    return 0;
}
