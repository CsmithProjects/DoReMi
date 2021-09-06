//
//  SwitchCellViewModel.swift
//  DoReMi
//
//  Created by Conor Smith on 9/2/21.
//

import Foundation

struct SwitchCellViewModel {
    let title: String
    var isOn: Bool
    
    mutating func setOn(_ on: Bool) {
        self.isOn = on
    }
}
