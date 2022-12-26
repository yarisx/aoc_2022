#include <iostream>
#include <fstream>
#include <vector>
#include <map>
#include <utility>

enum dir_t { north, south, west, east };

typedef std::pair<int32_t, int32_t> point_t;

typedef struct {
    int16_t x, y;       // current position
    int16_t px, py;     // proposed pos
    dir_t select_dir;   // 1 byte per dir, 0 - north, 1 south, 2 west 3 east, [0] the one to start with
} elf_cons_t;

typedef std::shared_ptr<elf_cons_t> elf_cons_p;

struct PtCmp {
    bool operator()(const point_t& l, const point_t& r) const
    {
        if (l.first < r.first) return true;
        else return l.second < r.second;
    }
};

//typedef std::map<point_t, elf_cons_p, PtCmp> elf_map_t;
typedef std::map<point_t, elf_cons_p> elf_map_t;

void read_file(elf_map_t& el);
void do_round(elf_map_t& el);
void do_first_half(elf_map_t& el);
void do_second_half(elf_map_t& em);
void propose(elf_cons_p& elf_ptr, uint64_t neighs);
bool is_neigh(dir_t dir, uint64_t neighs);
void move_point(dir_t dir, elf_cons_p& elf_ptr);
uint64_t check_dir(const elf_cons_p& elf_ptr, const elf_map_t& em);
void find_min_max(const elf_map_t &em, point_t& min, point_t& max);
void print_elves(const elf_map_t& em);
dir_t next_dir(dir_t curr);

int main(void)
{
    elf_map_t elf_map;
    point_t mins, maxs;

    read_file(elf_map);

    print_elves(elf_map);

    for (int i = 0; i < 10; i++)
    {
        do_round(elf_map);
    }
    find_min_max(elf_map, mins, maxs);
    std::cout<<"Plants: "<<(maxs.first - mins.first + 1)*(maxs.second - mins.second + 1) - elf_map.size()<<std::endl;
    return 0;
}

void read_file(elf_map_t& el)
{
    std::ifstream f("input.txt");
    std::string tstr;
    elf_map_t::size_type elf_cnt = 0;
    int ln = 0;
    std::shared_ptr<elf_cons_t> elf_p;

    while (getline(f, tstr))
    {
        for (int i = 0; i < tstr.size(); i++)
        {
            if (tstr[i] == '#')
            {
                elf_p = std::make_shared<elf_cons_t>();
                elf_p->x = i; elf_p->y = ln;
                elf_p->select_dir = north;
                el.insert(std::pair<point_t, elf_cons_p>(point_t{elf_p->x, elf_p->y}, elf_p));
            }
        }
        ln++;
    }
}

void find_min_max(const elf_map_t &em, point_t& min, point_t& max)
{
    elf_map_t::const_iterator ei = em.begin();
    int32_t minx = ei->second->x, maxx = ei->second->x;
    int32_t miny = ei->second->y, maxy = ei->second->y;

    for (auto elf_pair: em)
    {
        int32_t cx = (elf_pair.second)->x;
        int32_t cy = (elf_pair.second)->y;
        if (cx < minx) minx = cx;
        if (cy < miny) miny = cy;
        if (cx > maxx) maxx = cx;
        if (cy > maxy) maxy = cy;
    }
    min.first = minx; min.second = miny;
    max.first = maxx; max.second = maxy;
}

void print_elves(const elf_map_t& em)
{
    point_t mins, maxs;

    find_min_max(em, mins, maxs);

    std::cout<<std::endl;
    for (int j = mins.second; j <= maxs.second; j++)
    {
        for (int i = mins.first; i <= maxs.first; i++)
        {
            if (em.count(point_t{i,j}) > 0)
            {
                std::cout<<"#";
            }
            else
            {
                std::cout<<".";
            }
        }
        std::cout<<std::endl;
    }
    std::cout<<std::endl;
}

void do_round(elf_map_t& el)
{
    do_first_half(el);
    print_elves(el);
    do_second_half(el);
}

void do_first_half(elf_map_t& el)
{
    uint64_t neighs; // 0 1 2
                     // 3 x 4
                     // 5 6 7
    for (auto elf_ptr : el)
    {
        neighs = check_dir(elf_ptr.second, el);
        propose(elf_ptr.second, neighs);
    }
}

