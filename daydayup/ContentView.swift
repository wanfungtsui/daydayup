
import SwiftUI
import Charts

// MARK: - Models
struct ExerciseMetrics {
    let totalTime: TimeInterval
    let distance: Double
    let averageSpeed: Double
    let currentSpeed: Double
    let averageHeartRate: Double
    let currentHeartRate: Double
}

struct TimeSeriesData: Identifiable {
    let id = UUID()
    let timestamp: Date
    let value: Double
}

// MARK: - View Models
enum TimeFilter {
    case today, weekly, monthly
}

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Dashboard")
                }
            
            AchievementsView()
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("Achievements")
                }
        }
    }
}

// MARK: - Dashboard View
struct DashboardView: View {
    @State private var selectedTimeFilter: TimeFilter = .today
    @State private var selectedExercise: ExerciseType = .cycling
    
    // Sample data (replace with real data from your backend)
    let cyclingMetrics = ExerciseMetrics(totalTime: 3600, distance: 20, averageSpeed: 18, currentSpeed: 20, averageHeartRate: 140, currentHeartRate: 145)
    let swimmingMetrics = ExerciseMetrics(totalTime: 1800, distance: 2, averageSpeed: 2, currentSpeed: 2.2, averageHeartRate: 130, currentHeartRate: 135)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Time Filter
                    TimeFilterView(selectedTimeFilter: $selectedTimeFilter)
                    
                    // Exercise Toggle
                    ExerciseToggleView(selectedExercise: $selectedExercise)
                    
                    // Current Metrics Card
                    MetricsCardView(metrics: selectedExercise == .cycling ? cyclingMetrics : swimmingMetrics)
                    
                    // Charts
                    ChartsSectionView()
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}

// MARK: - Supporting Views
struct TimeFilterView: View {
    @Binding var selectedTimeFilter: TimeFilter
    
    var body: some View {
        Picker("Time Filter", selection: $selectedTimeFilter) {
            Text("Today").tag(TimeFilter.today)
            Text("Weekly").tag(TimeFilter.weekly)
            Text("Monthly").tag(TimeFilter.monthly)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct ExerciseToggleView: View {
    @Binding var selectedExercise: ExerciseType
    
    var body: some View {
        Picker("Exercise Type", selection: $selectedExercise) {
            Text("Cycling").tag(ExerciseType.cycling)
            Text("Swimming").tag(ExerciseType.swimming)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct MetricsCardView: View {
    let metrics: ExerciseMetrics
    
    var body: some View {
        VStack(spacing: 15) {
            MetricRow(title: "Total Time", value: formatTime(metrics.totalTime))
            MetricRow(title: "Distance", value: String(format: "%.1f km", metrics.distance))
            MetricRow(title: "Average Speed", value: String(format: "%.1f km/h", metrics.averageSpeed))
            MetricRow(title: "Current Speed", value: String(format: "%.1f km/h", metrics.currentSpeed))
            MetricRow(title: "Average Heart Rate", value: String(format: "%.0f bpm", metrics.averageHeartRate))
            MetricRow(title: "Current Heart Rate", value: String(format: "%.0f bpm", metrics.currentHeartRate))
        }
        .padding()
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        return String(format: "%02d:%02d", hours, minutes)
    }
}

struct MetricRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
    }
}

struct ChartsSectionView: View {
    // Sample data (replace with real data)
    let heartRateData: [TimeSeriesData] = [
        TimeSeriesData(timestamp: Date().addingTimeInterval(-3600), value: 130),
        TimeSeriesData(timestamp: Date().addingTimeInterval(-2400), value: 145),
        TimeSeriesData(timestamp: Date().addingTimeInterval(-1200), value: 150),
        TimeSeriesData(timestamp: Date(), value: 140)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Heart Rate Trend")
                .font(.headline)
            
            Chart {
                ForEach(heartRateData) { data in
                    LineMark(
                        x: .value("Time", data.timestamp),
                        y: .value("Heart Rate", data.value)
                    )
                }
            }
            .frame(height: 200)
        }
        .padding()
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}


