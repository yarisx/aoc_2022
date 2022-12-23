#include <iostream>
#include <fstream>
#include <string>
#include <utility>
#include <vector>

typedef struct {
    int32_t  offset;
    int32_t  last_pos;
} wrap_t;

typedef std::pair<int32_t, int32_t> point_t;
typedef std::vector<std::string> map_t;
typedef map_t::size_type lnsize_t;
typedef std::vector<wrap_t> limits_t;
typedef std::vector<int32_t> trace_t;

void step_y(const map_t& map, point_t& p, int step, const limits_t& lines);
void step_x(const map_t& map, point_t& p, int step, const limits_t& lines);
int32_t step_c(int32_t const_c, int32_t var_c, int step, const limits_t& lims);
void do_stuff(const map_t& map,const limits_t& cols, const limits_t& lines,
              const trace_t& trace);
void transpose(map_t& tmap, const map_t& map, limits_t& cols);
void read_trace(trace_t& trace);
lnsize_t read_file(map_t& map);
void find_lims(const map_t& map, limits_t& lims);
int32_t wrap_point(int32_t coord, const wrap_t& lim);
void move_point(const map_t& map, point_t& p,const  point_t& np);

#ifdef DEBUG
char prnf(int8_t f)
{
    switch(f)
    {
        case 0: return '>';
        case 1: return 'v';
        case 2: return '<';
        default: return '^';
    }
}
#endif

int main(void)
{
    limits_t    lines, cols;
    map_t       map;
    trace_t     trace;
    lnsize_t    linelen;;

    linelen = read_file(map);
    if (linelen == 0)
    {
        return -1;
    }

    find_lims(map, lines);

    {
        map_t tmap;
        transpose(tmap, map, cols);
        find_lims(tmap, cols);
    }

    read_trace(trace);

    do_stuff(map, cols, lines, trace);

    return 0;
}

void find_lims(const map_t& map, limits_t& lims)
{
    size_t off, len;
    for (auto str : map)
    {
        wrap_t tmp;

        off = str.find_first_not_of(' ');
        len = str.find_last_not_of(' ');
        tmp.offset = off;
        tmp.last_pos = len;
        lims.push_back(tmp);
    }
}

lnsize_t read_file(map_t& map)
{
    lnsize_t slen = 0;
    map_t tmap;
    std::string str;
    std::ifstream f("map.txt");

    if (!f.is_open())
    {
        std::cout<<"Failed to open map file"<<std::endl;
        return slen;
    }
    while (getline(f, str))
    {
        if (slen < str.size()) slen = str.size();
        tmap.push_back(str);
    }
    for (auto str : tmap)
    {
        size_t len = str.size();
        if (len < slen)
            str.append((slen - len), ' ');
        map.push_back(str);
    }
    return slen;
}

void read_trace(trace_t& trace)
{
    std::ifstream f("trace.txt");
    std::string str;
    std::string::size_type np, cp;
    int num;

    if (! getline(f, str))
    {
        std::cout<<"Failed to read trace"<<std::endl;
        return;
    }
    cp = 0;
    while (cp < str.size())
    {
        std::string tstr;
        np = str.find_first_of("LR", cp);
        if (np == cp)
        {
            if (str[np] == 'R')
            {
                trace.push_back(-1);
            }
            else
            {
                trace.push_back(-2);
            }
            cp++;
        }
        else
        {
            std::string::size_type sz;
            if (np == std::string::npos) sz = str.size() - cp;
            else sz = (np - cp);
            tstr = str.substr(cp, sz);
            num = std::stoi(tstr);
            trace.push_back(num);
            cp = np;
        }
    }
}

void transpose(map_t& tmap, const map_t& map, limits_t& cols)
{
    size_t off, len, map_len = map.size(), line_len = map[0].size();
    wrap_t tmp;

    for (map_t::size_type i = 0; i < line_len; i++)
    {
        std::string tstr;
        tstr.resize(map_len);
        for (std::string::size_type j = 0; j < map_len; j++)
        {
            tstr[j] = map[j][i];
        }
        tmap.push_back(tstr);
    }

#ifdef DEBUG
    for (auto i : tmap)
    {
        std::cout<<i<<std::endl;
    }
#endif
}

void do_stuff(const map_t& map,const limits_t& cols, const limits_t& lines,
              const trace_t& trace)
{
    size_t ti = lines[0].offset;
    point_t currpos(ti, 0);
    int8_t facing = 0;
    trace_t::const_iterator tracepos = trace.begin();

    while (tracepos != trace.end())
    {
        switch(*tracepos)
        {
            case -1: // right
                facing = facing + 1;
                if (facing > 3) facing = 0;
#ifdef DEBUG
                std::cout<<"f: "<<prnf(facing)<<", x: "<<currpos.first<<", y: "<<currpos.second<<std::endl;
#endif
            break;
            case -2: // left
                facing = facing - 1;
                if (facing < 0) facing = 3;
#ifdef DEBUG
                std::cout<<"f: "<<prnf(facing)<<", x: "<<currpos.first<<", y: "<<currpos.second<<std::endl;
#endif
            break;
            default:
            {
                int step;
                if (facing == 0 || facing == 2)
                {
                    if (facing == 0) step = 1;
                    else step = -1;
                }
                else
                {
                    if (facing == 1) step = 1;
                    else step = -1;
                }
                for (int i = 0; i < *tracepos; i++)
                {
                    if (! (facing % 2))
                    {
                        step_x(map, currpos, step, lines);
                    }
                    else
                    {
                        step_y(map, currpos, step, cols);
                    }
#ifdef DEBUG
                    std::cout<<"f: "<<prnf(facing)<<", x: "<<currpos.first<<", y: "<<currpos.second<<std::endl;
#endif
                }
            }
        }
        tracepos++;
    }
    currpos.first++; currpos.second++; // we are 0-based, the task is 1-based
    std::cout<<"Done: "<<1000 * currpos.second + 4 * currpos.first + facing<<std::endl;
}

void step_x(const map_t& map, point_t& p, int step, const limits_t& lines)
{
    point_t newp(p);

    newp.first = step_c(newp.second, newp.first, step, lines);
    move_point(map, p, newp);
}

void step_y(const map_t& map, point_t& p, int step, const limits_t& cols)
{
    point_t newp(p);

    newp.second = step_c(newp.first, newp.second, step, cols);
    move_point(map, p, newp);
}

int32_t step_c(int32_t const_c, int32_t var_c, int step, const limits_t& lims)
{
    int32_t tvar_c = var_c + step;
    wrap_t currlim = lims[const_c];

    tvar_c = wrap_point(tvar_c, currlim);
    return tvar_c;
}

void move_point(const map_t& map, point_t& p,const  point_t& np)
{
    if (map[np.second][np.first] != '#') p = np;
    return;
}

int32_t wrap_point(int32_t coord, const wrap_t& lim)
{
    if (coord > lim.last_pos) coord = lim.offset;
    if (coord < lim.offset) coord = lim.last_pos;
    return coord;
}
