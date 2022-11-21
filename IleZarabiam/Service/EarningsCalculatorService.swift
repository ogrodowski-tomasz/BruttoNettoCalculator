//
//  ViewModel.swift
//  IleZarabiam
//
//  Created by Tomasz Ogrodowski on 19/11/2022.
//

import Combine
import Foundation
import SwiftUI

class EarningsCalculatorService: ObservableObject {
    
    // MARK: - Stored Properties
    
    /// Składka Emerytalna
    let pensionContribution = 0.0976
    /// Składka Rentowa
    let disabilityContribution = 0.015
    /// Składka Chorobowa
    let sicknessContribution = 0.0245
    /// Koszty Pracownicze
    let workingCosts = 250.0
    
    // MARK: - Published properties
    
    // Main-Screen properties
    
    /// Wynagordzenie brutto jako tekst
    @Published var bruttoText = ""
    
    /// Typ umowy. Na razie ta funkcja jest nieaktywna
//    @Published var selectedContractType: ContractType = .uop
    /// Wymiar godzinowy pracy
    @Published var selectedJobTime: JobPartTime = .full

    @Published var isUnder26 = false
    
    @Published var bruttoEarnings = 0.0 {
        didSet {
            makeCalculations()
        }
    }
    
    // Calculated-screen properties
    /// Składka ZUS
    @Published var ZusContribution = 0.0
    /// Składka Zdrowotna
    @Published var healthCareContribution = 0.0
    /// Dochód Pracownika
    @Published var employeIncome = 0.0
    /// Zaliczka na Podatek Dochodowy PIT
    @Published var taxAdvancePayment = 0.0
    
    /// Wynagrodzenie Netto
    @Published var nettoEarnings = 0.0
    /// Roczne wynagrodzenie Netto
    @Published var yearlyNettoEarnings = 0.0
    
    
    // Combine
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    
    init() {
        addSubscribers()
    }
    
    // MARK: - Methods
    
    func makeCalculations() {
        calculateZusContribution {
            calculateHealthCareContribution {
                calculateEmployeeIncome {
                    calculateTaxAdvancePayment {
                        calculateNetto()
                    }
                }
            }
        }
    }
    
    private func addSubscribers() {
        $bruttoText
            .combineLatest($selectedJobTime, $isUnder26, $selectedJobTime)
            .flatMap { text, _, _, _ in
                return Just<String>(text)
            }
            .sink { [weak self] valueAsString in
                guard let valueAsDouble = Double(valueAsString) else { return }
                self?.bruttoEarnings = valueAsDouble
            }
            .store(in: &cancellables)
        
    }
    
    private func calculateZusContribution(completion: () -> Void) {
        ZusContribution = bruttoEarnings * (disabilityContribution + sicknessContribution + pensionContribution)
        completion()
    }
    
    private func calculateHealthCareContribution(completion: () -> Void) {
        healthCareContribution = (bruttoEarnings - ZusContribution) * 0.09
        completion()
    }
    
    private func calculateEmployeeIncome(completion: () -> Void) {
        employeIncome = bruttoEarnings - ZusContribution - workingCosts
        completion()
    }
    
    private func calculateTaxAdvancePayment(completion: () -> Void) {
        if !isUnder26 {
            taxAdvancePayment = (employeIncome * 0.12 - 300).rounded()
        } else {
            taxAdvancePayment = 0
        }
        completion()
    }
    
    private func calculateNetto() {
        nettoEarnings = bruttoEarnings - ZusContribution - healthCareContribution - taxAdvancePayment
        yearlyNettoEarnings = nettoEarnings * 12
    }
}
