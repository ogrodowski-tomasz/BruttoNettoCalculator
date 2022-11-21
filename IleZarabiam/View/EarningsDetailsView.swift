//
//  EarningsDetailsView.swift
//  IleZarabiam
//
//  Created by Tomasz Ogrodowski on 20/11/2022.
//

import SwiftUI

struct EarningsDetailsView: View {
    @EnvironmentObject var service: EarningsCalculatorService
    @Environment(\.dismiss) var dismiss
    
    @State private var showZusDetails = false
    @State private var showSicknessContributionDetails = false
    @State private var showEmployeeIncomeDetails = false
    @State private var showTaxAdvancePaymentDetails = false
    
    var colors: [Color] {
        [.red, .yellow, .orange, .cyan]
    }
    
    @State private var showViews = Array(repeating: false, count: 4)
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.usafaBlue.ignoresSafeArea()
            ScrollView {
                VStack {
                    customNavigationBar
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            CircleIndicator(color: .clear)
                            Text("Pensja brutto: ") + Text("\(service.bruttoEarnings.abbreviated()) PLN").bold()
                        }
                        HStack {
                            CircleIndicator(color: colors[2])
                            Text("Pensja netto: ") + Text("\(service.nettoEarnings.abbreviated()) PLN").bold()
                        }
                    }
                    .padding(.bottom, 30)
                    .opacity(showViews[0] ? 1 : 0)
                    .offset(y: showViews[0] ? 0 : 250)
                    
                    PieChart(slices: [
                        PieChartSliceData(service.ZusContribution, colors[0]),
                        PieChartSliceData(service.healthCareContribution, colors[1]),
                        PieChartSliceData(service.nettoEarnings, colors[2]),
                        PieChartSliceData(service.taxAdvancePayment, colors[3])
                    ])
                    .frame(height: 250)
                    .opacity(showViews[1] ? 1 : 0)
                    .offset(y: showViews[1] ? 0 : 250)
                    
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(height: 1)
                        .padding(.horizontal)
                        .opacity(showViews[2] ? 1 : 0)
                        .offset(y: showViews[3] ? 0 : 250)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        CustomDetailsSection(indicatorColor: colors[0], title: "Składka ZUS", value: service.ZusContribution, detailsAnimationParameter: $showZusDetails) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Na składkę ZUS składa się:").fontWeight(.semibold)
                                SubsectionDetailsRow(title: "Składka emerytalna", percentageValue: service.pensionContribution)
                                SubsectionDetailsRow(title: "Składka Rentowa", percentageValue: service.disabilityContribution)
                                SubsectionDetailsRow(title: "Składka Chorobowa", percentageValue: service.sicknessContribution)
                            }
                        }
                                            
                        CustomDetailsSection(indicatorColor: colors[1], title: "Składka Chorobowa", value: service.healthCareContribution, detailsAnimationParameter: $showSicknessContributionDetails) {
                            Text("Składka zdrowotna to 9% z różnicy pensji brutto i składki na Zakład Ubezpieczeń Społecznych.")
                        }
                        
                        CustomDetailsSection(indicatorColor: .clear, title: "Dochód Pracownika", value: service.employeIncome, detailsAnimationParameter: $showEmployeeIncomeDetails) {
                            Text("Dochód pracownika to różnica trzech parametrów: Pensji brutto, składki na ZUS oraz miesięcznych kosztów pracowniczych mogących wynosić 250 zł lub 300 zł.")

                        }
                        
                        CustomDetailsSection(indicatorColor: colors[3], title: "Zaliczka na podatek dochodowy", value: service.taxAdvancePayment, detailsAnimationParameter: $showTaxAdvancePaymentDetails) {
                            Text("Wartość zaliczki to 12% dochodu pracownika pomniejszone o miesięczną kwotę wolną od podatku (300zł). Wynik zaokrąglany jest w górę.")
                        }
                        
                        VStack(spacing: 10) {
                            Text("Zarobki roczne")
                                .font(.largeTitle)
                                .fontWeight(.thin)
                            Text("Realnie zarobisz (kwota netto):")
                            Text(service.yearlyNettoEarnings.abbreviated())
                                .font(.title)
                                .fontWeight(.semibold)
                            +
                            Text(" PLN")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top)
                        
                    }
                    .padding(.horizontal)
                    .opacity(showViews[3] ? 1 : 0)
                    .offset(y: showViews[3] ? 0 : 250)
                }
            }
        }
        .onAppear(perform: activateView)
        .foregroundColor(.white)
        .navigationBarBackButtonHidden(true)
    }
    
    private func activateView() {
        withAnimation(.easeInOut) {
            showViews[0] = true
        }
        withAnimation(.easeInOut.delay(0.1)) {
            showViews[1] = true
        }
        withAnimation(.easeInOut.delay(0.15)) {
            showViews[2] = true
        }
        withAnimation(.easeInOut.delay(0.25)) {
            showViews[3] = true
        }
    }
}


extension EarningsDetailsView {
    
    private var customNavigationBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.down")
                    .rotationEffect(.init(degrees: 90))
                    .padding()
                    .font(.headline)
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.horizontal, .bottom])
    }
    
    private func CircleIndicator(color: Color) -> some View {
        Circle()
            .fill(color)
            .frame(width: 15, height: 15)
    }
    
    private func SubsectionDetailsRow(title: String, percentageValue value: Double) -> some View {
        HStack(alignment: .center) {
            Text("\(title): ")
                Spacer()
            Text("\((value * 100.0).abbreviated())%")
        }
    }
    
    @ViewBuilder
    private func CustomDetailsSection(
        indicatorColor color: Color,
        title: String,
        value: Double,
        detailsAnimationParameter parameter: Binding<Bool>,
        detailedView: () -> some View
    ) -> some View {
        HStack(alignment: .center) {
            CircleIndicator(color: color)
            Text(title)
            Image(systemName: "chevron.down")
                .font(.caption)
                .rotationEffect(.init(degrees: parameter.wrappedValue ? 0 : 180))
            Spacer()
            Text("PLN ")
                .font(.caption)
            +
            Text(value.abbreviated())
        }
        .background { Color.usafaBlue.opacity(0.001) }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                parameter.wrappedValue.toggle()
            }
        }
        
        if parameter.wrappedValue {
            detailedView()
            .padding(.top, 1)
            .padding(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.gray.opacity(0.3))
            }
        }

    }
}

struct EarningsDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EarningsDetailsView()
            .environmentObject(EarningsCalculatorService())
    }
}
