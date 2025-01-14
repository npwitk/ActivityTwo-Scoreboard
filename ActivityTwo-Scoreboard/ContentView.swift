//
//  ContentView.swift
//  ActivityTwo-Scoreboard
//
//  Created by Nonprawich I. on 13/01/2025.
//

import SwiftUI

struct ContentView: View {
    enum Game: String, CaseIterable {
        case telephonePictionary = "Telephone Pictionary"
        case oneWord = "One Word"
    }
    
    @State private var selectedGame: Game = .telephonePictionary
    @State private var scores = Array(repeating: 0.0, count: 5)
    @State private var teamNames = Array(repeating: "", count: 5)
    
    var rankings: [(index: Int, score: Double, name: String)] {
        let teams = zip(0..<5, zip(scores, teamNames)).map { (index, scoreAndName) in
            (index: index, score: scoreAndName.0, name: scoreAndName.1.isEmpty ? "Team \(index + 1)" : scoreAndName.1)
        }
        return teams.sorted { $0.score > $1.score }
    }
    
    func rankSymbol(for rank: Int) -> String {
        switch rank {
        case 1: return "crown.fill"
        case 2: return "medal.fill"
        case 3: return "medal.fill"
        case 4: return "4.circle.fill"
        case 5: return "5.circle.fill"
        default: return "questionmark.circle.fill"
        }
    }
    
    func rankColor(for rank: Int) -> Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .brown
        default: return .gray.opacity(0.7)
        }
    }
    
    var body: some View {
        NavigationStack {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(0..<5) { index in
                    TeamScoreView(
                        teamNumber: index + 1,
                        score: $scores[index],
                        teamName: $teamNames[index],
                        gameType: selectedGame
                    )
                }
                
                // Leaderboard Here
                VStack(spacing: 16) {
                    Text("Leaderboard")
                        .font(.system(size: 52, weight: .bold))
                        .padding()
                    
                    ForEach(rankings.prefix(5), id: \.index) { team in
                        let rank = rankings.firstIndex(where: { $0.index == team.index })! + 1
                        HStack {
                            Image(systemName: rankSymbol(for: rank))
                                .font(.largeTitle)
                                .foregroundColor(rankColor(for: rank))
                                .frame(width: 40)
                                .padding(.horizontal)
                            
                            Text(team.name)
                                .font(.title)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text(String(format: team.score.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f" : "%.1f", team.score))
                                .font(.title.bold())
                                .contentTransition(.numericText(value: team.score))
                                .animation(.snappy, value: team.score)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)
            }
            .padding()
            .navigationTitle("Score Tracker")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    
                    Picker("Select Game", selection: $selectedGame) {
                        ForEach(Game.allCases, id: \.self) { game in
                            Text(game.rawValue).tag(game)
                        }
                    }
                    .pickerStyle(.menu)
                    .font(.title2)
                    
                    Button(action: {
                        scores = Array(repeating: 0.0, count: 5)
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title2)
                    }
                    
                }
            
            }
        }
    }
}

struct TeamScoreView: View {
    let teamNumber: Int
    @Binding var score: Double
    @Binding var teamName: String
    let gameType: ContentView.Game
    
    var formattedScore: String {
        score.truncatingRemainder(dividingBy: 1) == 0
        ? String(format: "%.0f", score)
        : String(format: "%.1f", score)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                TextField("Team Name", text: $teamName)
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    score = 0
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(.gray)
                }
            }
            
            Text("TEAM \(teamNumber)")
                .font(.caption)
                .foregroundColor(.gray)
                .textCase(.uppercase)
            
            Text(formattedScore)
                .font(.system(size: 200, weight: .bold))
                .contentTransition(.numericText(value: score))
                .animation(.snappy, value: score)
                .frame(height: 350)
            
            if gameType == .telephonePictionary {
                Button("+3") {
                    score += 3
                }
                .buttonStyle(ScoreButtonStyle())
            } else {
                HStack(spacing: 12) {
                    Button("+4") {
                        score += 4
                    }
                    Button("+3") {
                        score += 3
                    }
                    Button("+2") {
                        score += 2
                    }
                    Button("+1") {
                        score += 1
                    }
                    Button("+0.5") {
                        score += 0.5
                    }
                    
                }
                .buttonStyle(ScoreButtonStyle())
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
}

struct ScoreButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
    }
}

#Preview {
    ContentView()
}
