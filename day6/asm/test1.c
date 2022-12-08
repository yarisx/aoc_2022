#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <errno.h>
#include <string.h>

extern int sop_mark(char *, int);

int main(void)
{
    struct stat fst = {0,};
    char *pinput = NULL;
    int fi = 0, res = 0;
    long pgs = sysconf(_SC_PAGE_SIZE);
    int mmap_sz = 0;

    if (stat("../input.txt", &fst) < 0)
    {
        fprintf(stderr, "Could not get the input size\n");
        return -1;
    }
    mmap_sz = ((fst.st_size / pgs) + 1) * pgs;
    fi = open("../input.txt", O_RDONLY);
    pinput = mmap(0, mmap_sz, PROT_READ, MAP_PRIVATE, fi, 0);
    if (MAP_FAILED == pinput)
    {
        fprintf(stderr, "Could not allocate memory for the input: %s\n", strerror(errno));
        return -1;
    }
    res = sop_mark(pinput, fst.st_size);
    printf("Result is %d\n", res);
    return 0;
}
