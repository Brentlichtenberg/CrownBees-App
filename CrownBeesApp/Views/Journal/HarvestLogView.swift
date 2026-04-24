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
                VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                    Text("Log a Harvest")
                        .font(.headline)
                        .foregroundStyle(AppConstants.secondary)

                    DatePicker("Date of Harvest", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .foregroundStyle(AppConstants.onSurface)

                    VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                        Text("Number of Bees Harvested")
                            .font(.caption)
                            .foregroundStyle(AppConstants.onSurfaceVariant)
                        TextField("Enter number", text: $numberOfBees)
                            .keyboardType(.numberPad)
                            .padding(AppConstants.Spacing.sm)
                            .background(AppConstants.surfaceContainerLow)
                            .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))
                            .overlay(
                                RoundedRectangle(cornerRadius: AppConstants.Radius.md)
                                    .stroke(AppConstants.onSurface.opacity(0.12), lineWidth: 1)
                            )
                    }

                    VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                        Text("Notes (optional)")
                            .font(.caption)
                            .foregroundStyle(AppConstants.onSurfaceVariant)
                        TextField("Add notes...", text: $notes, axis: .vertical)
                            .lineLimit(3...6)
                            .padding(AppConstants.Spacing.sm)
                            .background(AppConstants.surfaceContainerLow)
                            .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))
                            .overlay(
                                RoundedRectangle(cornerRadius: AppConstants.Radius.md)
                                    .stroke(AppConstants.onSurface.opacity(0.12), lineWidth: 1)
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
                                colors: [AppConstants.primary, AppConstants.primaryContainer],
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
                                .foregroundStyle(AppConstants.secondary)
                            Text("Entry saved!")
                                .foregroundStyle(AppConstants.secondary)
                                .font(.caption)
                        }
                    }
                }
                .padding(AppConstants.Spacing.lg)
                .background(AppConstants.surfaceContainerLowest)
                .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.lg))
                .shadow(color: AppConstants.shadowColor.opacity(0.06), radius: 20, x: 0, y: 6)

                // Past Entries
                if !entries.isEmpty {
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.sm) {
                        Text("Past Entries")
                            .font(.headline)
                            .foregroundStyle(AppConstants.secondary)

                        ForEach(entries.reversed()) { entry in
                            entryRow(entry: entry)
                        }
                    }
                    .padding(AppConstants.Spacing.lg)
                    .background(AppConstants.surfaceContainerLowest)
                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.lg))
                    .shadow(color: AppConstants.shadowColor.opacity(0.06), radius: 20, x: 0, y: 6)
                }
            }
            .padding(AppConstants.Spacing.md)
        }
        .background(AppConstants.surface)
        .onAppear {
            entries = StorageService.shared.loadHarvestEntries()
        }
    }

    @ViewBuilder
    private func entryRow(entry: HarvestEntry) -> some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundStyle(AppConstants.secondary)
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(AppConstants.onSurface)
                Spacer()
                HStack(spacing: AppConstants.Spacing.xs) {
                    Image(systemName: "hexagon.fill")
                        .foregroundStyle(AppConstants.primary)
                        .font(.caption)
                    Text("\(entry.numberOfBees) cocoons")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(AppConstants.secondary)
                        .padding(.horizontal, AppConstants.Spacing.sm)
                        .padding(.vertical, AppConstants.Spacing.xs)
                        .background(AppConstants.secondaryContainer)
                        .clipShape(Capsule())
                }
            }
            if !entry.notes.isEmpty {
                Text(entry.notes)
                    .font(.caption)
                    .foregroundStyle(AppConstants.onSurfaceVariant)
            }
        }
        .padding(AppConstants.Spacing.sm)
        .background(AppConstants.surfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))
        .shadow(color: AppConstants.shadowColor.opacity(0.04), radius: 8, x: 0, y: 2)
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
