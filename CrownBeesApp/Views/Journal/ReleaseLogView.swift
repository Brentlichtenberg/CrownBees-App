import SwiftUI

struct ReleaseLogView: View {
    @State private var entries: [ReleaseEntry] = []
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
                        Text("Log a Bee Release")
                            .font(.headline)
                            .foregroundStyle(.white)

                        DatePicker("Date of Release", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .tint(Color(hex: "#865300"))
                            .foregroundStyle(.white)

                        VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                            Text("Number of Bees Released")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.75))
                            GlassInputField(
                                placeholder: "Enter number",
                                text: $numberOfBees,
                                keyboardType: .numberPad
                            )
                        }

                        VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                            Text("Notes (optional)")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.75))
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
                                    .foregroundStyle(.white)
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
                                    entryRow(entry: entry)
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
            entries = StorageService.shared.loadReleaseEntries()
        }
    }

    @ViewBuilder
    private func entryRow(entry: ReleaseEntry) -> some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundStyle(.white.opacity(0.7))
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                Spacer()
                HStack(spacing: AppConstants.Spacing.xs) {
                    Image(systemName: "hexagon.fill")
                        .foregroundStyle(Color(hex: "#865300"))
                        .font(.caption)
                    Text("\(entry.numberOfBees) bees")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "#865300"))
                }
            }
            if !entry.notes.isEmpty {
                Text(entry.notes)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.75))
            }
        }
        .padding(AppConstants.Spacing.sm)
        .background(.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.md))
    }

    private func saveEntry() {
        guard let count = Int(numberOfBees), count > 0 else { return }
        let entry = ReleaseEntry(date: date, numberOfBees: count, notes: notes)
        entries.append(entry)
        StorageService.shared.saveReleaseEntries(entries)
        numberOfBees = ""
        notes = ""
        date = Date()
        showSaved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showSaved = false
        }
    }
}
