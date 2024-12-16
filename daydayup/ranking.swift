import SwiftUI

struct Achievement {
    let id: UUID
    let title: String
    let description: String
    let currentProgress: Double
    let targetProgress: Double
    let type: ExerciseType
    let level: Int
    var isCompleted: Bool {
        return currentProgress >= targetProgress
    }
}

struct AchievementsView: View {
    @State private var selectedType: ExerciseType = .swimming
    @State private var achievements: [Achievement] = []
    
    private func loadAchievements() {
        achievements = [
            // Swimming Achievements (Distance based)
            Achievement(id: UUID(), title: "Beginner Swimmer", description: "Swim 5km total", currentProgress: 3, targetProgress: 5, type: .swimming, level: 1),
            Achievement(id: UUID(), title: "Intermediate Swimmer", description: "Swim 10km total", currentProgress: 4, targetProgress: 10, type: .swimming, level: 2),
            Achievement(id: UUID(), title: "Advanced Swimmer", description: "Swim 20km total", currentProgress: 8, targetProgress: 20, type: .swimming, level: 3),
            
            // Cycling Achievements (Speed based)
            Achievement(id: UUID(), title: "Casual Cyclist", description: "Maintain 15 km/h average", currentProgress: 12, targetProgress: 15, type: .cycling, level: 1),
            Achievement(id: UUID(), title: "Regular Cyclist", description: "Maintain 20 km/h average", currentProgress: 18, targetProgress: 20, type: .cycling, level: 2),
            Achievement(id: UUID(), title: "Pro Cyclist", description: "Maintain 25 km/h average", currentProgress: 15, targetProgress: 25, type: .cycling, level: 3),
        ]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Exercise Type", selection: $selectedType) {
                    Text("Swimming").tag(ExerciseType.swimming)
                    Text("Cycling").tag(ExerciseType.cycling)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(achievements.filter { $0.type == selectedType }, id: \.id) { achievement in
                            AchievementCard(achievement: achievement)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Achievements")
            .onAppear {
                loadAchievements()
            }
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(achievement.isCompleted ? Color.green : Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)
                    
                    Text("\(achievement.level)")
                        .foregroundColor(.white)
                        .bold()
                }
                
                VStack(alignment: .leading) {
                    Text(achievement.title)
                        .font(.headline)
                    Text(achievement.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if achievement.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            
            ProgressView(value: achievement.currentProgress, total: achievement.targetProgress)
                .accentColor(achievement.isCompleted ? .green : .blue)
            
            Text("\(Int(achievement.currentProgress))/\(Int(achievement.targetProgress)) \(achievement.type == .swimming ? "km" : "km/h")")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView()
    }
}
