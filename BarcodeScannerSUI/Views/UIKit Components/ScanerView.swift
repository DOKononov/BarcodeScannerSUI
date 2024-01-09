//
//  ScanerView.swift
//  BarcodeScannerSUI
//
//  Created by Dmitry Kononov on 8.01.24.
//

import SwiftUI

struct ScanerView: UIViewControllerRepresentable {

    @Binding var scaneCode: String
    @Binding var alertItem: AlertItem?
    
    func makeUIViewController(context: Context) -> ScanerVC {
        ScanerVC(scanerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScanerVC, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scanerView: self)
    }
    
    final class Coordinator:NSObject, ScanerVCDelegate {
        
        private let scanerView: ScanerView
        
        init(scanerView: ScanerView) {
            self.scanerView = scanerView
        }
        
        func didFind(barcode: String) {
            scanerView.scaneCode = barcode
        }
        
        func didSurface(error: CameraError) {
            switch error {
            case .invalidDeviceInput:
                scanerView.alertItem = AlertItem.invalidDeviceInput
            case .invalidScaneValue:
                scanerView.alertItem = AlertItem.invalidScannedType
            }
            
        }
    }
}

struct ScanerView_Previews: PreviewProvider {
    static var previews: some View {
        ScanerView(scaneCode: .constant(""), alertItem: .constant(nil))
    }
}
