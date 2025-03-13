//
//  immediateMemoryChart.swift
//  recap_charts
//
//  Created by admin70 on 13/11/24.
//

import SwiftUI

struct ImmediateReportDetailViewController: View {
    @State private var immediateMemoryData: [ImmediateMemoryData] = []
    private let verifiedUserDocID: String
    
    
    init(verifiedUserDocID: String) {
        self.verifiedUserDocID = verifiedUserDocID
        print("✅ ImmediateReport initialized with User Doc ID: \(verifiedUserDocID)")
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.8, green: 0.93, blue: 0.95), Color(red: 1.0, green: 0.88, blue: 0.88)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Text("Immediate Memory")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.horizontal)

                    VStack(spacing: 15) {
                        if immediateMemoryData.isEmpty {
                            Text("No memory data available")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(immediateMemoryData) { data in
                                VStack(spacing: 10) {
                                    Text("Date: \(data.date, formatter: DateFormatter.shortDate)")
                                        .font(.subheadline)
                                        .padding(.top)

                                    if data.correctAnswers + data.incorrectAnswers > 0 {
                                        DonutChartView(correctAnswers: data.correctAnswers, incorrectAnswers: data.incorrectAnswers)
                                            .frame(width: 300, height: 200)
                                            .padding()
                                    } else {
                                        Text("No data available for this date")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .padding()
                                    }
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: Constants.CardSize.DefaultCardCornerRadius).fill(Color.white))
                                .shadow(radius: 5)
                            }
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("About Immediate Insights")
                            .font(.headline)
                            .fontWeight(.bold)

                        Text("""
                        Your immediate memory helps you retain information learned just a few minutes ago. This section tracks how well you remember recent activities and conversations.

                        Short-term memory is essential for processing recent information. Consistently performing well here indicates strong immediate recall abilities.
                        """)
                        .font(.body)
                        .foregroundColor(.black)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: Constants.CardSize.DefaultCardCornerRadius).fill(Color.white))
                        .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
        }
        .onAppear {
            print("Fetching data...")
            loadMemoryData()
        }
    }
    
    /// Fetches immediate memory data from Firestore
    private func loadMemoryData() {
        fetchImmediateMemoryData(for: verifiedUserDocID) { data in
            DispatchQueue.main.async {
                self.immediateMemoryData = data
                print("Fetched Data:", data)
            }
        }
    }
}

struct DonutChartView: View {
    let correctAnswers: Int
    let incorrectAnswers: Int

    var body: some View {
        let totalAnswers = correctAnswers + incorrectAnswers
        let correctFraction = totalAnswers > 0 ? Double(correctAnswers) / Double(totalAnswers) : 0
        let incorrectFraction = totalAnswers > 0 ? Double(incorrectAnswers) / Double(totalAnswers) : 0

        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 20)

            if totalAnswers > 0 {
                Circle()
                    .trim(from: 0, to: correctFraction)
                    .stroke(AngularGradient(gradient: Gradient(colors: [Color.customLightPurple]), center: .center), lineWidth: 40)
                    .rotationEffect(.degrees(-90))

                Circle()
                    .trim(from: correctFraction, to: correctFraction + incorrectFraction)
                    .stroke(AngularGradient(gradient: Gradient(colors: [Color.customLightRed]), center: .center), lineWidth: 40)
                    .rotationEffect(.degrees(-90))
            } else {
                Text("No memory data")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Circle()
                .fill(Color.white)
                .frame(width: 180, height: 180)

            VStack {
                Text(totalAnswers > 0 ? "\(correctAnswers) / \(totalAnswers)" : "No Data")
                    .font(.headline)
                if totalAnswers > 0 {
                    Text("Correct")
                        .font(.subheadline)
                }
            }
        }
        .frame(width: 190, height: 190)
    }
}

// Date Formatter Extension
extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

//struct ImmediateReportDetailViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        ImmediateReportDetailViewController()
//    }
//}
//
//  immediateMemoryChart.swift
//  recap_charts
//
//  Created by admin70 on 13/11/24.
//

