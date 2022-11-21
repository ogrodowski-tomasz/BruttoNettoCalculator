//
//  HomeView.swift
//  IleZarabiam
//
//  Created by Tomasz Ogrodowski on 20/11/2022.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var service = EarningsCalculatorService()
    
    @State private var showViews = Array(repeating: false, count: 6)
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                Group {
                    Text("Kalkulator Wynagrodzenia".uppercased())
                        .multilineTextAlignment(.center)
                        .font(.system(.largeTitle, design: .default, weight: .heavy))
                    Text("Oblicz wartość wynagrodzenia netto w zależności od poniższych czynników.")
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)
                    ParametersSheet
                        .foregroundColor(.white)
                }
                .opacity(showViews[0] ? 1 : 0)
                .offset(y: showViews[0] ? 0 : 250)
                
                
            }
            .toolbar(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 30)
            .onAppear(perform: animateViews)
        }
        
    }
    
}

// view components

extension HomeView {
    
    private var ParametersSheet: some View {
        VStack(alignment: .center, spacing: 30) {
            Group {
                Text("Wprowadź wynagrodzenie brutto")
                    .font(.title2)
                    .fontWeight(.semibold)
                HStack(alignment: .center, spacing: 15) {
                    Image(systemName: "dollarsign.square")
                        .font(.title2)
                    TextField("Pensja brutto", text: $service.bruttoText, prompt: Text("Wynagrodzenie brutto...").foregroundColor(.white))
                        .keyboardType(.decimalPad)
                        .keyboardShortcut(.return)
                        
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 0.4)
                }
                .padding(.horizontal)
            }
            .opacity(showViews[2] ? 1 : 0)
            .offset(y: showViews[2] ? 0 : 250)
            
            HStack {
                Text("Wymiar godzin")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Picker("Część etatu", selection: $service.selectedJobTime) {
                    ForEach(JobPartTime.allCases, id: \.self) { type in
                        Text(type.description)
                    }
                }
                .tint(.white)
            }
            .opacity(showViews[3] ? 1 : 0)
            .offset(y: showViews[3] ? 0 : 250)
            
            Toggle(isOn: $service.isUnder26) {
                Text("Czy jesteś poniżej 26 roku życia?")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .opacity(showViews[4] ? 1 : 0)
            .offset(y: showViews[4] ? 0 : 250)
            
            NavigationLink(destination: {
                EarningsDetailsView()
                    .environmentObject(service)
            }, label: {
                Text("Oblicz wynagrodzenie netto")
                    .foregroundColor(.black)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.thinMaterial)
                    }
            })
            .opacity(showViews[5] ? 1 : 0)
            .offset(y: showViews[5] ? 0 : 250)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.usafaBlue)
                .padding(.top, -65)
                .offset(y: 40)
        }
        .opacity(showViews[1] ? 1 : 0)
        .offset(y: showViews[1] ? 0 : 250)
    }
    
}


// additional methods
extension HomeView {
    
    func animateViews() {
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
        withAnimation(.easeInOut.delay(0.3)) {
            showViews[4] = true
        }
        withAnimation(.easeInOut.delay(0.35)) {
            showViews[5] = true
        }
    }

    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

