//
//  Shaders.metal
//  DepthTest
//
//  Created by GH on 1/5/26.
//

#import "Common.h"

// 顶点缓冲区(vertex buffer)传入顶点着色器所用的数据结构
struct VertexIn {
    // float3 position 对应 Swift 中 SIMD3，表示顶点的坐标 xyz
    // [[attribute(0)]] 表示让 Metal 从顶点缓冲区中的第 0 个属性提取数据（通常是位置）作为 position 值
    float3 position [[attribute(0)]];
    
    // float4 color 的四个值是 rgba 颜色，同样 [[attribute(1)]] 表示从用顶点缓冲区的第 1 个属性作为 color
    float4 color [[attribute(1)]];
};

// 顶点着色器根据传入数据 VertexIn 进行一系列改动后，将输出数据打包成 VertexOut
struct VertexOut {
    // 根据 VertexIn 的 position 进行坐标转换，变成 屏幕坐标 后传递给下一阶段
    float4 position [[position]];
    // VertexIn 传入的 color，多数情况为原封不动传递给下一个阶段，但具体如何实现还是看顶点着色器
    float4 color;
};

// vertex: - Metal 修饰符，用于表示该函数为顶点着色器
// VertexOut: - 函数返回值
// vertex_main: - 函数名
// VertexIn in [[stage_in]]: - 输入参数，顶点数据
// constant Uniforms &uniforms [[buffer(1)]]: - uniform 传进来的变换矩阵
vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                             // constant: - 表示 uniform 是只读的，通常视图矩阵由 CPU 计算，所以不需要修改，所以防止意外改动，将其设置为只读
                             // Uniforms: - 表示会解析成这个数据结构
                             // &uniforms: - 表示会引用缓冲区的数据源作为 uniforms，而不会创建一个新的实例
                             // [[buffer(1)]]: - 表示数据源来自传递来的 Buffer 1，根据 setVertexBuffer 的 index 来定
                             constant Uniforms &uniforms [[buffer(1)]])
{
    VertexOut out;
    
    // 使用 MVP 矩阵进行坐标变换
    out.position = uniforms.mvpMatrix * float4(in.position, 1.0);
    
    // 直接传递顶点颜色
    out.color = in.color;
    
    return out;
}

// 片元着色器函数
// fragment: - Metal 修饰符，用于表示该函数为片元着色器
// float4: - 函数返回值，表示 RGBA 颜色值
// fragment_main: - 函数名
// VertexOut in: - 输入参数，传入顶点着色器输出的结构体 VertexOut
fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    return in.color;  // 直接返回从顶点着色器传递过来的颜色值
    // 这里只是把顶点着色器的颜色数据，显示在屏幕上
}
