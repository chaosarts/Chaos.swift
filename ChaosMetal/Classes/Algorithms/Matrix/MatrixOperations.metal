//
//  MatrixOperations.metal
//  Pods
//
//  Created by Fu Lam Diep on 10.12.21.
//

#include <metal_stdlib>
#include <metal_compute>
using namespace metal;

kernel void matrix_transpose(device const float* input_matrix [[ buffer(0) ]],
                             device const uint2& matrix_dim [[ buffer(1) ]],
                             device const uint& tile_size [[ buffer(2) ]],
                             device float* output_matrix [[ buffer(3) ]],
                             threadgroup float* local_matrix [[ threadgroup(0) ]],
                             uint2 grid_size [[ grid_size ]],
                             uint2 group_position [[ threadgroup_position_in_grid ]],
                             uint2 group_size [[ threads_per_threadgroup ]],
                             uint2 thread_position_in_group [[ thread_position_in_threadgroup ]]) {
    const uint x = group_position.x * tile_size + thread_position_in_group.x;
    const uint y = group_position.y * tile_size;

    for (uint dy = 0; dy < tile_size; dy++) {
        if (y + dy < matrix_dim.y && x < matrix_dim.x) {
            local_matrix[dy * tile_size + thread_position_in_group.x] =  input_matrix[(y + dy) * matrix_dim.x + x];
        }
    }

    threadgroup_barrier(mem_flags::mem_threadgroup);

    for (uint dy = 0; dy < tile_size; dy++) {
        if (y + dy < matrix_dim.y && x < matrix_dim.x) {
            output_matrix[(y + dy) * matrix_dim.x + x] = local_matrix[thread_position_in_group.x * tile_size + dy];
        }
    }
}
