//
//  Vertex.swift
//  DepthTest
//
//  Created by GH on 1/5/26.
//

import simd

struct Vertex {
    let position: SIMD3<Float>
    let color: SIMD4<Float>
}

let vertices: [Vertex] = [
    // 前面
    Vertex(position: SIMD3<Float>( 0.5,  0.5,  0.5), color: SIMD4<Float>(1.0, 0.0, 0.0, 1.0)),
    Vertex(position: SIMD3<Float>(-0.5,  0.5,  0.5), color: SIMD4<Float>(1.0, 0.0, 0.0, 1.0)),
    Vertex(position: SIMD3<Float>(-0.5, -0.5,  0.5), color: SIMD4<Float>(1.0, 0.0, 0.0, 1.0)),
    Vertex(position: SIMD3<Float>( 0.5, -0.5,  0.5), color: SIMD4<Float>(1.0, 0.0, 0.0, 1.0)),
    
    // 后面
    Vertex(position: SIMD3<Float>( 0.5,  0.5, -0.5), color: SIMD4<Float>(0.0, 1.0, 0.0, 1.0)),
    Vertex(position: SIMD3<Float>(-0.5,  0.5, -0.5), color: SIMD4<Float>(0.0, 1.0, 0.0, 1.0)),
    Vertex(position: SIMD3<Float>(-0.5, -0.5, -0.5), color: SIMD4<Float>(0.0, 1.0, 0.0, 1.0)),
    Vertex(position: SIMD3<Float>( 0.5, -0.5, -0.5), color: SIMD4<Float>(0.0, 1.0, 0.0, 1.0)),
    
    // 左面
    Vertex(position: SIMD3<Float>(-0.5,  0.5,  0.5), color: SIMD4<Float>(0.0, 0.0, 1.0, 1.0)),
    Vertex(position: SIMD3<Float>(-0.5,  0.5, -0.5), color: SIMD4<Float>(0.0, 0.0, 1.0, 1.0)),
    Vertex(position: SIMD3<Float>(-0.5, -0.5, -0.5), color: SIMD4<Float>(0.0, 0.0, 1.0, 1.0)),
    Vertex(position: SIMD3<Float>(-0.5, -0.5,  0.5), color: SIMD4<Float>(0.0, 0.0, 1.0, 1.0)),
    
    // 右面
    Vertex(position: SIMD3<Float>( 0.5,  0.5,  0.5), color: SIMD4<Float>(1.0, 1.0, 0.0, 1.0)),
    Vertex(position: SIMD3<Float>( 0.5,  0.5, -0.5), color: SIMD4<Float>(1.0, 1.0, 0.0, 1.0)),
    Vertex(position: SIMD3<Float>( 0.5, -0.5, -0.5), color: SIMD4<Float>(1.0, 1.0, 0.0, 1.0)),
    Vertex(position: SIMD3<Float>( 0.5, -0.5,  0.5), color: SIMD4<Float>(1.0, 1.0, 0.0, 1.0)),
    
    // 顶面
    Vertex(position: SIMD3<Float>( 0.5,  0.5,  0.5), color: SIMD4<Float>(1.0, 0.0, 1.0, 1.0)),
    Vertex(position: SIMD3<Float>(-0.5,  0.5,  0.5), color: SIMD4<Float>(1.0, 0.0, 1.0, 1.0)),
    Vertex(position: SIMD3<Float>(-0.5,  0.5, -0.5), color: SIMD4<Float>(1.0, 0.0, 1.0, 1.0)),
    Vertex(position: SIMD3<Float>( 0.5,  0.5, -0.5), color: SIMD4<Float>(1.0, 0.0, 1.0, 1.0)),
    
    // 底面
    Vertex(position: SIMD3<Float>( 0.5, -0.5,  0.5), color: SIMD4<Float>(0.0, 1.0, 1.0, 1.0)),
    Vertex(position: SIMD3<Float>(-0.5, -0.5,  0.5), color: SIMD4<Float>(0.0, 1.0, 1.0, 1.0)),
    Vertex(position: SIMD3<Float>(-0.5, -0.5, -0.5), color: SIMD4<Float>(0.0, 1.0, 1.0, 1.0)),
    Vertex(position: SIMD3<Float>( 0.5, -0.5, -0.5), color: SIMD4<Float>(0.0, 1.0, 1.0, 1.0)),
]

// 正方体索引数组，每6个顶点定义一个面（两个三角形）
let indices: [UInt32] = [
    // 前面
    0, 1, 2,  0, 2, 3,
    // 后面
    4, 5, 6,  4, 6, 7,
    // 左面
    8, 9, 10,  8, 10, 11,
    // 右面
    12, 13, 14, 12, 14, 15,
    // 顶面
    16, 17, 18, 16, 18, 19,
    // 底面
    20, 21, 22, 20, 22, 23
]
