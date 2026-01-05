//
//  PlatformCompatibility.swift
//  DepthTest
//
//  Created by GH on 1/5/26.
//

import SwiftUI

#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
typealias PlatformView = NSView
typealias PlatformViewController = NSViewController
typealias PlatformColor = NSColor
#else
typealias ViewRepresentable = UIViewRepresentable
typealias PlatformView = UIView
typealias PlatformViewController = UIViewController
typealias PlatformColor = UIColor
#endif
