import SwiftUI

struct HarvestLogView: View {
    @State private var entries: [HarvestEntry] = []
    @State private var date = Date()
    @State private var numberOfBees = ""
    @State private var notes = ""
    @State private var showSaved = false

    var body: some View {
        ScrollView {
            VStack(spacing: AppConstants.Spacing.lg) {
                // Entry Form
                GlassEffectContainer {
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                        Text("Log a Harvest")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        DatePicker("Date of Harvest", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .tint(Color(hex: "#865300"))
                            .foregroundStyle(.primary)

                        VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                            Text("Number of Bees Harvested")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            GlassInputField(
                                placeholder: "Enter number",
                                text: $numberOfBees,
                                keyboardType: .numberPad
                            )
                        }

                        VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                            Text("Notes (optional)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            GlassInputField(
                                placeholder: "Add notes...",
                                text: $notes,
                                isMultiline: true
                            )
                        }

                        Button(action: saveEntry) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Save Entry")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "#865300"), Color(hex: "#b87800")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                        }

                        if showSaved {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color(hex: "#865300"))
                                Text("Entry saved!")
                                    .foregroundStyle(.primary)
                                    .font(.caption)
                            }
                        }
                    }
                    .padding(AppConstants.Spacing.lg)
                    .glassEffect(in: .rect(cornerRadius: AppConstants.Radius.lg))
                }

                // Past Entries
                if !entries.isEmpty {
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
                        Text("Past Entries")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, AppConstants.Spacing.xs)

                        GlassEffectContainer {
                            VStack(spacing: AppConstants.Spacing.xs) {
                                ForEach(entries.reversed()) { entry in
                                    SwipeToDeleteRow {
                                        entryRow(entry: entry)
                                    } onDelete: {
                                        deleteEntry(id: entry.id)
                                    }
                                }
                            }
                            .padding(AppConstants.Spacing.sm)
                            .glassEffect(in: .rect(cornerRadius: AppConstants.Radius.lg))
                        }
                    }
                }
            }
            .padding(AppConstants.Spacing.md)
        }
        .background(.clear)
        .onAppear {
            entries = StorageService.shared.loadHarvestEntries()
        }
    }

    @ViewBuilder
    private func entryRow(entry: HarvestEntry) -> some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundStyle(.secondary)
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                Spacer()
                HStack(spacing: AppConstants.Spacing.xs) {
                    Image(systemName: "hexagon.fill")
                        .foregroundStyle(Color(hex: "#865300"))
                        .font(.caption)
                    Text("\(entry.numberOfBees) cocoons")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "#865300"))
                }
            }
            if !entry.notes.isEmpty {
                Text(entry.notes)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(AppConstants.Spacing.sm)
        .background(.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))
    }

    private func deleteEntry(id: UUID) {
        entries.removeAll { $0.id == id }
        StorageService.shared.saveHarvestEntries(entries)
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
