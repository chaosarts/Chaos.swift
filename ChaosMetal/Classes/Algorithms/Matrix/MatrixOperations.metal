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
                             device const int& matrix_width [[ buffer(1) ]],
                             device const int& matrix_height [[ buffer(2) ]],
                             device float* output_matrix [[ buffer(3) ]],
                             threadgroup float* local_matrix [[ threadgroup(0) ]],
                             uint2 group_position [[ threadgroup_position_in_grid ]],
                             uint2 group_size [[ threads_per_threadgroup ]],
                             uint2 thread_position_in_group [[ thread_position_in_threadgroup ]]) {
    int x = group_position.x * group_size.x + thread_position_in_group.x;
    int y = group_position.y * group_size.x;

    if (x < matrix_width) {
        for (int dy = 0; dy < (int) group_size.x; dy++) {
            if (y + dy < matrix_height) {
                local_matrix[dy * group_size.x + thread_position_in_group.x] =  input_matrix[(y + dy) * matrix_width + x];
            } else {
                local_matrix[dy * group_size.x + thread_position_in_group.x] = 0;
            }
        }
    }

    threadgroup_barrier(mem_flags::mem_threadgroup);

    x = group_position.y * group_size.x + thread_position_in_group.x;
    y = group_position.x * group_size.x;

    if (x < matrix_width) {
        for (int dy = 0; dy < (int) group_size.x; dy++) {
            if (y + dy < (int) matrix_height) {
                output_matrix[(y + dy) * matrix_width + x] = local_matrix[thread_position_in_group.x * group_size.x + dy];
            }
        }
    }
}
