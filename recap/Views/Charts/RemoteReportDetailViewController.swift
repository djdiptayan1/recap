//
//  RemoteReportDetailViewController.swift
//  recap_charts
//
//  Created by admin70 on 13/11/24.
//

import Charts
import SwiftUI

struct LineChartView: View {
    let data: [RemoteMemoryData]

    var body: some View {
        Chart {
            ForEach(data) { report in
                if report.day != "Summary" { // Skip summary for detailed graph
                    LineMark(
                        x: .value("Day", report.day),
                        y: .value("Correct Answers", report.correctAnswers)
                    )
                    .foregroundStyle(Color.customLightPurple)
                    .lineStyle(StrokeStyle(lineWidth: 2))

                    LineMark(
                        x: .value("Day", report.day),
                        y: .value("Incorrect Answers", report.incorrectAnswers)
                    )
                    .foregroundStyle(Color.customLightRed)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(width: 250, height: 250)
        .padding()
        .padding(.horizontal)
    }
}

struct RemoteReportDetailViewController: View {
    let verifiedUserDocID: String
    @State private var remoteMemoryData: [RemoteMemoryData] = []

    private var currentMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.string(from: Date())
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.8, green: 0.93, blue: 0.95),
                    Color(red: 1.0, green: 0.88, blue: 0.88),
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Text("Remote Memory")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.horizontal)
                    VStack(spacing: 15) {
                        if remoteMemoryData.isEmpty {
                            Text("No data available for this month.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            LineChartView(data: remoteMemoryData)
                                .frame(width: 300, height: 250)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                                .padding(.horizontal)
                        }
                    }
                    // ✅ Summary Section Added Here
                    if let summary = remoteMemoryData.first(where: { $0.day == "Summary" }) {
                        VStack {
                            Text("📌 Monthly Summary")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("✅ Correct Answers: \(summary.correctAnswers)")
                                .foregroundColor(.green)
                                .fontWeight(.semibold)
                            Text("❌ Incorrect Answers: \(summary.incorrectAnswers)")
                                .foregroundColor(.red)
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("About Remote Insights")
                            .font(.headline)
                            .fontWeight(.bold)

                        Text("""
                        Remote memory refers to your ability to recall events or information from the distant past, typically over a week or more. By tracking your performance over time, we can observe trends that help you and your caregivers understand how well your long-term memory is functioning.
                        """)
                        .font(.body)
                        .foregroundColor(.black)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                        .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
        }
        .onAppear {
            print("🟢 RemoteReportDetailViewController appeared. Fetching data...")
            fetchRemoteMemoryData(for: verifiedUserDocID, month: currentMonth) { data in
                DispatchQueue.main.async {
                    if data.isEmpty {
                        print("⚠️ No data found, setting default values.")
                        self.remoteMemoryData = [RemoteMemoryData(day: "01", correctAnswers: 0, incorrectAnswers: 0)]
                    } else {
                        self.remoteMemoryData = data
                    }
                    print("📊 Final Remote Memory Data: \(self.remoteMemoryData)")
                }
            }
        }
        .onChange(of: remoteMemoryData) { newValue in
            print("📊 Chart data updated: \(newValue)")
        }
    }
}
