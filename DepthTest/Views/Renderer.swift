//
//  Renderer.swift
//  DepthTest
//
//  Created by GH on 1/5/26.
//

import SwiftUI
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    let device: MTLDevice                       // GPU 设备
    
    // MARK: - Command Queue
    let commandQueue: MTL4CommandQueue          // 命令队列
    let commandBuffer: MTL4CommandBuffer        // Metal 命令 Buffer
    let commandAllocator: MTL4CommandAllocator  // 命令分配器
    
    // MARK: - Buffers
    let vertexBuffer: MTLBuffer                 // 顶点缓冲区
    let indexBuffer: MTLBuffer                  // 索引缓冲区
    var uniformsBuffer: MTLBuffer               // Uniforms 缓冲区
    
    
    // MARK: - State
    let pipelineState: MTLRenderPipelineState   // 渲染管线状态
    let argumentTable: MTL4ArgumentTable        // 参数表
    let depthState: MTLDepthStencilState        // 深度测试状态
    
    
    let camera = Camera(
        position: SIMD3<Float>(2, 2, 3),
        target: SIMD3<Float>(0, 0, 0),
        up: SIMD3<Float>(0, 1, 0)
    )
    
    init(device: MTLDevice) throws {
        self.device = device
        
        // MARK: - 配置命令队列 Command Queue
        self.commandQueue = device.makeMTL4CommandQueue()!
        self.commandBuffer = device.makeCommandBuffer()!
        self.commandAllocator = device.makeCommandAllocator()!
        
        
        // MARK: - 顶点描述符
        // 描述顶点内存布局
        let vertexDescriptor = MTLVertexDescriptor()
        // 配置 position 属性
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        // 配置 color 属性
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        // 定义顶点内存布局
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        
        // MARK: - 设置 Buffer
        // 使用三角形的顶点数组创建 Buffer
        self.vertexBuffer = device.makeBuffer(
            bytes: vertices,
            length: MemoryLayout<Vertex>.size * vertices.count
        )!
        self.indexBuffer = device.makeBuffer(
            bytes: indices,
            length: MemoryLayout<UInt32>.size * indices.count
        )!
        self.uniformsBuffer = device.makeBuffer(
            length: MemoryLayout<Uniforms>.size
        )!
        
        
        // MARK: - 加载 Shader
        let library = device.makeDefaultLibrary()!
        
        // 顶点着色器
        let vertexFunctionDescriptor       = MTL4LibraryFunctionDescriptor()
        vertexFunctionDescriptor.library   = library
        vertexFunctionDescriptor.name      = "vertex_main"
        
        // 片元着色器
        let fragmentFunctionDescriptor     = MTL4LibraryFunctionDescriptor()
        fragmentFunctionDescriptor.library = library
        fragmentFunctionDescriptor.name    = "fragment_main"
        
        
        // MARK: - 描述符 Descriptor
        // 渲染管线描述符
        let pipelineDescriptor = MTL4RenderPipelineDescriptor()
        pipelineDescriptor.vertexFunctionDescriptor        = vertexFunctionDescriptor
        pipelineDescriptor.fragmentFunctionDescriptor      = fragmentFunctionDescriptor
        pipelineDescriptor.vertexDescriptor                = vertexDescriptor
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // 参数表
        let argTableDescriptor = MTL4ArgumentTableDescriptor()
        argTableDescriptor.maxBufferBindCount = 2 // 最多可以绑定两个 Buffer
        self.argumentTable = try device.makeArgumentTable(descriptor: argTableDescriptor)
        self.argumentTable.setAddress(vertexBuffer.gpuAddress, index: 0) // 将三角形顶点 Buffer 设为第 0 个 Buffer
        self.argumentTable.setAddress(uniformsBuffer.gpuAddress, index: 1) // 将 uniformsBuffer 设为第 1 个 Buffer
        
        // 深度模板描述符
        let depthStateDescriptor = MTLDepthStencilDescriptor()
        depthStateDescriptor.depthCompareFunction = .less
        depthStateDescriptor.isDepthWriteEnabled = true
        
        
        // MARK: - 状态 State
        // 创建渲染管线状态
        self.pipelineState = try device
            .makeCompiler(descriptor: MTL4CompilerDescriptor())
            .makeRenderPipelineState(descriptor: pipelineDescriptor)
        // 深度测试
        self.depthState = device
            .makeDepthStencilState(descriptor: depthStateDescriptor)!
        
        super.init()
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else { return }
        
        // MARK: - 更新 Uniforms
        let aspect = view.drawableSize.width / view.drawableSize.height
        updateUniforms(uniformBuffer: uniformsBuffer, aspect: Float(aspect))
        
        
        // MARK: - 开始命令编码 Begin Command Buffer
        self.commandQueue.waitForDrawable(drawable)
        self.commandAllocator.reset()
        self.commandBuffer.beginCommandBuffer(allocator: commandAllocator)
        
        
        // MARK: - Render Pass
        guard let mtl4RenderPassDescriptor = view.currentMTL4RenderPassDescriptor else { return }
        mtl4RenderPassDescriptor.colorAttachments[0].clearColor  = MTLClearColor(red: 0.2, green: 0.2, blue: 0.25, alpha: 1.0)
        
        
        // MARK: - 开始编码渲染 Begin Render Encoder
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(
            descriptor: mtl4RenderPassDescriptor,
            options: MTL4RenderEncoderOptions()
        ) else { return }
        
        
        // MARK: - 设置渲染状态
        renderEncoder.setDepthStencilState(depthState)
        renderEncoder.setRenderPipelineState(pipelineState)
        // 传递顶点数据给 Shader
        renderEncoder.setArgumentTable(argumentTable, stages: .vertex)
        
        
        // MARK: - 绘制 Draw
        renderEncoder.drawIndexedPrimitives(
            primitiveType: .triangle,
            indexCount: indices.count,
            indexType: .uint32,
            indexBuffer: indexBuffer.gpuAddress,
            indexBufferLength: MemoryLayout<UInt32>.size * indices.count
        )
        
        
        // MARK: - 结束渲染编码 End Render Encoder
        renderEncoder.endEncoding()
        
        // MARK: - 结束命令编码 End Command Buffer
        self.commandBuffer.endCommandBuffer()
        self.commandQueue.commit([commandBuffer], options: nil)
        self.commandQueue.signalDrawable(drawable)
        drawable.present()
    }
    
    func updateUniforms(uniformBuffer: MTLBuffer, aspect: Float) {
        // 准备 MVP 矩阵
        let modelMatrix = matrix_identity_float4x4
        
        let viewMatrix = lookAt(
            eye: camera.position,
            target: camera.target,
            up: camera.up
        )
        
        let projectionMatrix = perspective(
            aspect: aspect,
            fovy: .pi / 4,
            near: 0.1,
            far: 100
        )
        
        // 模型坐标 -> 世界坐标 -> 视图坐标 -> 裁剪坐标
        let mvpMatrix = projectionMatrix * viewMatrix * modelMatrix
        
        var uniforms = Uniforms(mvpMatrix: mvpMatrix)
        
        // 复制到 GPU 缓冲区
        memcpy(uniformBuffer.contents(), &uniforms, MemoryLayout<Uniforms>.size)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
}

#Preview {
    MetalView()
}