//import SwiftUI
//
//struct ImmediateReportDetailViewController: View {
//    @State private var immediateMemoryData: [ImmediateMemoryData] = []
//    private let verifiedUserDocID: String
//    
//    init(verifiedUserDocID: String) {
//        self.verifiedUserDocID = verifiedUserDocID
//        print("✅ ImmediateReport initialized with User Doc ID: \(verifiedUserDocID)")
//    }
//
//    var body: some View {
//        ZStack {
//            LinearGradient(
//                gradient: Gradient(colors: [Color(red: 0.8, green: 0.93, blue: 0.95), Color(red: 1.0, green: 0.88, blue: 0.88)]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
//
//            VStack(spacing: 0) {
//                // Header
//                HStack {
//                    Text("Immediate Memory")
//                        .font(.system(size: 28, weight: .bold))
//                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
//                    
//                    Spacer()
//                }
//                .padding(.horizontal, 20)
//                .padding(.top, 15)
//                .padding(.bottom, 10)
//                
//                // Stats overview card
//                if !immediateMemoryData.isEmpty {
//                    statsOverviewCard
//                        .padding(.horizontal, 20)
//                        .padding(.bottom, 15)
//                }
//
//                ScrollView {
//                    VStack(spacing: 16) {
//                        if immediateMemoryData.isEmpty {
//                            emptyStateView
//                        } else {
//                            ForEach(immediateMemoryData) { data in
//                                memoryDataCard(data)
//                            }
//                        }
//                        
//                        // Information section
//                        infoSection
//                            .padding(.top, 10)
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.bottom, 20)
//                }
//            }
//        }
//        .onAppear {
//            print("Fetching data...")
//            loadMemoryData()
//        }
//    }
//    
//    // Stats overview card
//    private var statsOverviewCard: some View {
//        let totalEntries = immediateMemoryData.count
//        let totalCorrect = immediateMemoryData.reduce(0) { $0 + $1.correctAnswers }
//        let totalQuestions = immediateMemoryData.reduce(0) { $0 + $1.correctAnswers + $1.incorrectAnswers }
//        let overallAccuracy = totalQuestions > 0 ? Double(totalCorrect) / Double(totalQuestions) * 100 : 0
//        
//        return HStack(spacing: 12) {
//            statItem(value: "\(totalEntries)", label: "Entries", icon: "calendar")
//            
//            Divider()
//                .frame(height: 40)
//            
//            statItem(value: "\(Int(overallAccuracy))%", label: "Accuracy", icon: "chart.bar.fill")
//            
//            Divider()
//                .frame(height: 40)
//            
//            statItem(value: "\(totalCorrect)/\(totalQuestions)", label: "Correct", icon: "checkmark.circle.fill")
//        }
//        .padding(.vertical, 16)
//        .padding(.horizontal, 20)
//        .background(
//            RoundedRectangle(cornerRadius: Constants.CardSize.DefaultCardCornerRadius)
//                .fill(Color.white)
//                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
//        )
//    }
//    
//    // Helper function for stat items
//    private func statItem(value: String, label: String, icon: String) -> some View {
//        VStack(spacing: 5) {
//            HStack(spacing: 6) {
//                Image(systemName: icon)
//                    .foregroundColor(Color.customLightPurple)
//                
//                Text(value)
//                    .font(.system(size: 18, weight: .bold))
//                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
//            }
//            
//            Text(label)
//                .font(.system(size: 12))
//                .foregroundColor(Color.gray)
//        }
//        .frame(maxWidth: .infinity)
//    }
//    
//    // Empty state view
//    private var emptyStateView: some View {
//        VStack(spacing: 15) {
//            Image(systemName: "brain")
//                .font(.system(size: 50))
//                .foregroundColor(Color.gray.opacity(0.6))
//                .padding(.bottom, 5)
//            
//            Text("No memory data available")
//                .font(.headline)
//                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
//            
//            Text("Complete memory exercises to start tracking your immediate recall abilities")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal)
//            
//            Button(action: {
//                // Action to navigate to exercises
//                print("Navigate to exercises")
//            }) {
//                Text("Start Exercises")
//                    .font(.system(size: 16, weight: .medium))
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 10)
//                    .background(Color.customLightPurple)
//                    .cornerRadius(10)
//            }
//            .padding(.top, 10)
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.vertical, 40)
//        .background(
//            RoundedRectangle(cornerRadius: Constants.CardSize.DefaultCardCornerRadius)
//                .fill(Color.white)
//                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
//        )
//        .padding(.top, 20)
//    }
//    
//    // Memory data card
//    private func memoryDataCard(_ data: ImmediateMemoryData) -> some View {
//        VStack(spacing: 15) {
//            HStack {
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(data.date, formatter: DateFormatter.mediumDate)
//                        .font(.system(size: 18, weight: .semibold))
//                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
//                    
//                    if let weekday = getWeekday(from: data.date) {
//                        Text(weekday)
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                    }
//                }
//                
//                Spacer()
//                
//                Text("\(data.correctAnswers + data.incorrectAnswers) questions")
//                    .font(.system(size: 14))
//                    .foregroundColor(.gray)
//                    .padding(.vertical, 4)
//                    .padding(.horizontal, 10)
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(12)
//            }
//            .padding(.horizontal, 20)
//            .padding(.top, 16)
//            
//            if data.correctAnswers + data.incorrectAnswers > 0 {
//                HStack(alignment: .top, spacing: 20) {
//                    DonutChartView(correctAnswers: data.correctAnswers, incorrectAnswers: data.incorrectAnswers)
//                        .frame(width: 140, height: 140)
//                    
//                    VStack(alignment: .leading, spacing: 15) {
//                        let totalAnswers = data.correctAnswers + data.incorrectAnswers
//                        let accuracy = Double(data.correctAnswers) / Double(totalAnswers) * 100
//                        
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("\(Int(accuracy))%")
//                                .font(.system(size: 24, weight: .bold))
//                                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
//                            
//                            Text("Accuracy")
//                                .font(.system(size: 14))
//                                .foregroundColor(.gray)
//                        }
//                        
//                        HStack(spacing: 15) {
//                            labelWithCount(count: data.correctAnswers, label: "Correct", color: Color.customLightPurple)
//                            labelWithCount(count: data.incorrectAnswers, label: "Incorrect", color: Color.customLightRed)
//                        }
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                }
//                .padding(.bottom, 16)
//            } else {
//                Text("No data available for this date")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .padding(.bottom, 16)
//            }
//        }
//        .background(
//            RoundedRectangle(cornerRadius: Constants.CardSize.DefaultCardCornerRadius)
//                .fill(Color.white)
//                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
//        )
//    }
//    
//    // Helper function for labels with count
//    private func labelWithCount(count: Int, label: String, color: Color) -> some View {
//        HStack(spacing: 8) {
//            Circle()
//                .fill(color)
//                .frame(width: 12, height: 12)
//            
//            VStack(alignment: .leading, spacing: 2) {
//                Text("\(count)")
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
//                
//                Text(label)
//                    .font(.system(size: 12))
//                    .foregroundColor(.gray)
//            }
//        }
//    }
//    
//    // Information section
//    private var infoSection: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text("About Immediate Memory")
//                .font(.system(size: 20, weight: .bold))
//                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
//                .padding(.bottom, 4)
//
//            infoCard(
//                icon: "brain.head.profile",
//                title: "What is immediate memory?",
//                description: "Immediate memory helps you retain information learned just a few minutes ago. It's essential for processing recent information and conversations."
//            )
//            
//            infoCard(
//                icon: "chart.bar.xaxis",
//                title: "Track your progress",
//                description: "Consistently performing well indicates strong immediate recall abilities. Regular practice can help improve this cognitive function."
//            )
//            
//            infoCard(
//                icon: "lightbulb.fill",
//                title: "Tip",
//                description: "Try to focus fully when learning new information. Removing distractions can significantly improve your immediate memory performance."
//            )
//        }
//        .padding(20)
//        .background(
//            RoundedRectangle(cornerRadius: Constants.CardSize.DefaultCardCornerRadius)
//                .fill(Color.white)
//                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
//        )
//    }
//    
//    // Helper function for info cards
//    private func infoCard(icon: String, title: String, description: String) -> some View {
//        HStack(alignment: .top, spacing: 12) {
//            Image(systemName: icon)
//                .font(.system(size: 18))
//                .foregroundColor(Color.customLightPurple)
//                .frame(width: 28, height: 28)
//            
//            VStack(alignment: .leading, spacing: 4) {
//                Text(title)
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
//                
//                Text(description)
//                    .font(.system(size: 14))
//                    .foregroundColor(.gray)
//                    .fixedSize(horizontal: false, vertical: true)
//            }
//        }
//        .padding(.vertical, 8)
//    }
//    
//    /// Fetches immediate memory data from Firestore
//    private func loadMemoryData() {
//        fetchImmediateMemoryData(for: verifiedUserDocID) { data in
//            DispatchQueue.main.async {
//                self.immediateMemoryData = data
//                print("Fetched Data:", data)
//            }
//        }
//    }
//    
//    // Helper function to get weekday from date
//    private func getWeekday(from date: Date) -> String? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        return dateFormatter.string(from: date)
//    }
//}
//
//struct DonutChartView: View {
//    let correctAnswers: Int
//    let incorrectAnswers: Int
//    
//    var body: some View {
//        let totalAnswers = correctAnswers + incorrectAnswers
//        let correctFraction = totalAnswers > 0 ? Double(correctAnswers) / Double(totalAnswers) : 0
//        
//        ZStack {
//            // Background circle
//            Circle()
//                .stroke(Color.gray.opacity(0.15), lineWidth: 12)
//            
//            if totalAnswers > 0 {
//                // Progress circle
//                Circle()
//                    .trim(from: 0, to: CGFloat(correctFraction))
//                    .stroke(
//                        AngularGradient(
//                            gradient: Gradient(colors: [
//                                Color.customLightPurple.opacity(0.8),
//                                Color.customLightPurple
//                            ]),
//                            center: .center
//                        ),
//                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
//                    )
//                    .rotationEffect(.degrees(-90))
//                    .animation(.easeInOut(duration: 1.0), value: correctFraction)
//            }
//            
//            // Center content
//            VStack(spacing: 4) {
//                Text("\(correctAnswers)")
//                    .font(.system(size: 22, weight: .bold))
//                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
//                
//                Text("of \(totalAnswers)")
//                    .font(.system(size: 12))
//                    .foregroundColor(.gray)
//            }
//        }
//    }
//}
//
//// Extended DateFormatter
//extension DateFormatter {
//    static var shortDate: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        return formatter
//    }
//    
//    static var mediumDate: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter
//    }
//}
