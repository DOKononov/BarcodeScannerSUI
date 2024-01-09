//
//  BarcodeScannerViewModel.swift
//  BarcodeScannerSUI
//
//  Created by Dmitry Kononov on 9.01.24.
//

import SwiftUI


final class BarcodeScannerViewModel: ObservableObject {
    @Published var scannedCode = ""
    @Published var alertItem: AlertItem?
    
    var statusText: String {
        scannedCode.isEmpty ? "Not yet scanned" : scannedCode
    }
    
    var statusColor: Color {
        scannedCode.isEmpty ? .red : .green
    }
}
