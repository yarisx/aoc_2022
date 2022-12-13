#include <utility>
#include <queue>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <unistd.h>
#include <fcntl.h>

#define NOPATH   35
#define INF_DIST 0x0fffffff

typedef std::pair<int, int> nonvisited;

struct CompareNonvisited
{
    bool operator()(std::pair<int, int>& v1, std::pair<int, int>& v2)
    {
        return v1.first > v2.first;
    }
};

size_t nodes_num()
{
    struct stat st = {0};
    if (stat("input.txt", &st) < 0)
    {
        fprintf(stderr, "Failed to check the input: %s\n", strerror(errno));
        return -1;
    }
    return st.st_size;
}

bool reachable(int8_t n)
{
    return (n != '*' && n != '\n');
}

bool jump(int8_t s, int8_t e)
{
    if (s == 'S') return (e > 'b');
    if (e == 'E') return (s < 'y');
    return e > (s + 1);
}

bool connected(int8_t s, int8_t d)
{
    if (d == 'E') return connected(s, 'z');
    if (s == 'S') return connected('a', d);
    return reachable(s) && reachable(d) && (d <= (s + 1));
}

int main(void)
{
    int8_t *in_nodes = NULL;
    std::vector<uint64_t> connect;
    std::vector<int32_t> distances;
    std::vector<uint8_t> visited;
    std::vector<int32_t> prev;
    size_t  count = 0, strln = 0;
    size_t start = 0, end = 0;
    int    ifd;
    std::priority_queue<nonvisited, std::vector<nonvisited>, CompareNonvisited > Q;

    count = nodes_num();

    ifd = open("input.txt", O_RDONLY);
    in_nodes = static_cast<int8_t *>(mmap(0, count, PROT_READ, MAP_PRIVATE | MAP_FILE, ifd, 0));
    if (NULL == in_nodes)
    {
        fprintf(stderr, "Failed to read input: %s\n", strerror(errno));
        return -1;
    }

    connect.resize(count, 0);
    distances.resize(count);
    prev.resize(count, -1);
    visited.resize(count, 1);

    // Here we rely on the insight about our data, since in_nodes is NOT 0-terminated
    {
        int8_t *tmp = static_cast<int8_t *>(memchr(in_nodes, '\n', count));
        if (NULL == tmp)
        {
            fprintf(stderr, "Something is wrong with strings\n");
            return -1;
        }
        strln = tmp - in_nodes + 1;
        tmp = static_cast<int8_t *>(memchr(in_nodes, 'S', count));
        start = tmp - in_nodes;
        std::cout<<"Start is at "<<start<<std::endl;
        tmp = static_cast<int8_t *>(memchr(in_nodes, 'E', count));
        end = tmp - in_nodes;
        std::cout<<"End is at "<<end<<std::endl;
    }
    std::cout<<"Strlen is "<<strln<<std::endl;

    // Create connectivity matrix
    // here the real data is 1-based
    for (size_t i = strln + 1; i < (count - strln); i++)
    {
        uint32_t conn = 0;
        size_t upper = i - strln;
        size_t left = i - 1, right = i + 1;
        size_t lower = i + strln;

        if (!reachable(in_nodes[upper]) || jump(in_nodes[upper], in_nodes[i])) conn |= (NOPATH << 0);
        if (!reachable(in_nodes[left])  || jump(in_nodes[left], in_nodes[i])) conn |= (NOPATH << 8);
        if (!reachable(in_nodes[right]) || jump(in_nodes[right], in_nodes[i])) conn |= (NOPATH << 16);
        if (!reachable(in_nodes[lower]) || jump(in_nodes[lower], in_nodes[i])) conn |= (NOPATH << 24);
        connect[i] = conn;
        if ((i % strln) > 0 && (i % strln) < (strln - 1))
            visited[i] = 0;
    }

    visited[start] = 1;
    prev[start] = start;
    for (size_t i = 0; i < count; i++)
    {
        distances[i] = INF_DIST;
    }
    distances[start] = 0;
    if (connected(in_nodes[start], in_nodes[start - strln]))
    {
        distances[start - strln] = 1;
        prev[start - strln] = start;
    }
    if (connected(in_nodes[start], in_nodes[start + strln]))
    {
        distances[start + strln] = 1;
        prev[start + strln] = start;
    }
    if (connected(in_nodes[start], in_nodes[start - 1]))
    {
        distances[start - 1] = 1;
        prev[start - 1] = start;
    }
    if (connected(in_nodes[start], in_nodes[start + 1]))
    {
        distances[start + 1] = 1;
        prev[start + 1] = start;
    }

    for (size_t i = 0; i < count; i++)
        if (i != start && !visited[i])
            Q.push(nonvisited(distances[i], i));

    while(! Q.empty())
    {
        // u is from Q (unvisited) with min dist[u]
        nonvisited uv = Q.top();
        Q.pop();
        size_t u = uv.second;
        int32_t dist = 0, curr_dist = distances[u];
        size_t upper = u - strln;
        size_t left = u - 1, right = u + 1;
        size_t lower = u + strln;

        if (connected(in_nodes[u], in_nodes[upper]) && !visited[upper]) // connected to the upper neighbour
        {
            dist = curr_dist + 1;
            if (dist < distances[upper])
            {
                distances[upper] = dist;
                prev[upper] = u;
                Q.push(nonvisited(dist,upper));
            }
        }
        if (connected(in_nodes[u], in_nodes[left]) && !visited[left]) // connected to the left neighbour
        {
            dist = curr_dist + 1;
            if (dist < distances[left])
            {
                distances[left] = dist;
                prev[left] = u;
                Q.push(nonvisited(dist,left));
            }
        }
        if (connected(in_nodes[u], in_nodes[right]) && !visited[right]) // connected to the right neighbour
        {
            dist = curr_dist + 1;
            if (dist < distances[right])
            {
                distances[right] = dist;
                prev[right] = u;
                Q.push(nonvisited(dist,right));
            }
        }
        if (connected(in_nodes[u], in_nodes[lower]) && !visited[lower]) // connected to the lower neighbour
        {
            dist = curr_dist + 1;
            if (dist < distances[lower])
            {
                distances[lower] = dist;
                prev[lower] = u;
                Q.push(nonvisited(dist,lower));
            }
        }
        visited[u] = 1;
    }

    {
        size_t idx = end;
        size_t path_counter = 0;
        while (idx != start && idx != -1)
        {
            std::cout<<idx<<" ";
            idx = prev[idx];
            path_counter++;
        }
        std::cout<<std::endl;
        std::cout<<"Path length: "<<path_counter<<std::endl;
    }
    return 0;
}
