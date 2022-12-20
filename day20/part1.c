#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>

#define container_of(ptr, type, member) ((type *)((char *)(1 ? (ptr) : &((type *)0)->member) - offsetof(type, member)))

#define MULTIPLIER  811589153

struct llnode;

typedef struct llnode {
    struct llnode *prev;
    struct llnode *next;
} llnode_t;

typedef struct {
    llnode_t order;
    llnode_t place;
    int64_t true_val;
    int64_t val;
} num_t;

void move_val(llnode_t *);
void swap(llnode_t *, llnode_t *);

int main(void)
{
    num_t *pend = calloc(1, sizeof(num_t));
    num_t *pstart = pend, *ntmp, *pzero;
    int64_t tmp, sum = 0;
    FILE *f = fopen("input.txt", "r");

    while (!feof(f))
    {
        if(1 > fscanf(f, "%lld\n", &tmp))
        {
            fprintf(stderr, "Failed to read the number\n");
            return -1;
        }
#ifdef PART2
        pend->val = (tmp * MULTIPLIER) % 4999;
        pend->true_val = tmp * MULTIPLIER;
#else
        pend->val = tmp;
        pend->true_val = tmp;
#endif
        if (0 == pend->val) pzero = pend;

        ntmp = calloc(1, sizeof(num_t));
        pend->order.next = &ntmp->order;
        pend->order.next->prev = &pend->order;

        pend->place.next = &ntmp->place;
        pend->place.next->prev = &pend->place;
        pend = container_of(pend->order.next, num_t, order);
    }

    pend->place.prev->next = &pstart->place;
    pstart->place.prev = pend->place.prev;

#ifdef PART2
    for (int i = 0; i < 10; i++)
#endif
    for (llnode_t *op = &pstart->order; op; op = op->next)
    {
        move_val(op);
    }
#ifdef DEBUG_PRN
    pstart->place.prev->next = NULL;    // break the endless loop
    for (llnode_t *op = &pstart->place; op; op = op->next)
    {
        num_t *tmp = container_of(op, num_t, place);
        printf("node addr: %p, place addr %p, op %p, val %lld, true_val %lld\n",
               tmp, &tmp->place, op, tmp->val, tmp->true_val);
    }
#endif
    tmp = 0;
    for (llnode_t *op = &pzero->place; (tmp <= 3000) && op; op = op->next)
    {
        if (tmp == 1000 || tmp == 2000 || tmp == 3000)
        {
            num_t *ptmp = container_of(op, num_t, place);
            sum += ptmp->true_val;
        }
        tmp++;
    }
    printf("Sum is %lld\n", sum);
    return 0;
}

void move_val(llnode_t *on)
{
    num_t *nump = container_of(on, num_t, order);
    llnode_t *place = &nump->place;
    int v = nump->val;
    int step = v < 0 ? -1 : (v > 0 ? 1 : 0);

    if (step == 0) return;

    for (int i = 0; i < (v * step); i++)
    {
        if (step < 0)
        {
            swap(place->prev, place);
        }
        else
        {
            swap(place, place->next);
        }
    }
}

/*
 * -> p -> l -> r -> n
 * <- p <- l <- r <- n
 *       to
 * -> p -> r -> l -> n
 * <- p <- r <- l <- n
 */
void swap(llnode_t *l, llnode_t *r)
{
    llnode_t *p = l->prev;
    llnode_t *n = r->next;

    p->next = r;
    r->prev = p;
    r->next = l;
    l->prev = r;
    l->next = n;
    n->prev = l;
}
