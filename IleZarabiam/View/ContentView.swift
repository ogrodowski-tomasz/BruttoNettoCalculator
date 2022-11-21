//
//  ContentView.swift
//  IleZarabiam
//
//  Created by Tomasz Ogrodowski on 19/11/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var showDetails = false
    
    @StateObject private var viewModel = EarningsCalculatorService()
    
    
    
    var body: some View {
        NavigationView {
            Form {
                Group {
                    TextField("Zarobki brutto", text: $viewModel.bruttoText)
                        .keyboardType(.decimalPad)
                
//                    Picker("Typ umowy", selection: $viewModel.selectedContractType) {
//                        ForEach(ContractType.allCases, id: \.self) { type in
//                            Text(type.description)
//                        }
//                    }
                    
                    Picker("Typ etatu", selection: $viewModel.selectedJobTime) {
                        ForEach(JobPartTime.allCases, id: \.self) { type in
                            Text(type.description)
                        }
                    }
                }
                
                
                Group {
                    skladkiZusSection
                    skladkaZdrowotnaSection
                    dochodPracownikaSection
                    zaliczkaNaPodatekDochodowySection
                    wynagrodzenieNettoSection
                }
            }
            .navigationTitle("Kalkulator pensji")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    private var skladkiZusSection: some View {
        Section("Składki na ZUS") {
            VStack(alignment: .leading, spacing: 15) {
                HStack(alignment: .center) {
                    Text("Składka").bold()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .fontWeight(.light)
                        .rotationEffect(.init(degrees: showDetails ? 0 : 180))
                    Spacer()
                    Text("\(viewModel.ZusContribution.abbreviated())")
                        .fontWeight(.heavy)
                }
                .onTapGesture {
                    showDetails.toggle()
                    withAnimation(.easeInOut) {
                        // TODO: Handle animation here
                    }
                }
                
                if showDetails {
                    HStack(alignment: .center) {
                        Text("Składka emerytalna: ")
                            Spacer()
                        Text("\(viewModel.pensionContribution * 100.0)%")
                    }
                    HStack(alignment: .center) {
                        Text("Składka Rentowa: ")
                            Spacer()
                        Text("\(viewModel.disabilityContribution * 100.0)%")
                    }
                    HStack(alignment: .center) {
                        Text("Składka Chorobowa: ")
                            Spacer()
                        Text("\(viewModel.sicknessContribution * 100.0)%")
                    }
                }
            }
            
        }
    }
    
    private var skladkaZdrowotnaSection: some View {
        Section("Składka zdrowotna") {
            VStack(alignment: .leading, spacing: 15) {
                HStack(alignment: .center) {
                    Text("Składka").bold()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .fontWeight(.light)
                        .rotationEffect(.init(degrees: showDetails ? 0 : 180))
                    Spacer()
                    Text("\(viewModel.healthCareContribution.abbreviated())")
                        .fontWeight(.heavy)
                }
            }

        }
    }
    
    private var dochodPracownikaSection: some View {
        Section("Dochód pracownika") {
            VStack(alignment: .leading, spacing: 15) {
                HStack(alignment: .center) {
                    Text("Dochód").bold()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .fontWeight(.light)
                        .rotationEffect(.init(degrees: showDetails ? 0 : 180))
                    Spacer()
                    Text("\(viewModel.employeIncome.abbreviated())")
                        .fontWeight(.heavy)
                }
            }

        }
    }
    
    private var zaliczkaNaPodatekDochodowySection: some View {
        Section("Zaliczka na podatek dochodowy") {
            VStack(alignment: .leading, spacing: 15) {
                HStack(alignment: .center) {
                    Text("Dochód").bold()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .fontWeight(.light)
                        .rotationEffect(.init(degrees: showDetails ? 0 : 180))
                    Spacer()
                    Text("\(viewModel.taxAdvancePayment.rounded().abbreviated())")
                        .fontWeight(.heavy)
                }
            }

        }
    }
    
    private var wynagrodzenieNettoSection: some View {
        Section("Wynagrodzenie Netto") {
            VStack(alignment: .leading, spacing: 15) {
                HStack(alignment: .center) {
                    Text("Wynagrodzenie Netto").bold()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .fontWeight(.light)
                        .rotationEffect(.init(degrees: showDetails ? 0 : 180))
                    Spacer()
                    Text("\(viewModel.nettoEarnings.abbreviated())")
                        .fontWeight(.heavy)
                }
            }

        }
    }

}
