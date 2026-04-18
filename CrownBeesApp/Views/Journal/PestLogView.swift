import SwiftUI

struct PestLogView: View {
    @State private var entries: [PestEntry] = []
    @State private var date = Date()
    @State private var pestType: PestType = .mites
    @State private var severity: PestSeverity = .low
    @State private var notes = ""
    @State private var showSaved = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Entry Form
                VStack(alignment: .leading, spacing: 16) {
                    Text("Log a Pest Observation")
                        .font(.headline)
                        .foregroundColor(AppConstants.darkGreen)
                    
                    DatePicker("Date Observed", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .foregroundColor(AppConstants.darkText)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Pest Type")
                            .font(.caption)
                            .foregroundColor(AppConstants.darkText.opacity(0.7))
                        Picker("Pest Type", selection: $pestType) {
                            ForEach(PestType.allCases, id: \.self) { pest in
                                Text(pest.rawValue).tag(pest)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Severity")
                            .font(.caption)
                            .foregroundColor(AppConstants.darkText.opacity(0.7))
                        Picker("Severity", selection: $severity) {
                            ForEach(PestSeverity.allCases, id: \.self) { sev in
                                Text(sev.rawValue).tag(sev)
                            }
                        }
                        .pickerStyle(.segmented)
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
                        .background(AppConstants.navyBlue)
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
                            .foregroundColor(AppConstants.darkGreen)
                        
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
        .background(AppConstants.beige)
        .onAppear {
            entries = StorageService.shared.loadPestEntries()
        }
    }
    
    @ViewBuilder
    private func entryRow(entry: PestEntry) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(AppConstants.navyBlue)
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppConstants.darkText)
                Spacer()
                severityBadge(entry.severity)
            }
            HStack(spacing: 8) {
                Label(entry.pestType.rawValue, systemImage: "ant.fill")
                    .font(.caption)
                    .foregroundColor(AppConstants.darkText)
            }
            if !entry.notes.isEmpty {
                Text(entry.notes)
                    .font(.caption)
                    .foregroundColor(AppConstants.darkText.opacity(0.7))
            }
        }
        .padding(12)
        .background(AppConstants.beige)
        .cornerRadius(10)
        Divider()
    }
    
    @ViewBuilder
    private func severityBadge(_ severity: PestSeverity) -> some View {
        Text(severity.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(severityColor(severity).opacity(0.2))
            .foregroundColor(severityColor(severity))
            .cornerRadius(8)
    }
    
    private func severityColor(_ severity: PestSeverity) -> Color {
        switch severity {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    private func saveEntry() {
        let entry = PestEntry(date: date, pestType: pestType, severity: severity, notes: notes)
        entries.append(entry)
        StorageService.shared.savePestEntries(entries)
        notes = ""
        date = Date()
        pestType = .mites
        severity = .low
        showSaved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showSaved = false
        }
    }
}
