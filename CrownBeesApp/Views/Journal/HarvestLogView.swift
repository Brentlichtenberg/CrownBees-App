import SwiftUI

struct HarvestLogView: View {
    @State private var entries: [HarvestEntry] = []
    @State private var date = Date()
    @State private var numberOfBees = ""
    @State private var notes = ""
    @State private var showSaved = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Entry Form
                VStack(alignment: .leading, spacing: 16) {
                    Text("Log a Harvest")
                        .font(.headline)
                        .foregroundColor(AppConstants.forestGreen)
                    
                    DatePicker("Date of Harvest", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .foregroundColor(AppConstants.darkText)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Number of Bees Harvested")
                            .font(.caption)
                            .foregroundColor(AppConstants.darkText.opacity(0.7))
                        TextField("Enter number", text: $numberOfBees)
                            .keyboardType(.numberPad)
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notes (optional)")
                            .font(.caption)
                            .foregroundColor(AppConstants.darkText.opacity(0.7))
                        TextField("Add notes...", text: $notes, axis: .vertical)
                            .lineLimit(3...6)
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
                    }
                    
                    Button(action: saveEntry) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Entry")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppConstants.warmBrown)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    if showSaved {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Entry saved!")
                                .foregroundColor(.green)
                                .font(.caption)
                        }
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
                
                // Past Entries
                if !entries.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Past Entries")
                            .font(.headline)
                            .foregroundColor(AppConstants.forestGreen)
                        
                        ForEach(entries.reversed()) { entry in
                            entryRow(entry: entry)
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
                }
            }
            .padding(16)
        }
        .background(AppConstants.creamBackground)
        .onAppear {
            entries = StorageService.shared.loadHarvestEntries()
        }
    }
    
    @ViewBuilder
    private func entryRow(entry: HarvestEntry) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(AppConstants.warmBrown)
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppConstants.darkText)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "hexagon.fill")
                        .foregroundColor(AppConstants.honeyGold)
                        .font(.caption)
                    Text("\(entry.numberOfBees) bees")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppConstants.darkText)
                }
            }
            if !entry.notes.isEmpty {
                Text(entry.notes)
                    .font(.caption)
                    .foregroundColor(AppConstants.darkText.opacity(0.7))
            }
        }
        .padding(12)
        .background(AppConstants.creamBackground)
        .cornerRadius(10)
        Divider()
    }
    
    private func saveEntry() {
        guard let count = Int(numberOfBees), count > 0 else { return }
        let entry = HarvestEntry(date: date, numberOfBees: count, notes: notes)
        entries.append(entry)
        StorageService.shared.saveHarvestEntries(entries)
        numberOfBees = ""
        notes = ""
        date = Date()
        showSaved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showSaved = false
        }
    }
}
