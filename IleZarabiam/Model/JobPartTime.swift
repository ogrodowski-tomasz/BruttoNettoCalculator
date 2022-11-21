//
//  JobPartTime.swift
//  IleZarabiam
//
//  Created by Tomasz Ogrodowski on 20/11/2022.
//

import Foundation

enum JobPartTime: CaseIterable {
    case full
    case half
    case quarter
    case threeQuarter
    case oneEigth
    case twoFifths
    
    var description: String {
        switch self {
        case .full:
            return "Pełen etat"
        case .half:
            return "1/2 etatu"
        case .quarter:
            return "1/4 etatu"
        case .threeQuarter:
            return "3/4 etatu"
        case .oneEigth:
            return "1/8 etatu"
        case .twoFifths:
            return "2/5 etatu"
        }
    }
    
    var multiplier: Double {
        switch self {
        case .full:
            return 1.0
        case .half:
            return 1/2
        case .quarter:
            return 1/4
        case .threeQuarter:
            return 3/4
        case .oneEigth:
            return 1/8
        case .twoFifths:
            return 2/5
        }
    }
}
