// PowerRouting for OMNeT++ - Batman ring_buffer
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, ring_buffer.cc


#include "../BatmanMain.h"

void Batman::ring_buffer_set(std::vector<uint8_t> &tq_recv, uint8_t &tq_index, uint8_t value)
{
    tq_recv[tq_index] = value;
    tq_index = (tq_index + 1) % global_win_size;
}

uint8_t Batman::ring_buffer_avg(std::vector<uint8_t> &tq_recv)
{
    uint16_t count = 0;
    uint32_t sum = 0;

    for (auto & elem : tq_recv) {
        if (elem != 0) {
            count++;
            sum += elem;
        }
    }

    if (count == 0)
        return 0;

    return (uint8_t)(sum / count);
}


