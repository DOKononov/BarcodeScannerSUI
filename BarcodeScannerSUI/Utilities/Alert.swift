//
//  Alert.swift
//  BarcodeScannerSUI
//
//  Created by Dmitry Kononov on 9.01.24.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    
    let title: String
    let message: String
    let dissmisButton: Alert.Button
}

extension AlertItem {
    static let invalidDeviceInput = AlertItem(
        title: "Invalid Device Input",
        message: "Something is wrong with the camera",
        dissmisButton: .default(Text("Ok")))
    
    static let invalidScannedType = AlertItem(
        title: "Invalid Scan Type",
        message: "The value scanned is not valid",
        dissmisButton: .default(Text("Ok")))
}

