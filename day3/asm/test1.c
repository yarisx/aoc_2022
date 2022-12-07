#include <stdlib.h>
#include <stdio.h>
#include <inttypes.h>
#include <string.h>

extern int check_line(char *, int);

int main(void)
{
    char buf[256] = {0};
    int32_t sum = 0;

    FILE *f = fopen("input.txt", "r");
    while(!feof(f))
    {
        char t;
        fgets(buf, 256, f);
        size_t sl = strlen(buf);
        if (buf[sl - 1] == '\n') buf[sl - 1] = '\0';
        sum += check_line(buf, (sl - 1) / 2);
        memset(buf, 0, 256);
    }
    printf("sum %d\n", sum);

    return 0;
}
