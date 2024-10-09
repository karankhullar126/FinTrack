//
//  MonthYearPickerView.swift
//  FInTrack
//
//  Created by Karan Khullar on 08/10/24.
//

import SwiftUI

struct MonthYearPickerView: View {
    @Binding var isPresented: Bool
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @State private var selectedMonthPicker: Int
    @State private var selectedYearPicker: Int 
    
    init(isPresented: Binding<Bool>, selectedMonth: Binding<Int>, selectedYear: Binding<Int>) {
        self._isPresented = isPresented
        self._selectedMonth = selectedMonth
        self._selectedYear = selectedYear
        self.selectedMonthPicker = selectedMonth.wrappedValue
        self.selectedYearPicker = selectedYear.wrappedValue
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Picker("Month", selection: $selectedMonthPicker) {
                        ForEach(1..<13, id: \.self) { month in
                            Text(Date.monthString(from: month)).tag(month)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    Picker("Year", selection: $selectedYearPicker) {
                        ForEach((1900...2100), id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Select Month and Year")
            .navigationBarItems(trailing: Button("Done") {
                selectedMonth = selectedMonthPicker
                selectedYear = selectedYearPicker
                isPresented = false // Dismiss the view
            })
            .padding()
        }
    }
}


