//
//  ContentView.swift
//  BarcodeScannerSUI
//
//  Created by Dmitry Kononov on 8.01.24.
//

import SwiftUI

struct BarcodeScannerView: View {
    
    @StateObject private var viewModel = BarcodeScannerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                
                ScanerView(scaneCode: $viewModel.scannedCode,
                           alertItem: $viewModel.alertItem)
                .frame(maxWidth: .infinity, maxHeight: 300)
                .padding(.bottom, 60)
                
                Label("Scanned barcode:",
                      systemImage: "barcode.viewfinder")
                .font(.title)
                
                Text(viewModel.statusText)
                    .foregroundColor(viewModel.statusColor)
                    .font(.largeTitle)
                    .bold()
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
            .alert(item: $viewModel.alertItem) {
                Alert(title: Text($0.title),
                      message: Text($0.message),
                      dismissButton: $0.dissmisButton)}
        }
        
    }
}

struct BarcodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
    }
}