void do_second_half(elf_map_t& em)
{
    //std::multimap<point_t, elf_cons_p, PtCmp> pem;
    std::multimap<point_t, elf_cons_p> pem;
    for (auto elf_pair : em)
    {
        elf_cons_p tep = elf_pair.second;
        pem.insert(std::pair<point_t, elf_cons_p>(point_t{elf_pair.second->px, elf_pair.second->py}, tep));
        tep->select_dir = next_dir(tep->select_dir);
    }
    for (auto elf_ptr = pem.begin(); elf_ptr != pem.end(); elf_ptr++)
    {
        if (pem.count(elf_ptr->first) == 1)
        {
            elf_cons_p tep = elf_ptr->second;
            em.erase(point_t{elf_ptr->second->x, elf_ptr->second->y});
            elf_ptr->second->x = elf_ptr->second->px; elf_ptr->second->y = elf_ptr->second->py;
            em.insert(std::pair<point_t, elf_cons_p>(point_t{elf_ptr->second->x, elf_ptr->second->y}, tep));
        }
    }
}

void propose(elf_cons_p& elf_ptr, uint64_t neighs)
{
    dir_t curr_dir = elf_ptr->select_dir;
    if (!neighs)
    {
        elf_ptr->px = elf_ptr->x;
        elf_ptr->py = elf_ptr->y;
        return;
    }

    for (int i = 0; i < 4; i++)
    {
        if (!is_neigh(curr_dir, neighs))
        {
            move_point(curr_dir, elf_ptr);
            return;
        }
        else
        {
            curr_dir = next_dir(curr_dir);
        }
    }
}

bool is_neigh(dir_t dir, uint64_t neighs)
{
    switch(dir)
    {
        case north:
            return (neighs & (0xffUL | 0xffUL << 8 | 0xffUL << 16)) > 0;
        case south:
            return (neighs & (0xffUL << 40 | 0xffUL << 48 | 0xffUL << 56)) > 0;
        case west:
            return (neighs & (0xffUL | 0xffUL << 24 | 0xffUL << 40)) > 0;
        case east:
            return (neighs & (0xffUL << 16 | 0xffUL << 32 | 0xffUL << 56)) > 0;
    }
}

void move_point(dir_t dir, elf_cons_p& elf_ptr)
{
    elf_ptr->px = elf_ptr->x;
    elf_ptr->py = elf_ptr->y;
    switch(dir)
    {
        case north:
            elf_ptr->py = elf_ptr->y - 1;
        break;
        case south:
            elf_ptr->py = elf_ptr->y + 1;
        break;
        case west:
            elf_ptr->px = elf_ptr->x - 1;
        break;
        case east:
            elf_ptr->px = elf_ptr->x + 1;
        break;
    }
}

uint64_t check_dir(const elf_cons_p& elf_ptr, const elf_map_t& em)
{
    point_t ptmp;
    uint64_t neighs = 0;

    ptmp.second = elf_ptr->y - 1;
    ptmp.first = elf_ptr->x - 1;
    if (em.count(ptmp) > 0)
    {
        neighs |= 0x01UL;
    }
    ptmp.first = elf_ptr->x;
    if (em.count(ptmp) > 0)
    {
        neighs |= 0x01UL << 8;
    }
    ptmp.first = elf_ptr->x + 1;
    if (em.count(ptmp) > 0)
    {
        neighs |= 0x01UL << 16;
    }

    ptmp.second = elf_ptr->y;
    ptmp.first = elf_ptr->x - 1;
    if (em.count(ptmp) > 0)
    {
        neighs |= 0x01UL << 24;
    }
    ptmp.first = elf_ptr->x + 1;
    if (em.count(ptmp) > 0)
    {
        neighs |= 0x01UL << 32;
    }
    ptmp.second = elf_ptr->y + 1;
    ptmp.first = elf_ptr->x - 1;

    if (em.count(ptmp) > 0)
    {
        neighs |= 0x01UL << 40;
    }
    ptmp.first = elf_ptr->x;
    if (em.count(ptmp) > 0)
    {
        neighs |= 0x01UL << 48;
    }
    ptmp.first = elf_ptr->x + 1;
    if (em.count(ptmp) > 0)
    {
        neighs |= 0x01UL << 56;
    }
    return neighs;
}

dir_t next_dir(dir_t curr)
{
    switch(curr)
    {
        case north: return south;
        case south: return west;
        case west: return east;
        case east: return north;
    }
}
