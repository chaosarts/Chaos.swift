//
//  PrefixSum.metal
//  Pods
//
//  Created by Fu Lam Diep on 17.12.21.
//

#include <metal_stdlib>
#include <metal_compute>
using namespace metal;

kernel void prefix_sum(device const float* input [[ buffer(0) ]],
                       device const int& width [[ buffer(1) ]],
                       device const int& height [[ buffer(2) ]],
                       device float* output [[ buffer(4) ]],
                       device float* nextInput [[ buffer(5) ]],
                       threadgroup float* local [[ threadgroup(0) ]],
                       const uint2 group_position [[ threadgroup_position_in_grid ]],
                       const uint2 group_size [[ threads_per_threadgroup ]],
                       const uint2 thread_position_in_group [[ thread_position_in_threadgroup ]]) {

    // Read submatrix in to local

    uint2 input_position;
    input_position.x = (uint) 2 * group_position.x * group_size.x + thread_position_in_group.x;
    input_position.y = (uint) group_position.y * width + thread_position_in_group.y;

    if (input_position.x < (uint) width) {
        local[thread_position_in_group.x] = input[input_position.x + input_position.y * width];
    } else {
        local[thread_position_in_group.x] = 0;
    }

    if (input_position.x + group_size.x < (uint) width) {
        local[thread_position_in_group.x + group_size.x] = input[input_position.x + input_position.y * width + group_size.x];
    } else {
        local[thread_position_in_group.x + group_size.x] = 0;
    }

    threadgroup_barrier(mem_flags::mem_threadgroup);

    // Up Sweep

    const int N = (int) ceil(log2((float) group_size.x * 2));
    const int local_thread_position = thread_position_in_group.x * 2;
    for (int n = 0; n < N; n++) {
        const int stride = 1 << n;
        if (local_thread_position - stride > 0 && local_thread_position % stride == 0) {
            local[local_thread_position + 1] += local[local_thread_position + 1 - stride];
        }
        threadgroup_barrier(mem_flags::mem_threadgroup);
    }

    if (thread_position_in_group.x == 0) {
        local[group_size.x * 2 - 1] = 0;
    }

    // Down Sweep

    for (int n = N - 1; n >= 0; n--) {
        const int stride = 1 << n;
        if (local_thread_position - stride > 0 && local_thread_position % stride == 0) {
            const float swap = local[local_thread_position + 1];
            local[local_thread_position + 1] += local[local_thread_position + 1 - stride];
            local[local_thread_position + 1 - stride] = swap;
        }
        threadgroup_barrier(mem_flags::mem_threadgroup);
    }

    if (input_position.x < (uint) width) {
         output[input_position.x + input_position.y * width] = local[thread_position_in_group.x];
    }

    if (input_position.x + group_size.x < (uint) width) {
        output[input_position.x + input_position.y * width + group_size.x] = local[thread_position_in_group.x + group_size.x];
    }

    if (thread_position_in_group.x == 0) {
        nextInput[group_position.x] = local[group_size.x * 2 - 1];
    }
}
