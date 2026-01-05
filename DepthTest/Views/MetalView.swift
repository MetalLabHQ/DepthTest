//
//  MetalView.swift
//  DepthTest
//
//  Created by GH on 1/5/26.
//

import SwiftUI
import MetalKit

struct MetalView: ViewRepresentable {
    let device: MTLDevice
    let renderer: Renderer
    
    init() {
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported")
        }
        
        guard defaultDevice.supportsFamily(.metal4) else {  // 检查是否支持 Metal 4
            fatalError("Metal 4 is not supported on this device")
        }
        
        device = defaultDevice
        do {
            self.renderer = try Renderer(device: device)
        } catch {
            fatalError("Error: \(error)")
        }
    }
    
#if os(macOS)
    func makeNSView(context: Context) -> MTKView {
        return makeView()
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {}
#else
    func makeUIView(context: Context) -> MTKView {
        return makeView()
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {}
#endif
    
    func makeView() -> MTKView {
        let mtkView = MTKView(frame: .zero, device: device)

        mtkView.delegate = renderer
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        return mtkView
    }
}

#Preview {
    MetalView()
}
