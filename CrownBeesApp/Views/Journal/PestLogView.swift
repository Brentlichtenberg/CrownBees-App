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
            VStack(spacing: AppConstants.Spacing.lg) {
                // Entry Form
                VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                    Text("Log a Pest Observation")
                        .font(.headline)
                        .foregroundStyle(AppConstants.secondary)

                    DatePicker("Date Observed", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .foregroundStyle(AppConstants.onSurface)

                    // Pest Type — Pollinator chips
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                        Text("Pest Type")
                            .font(.caption)
                            .foregroundStyle(AppConstants.onSurfaceVariant)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppConstants.Spacing.sm) {
                                ForEach(PestType.allCases, id: \.self) { pest in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                            pestType = pest
                                        }
                                    }) {
                                        Text(pest.rawValue)
                                            .font(.subheadline.weight(.medium))
                                            .padding(.horizontal, AppConstants.Spacing.md)
                                            .padding(.vertical, AppConstants.Spacing.sm)
                                            .background(pestType == pest ? AppConstants.secondaryContainer : AppConstants.surfaceContainerHighest)
                                            .foregroundStyle(pestType == pest ? AppConstants.secondary : AppConstants.onSurfaceVariant)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }

                    // Severity — Pollinator chips
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                        Text("Severity")
                            .font(.caption)
                            .foregroundStyle(AppConstants.onSurfaceVariant)
                        HStack(spacing: AppConstants.Spacing.sm) {
                            ForEach(PestSeverity.allCases, id: \.self) { sev in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                        severity = sev
                                    }
                                }) {
                                    Text(sev.rawValue)
                                        .font(.subheadline.weight(.medium))
                                        .padding(.horizontal, AppConstants.Spacing.md)
                                        .padding(.vertical, AppConstants.Spacing.sm)
                                        .background(severity == sev ? severitySelectedBg(sev) : AppConstants.surfaceContainerHighest)
                                        .foregroundStyle(severity == sev ? severitySelectedFg(sev) : AppConstants.onSurfaceVariant)
                                        .clipShape(Capsule())
                                }
                            }
                        }
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
            entries = StorageService.shared.loadPestEntries()
        }
    }

    @ViewBuilder
    private func entryRow(entry: PestEntry) -> some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundStyle(AppConstants.secondary)
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(AppConstants.onSurface)
                Spacer()
                severityBadge(entry.severity)
            }
            HStack(spacing: AppConstants.Spacing.sm) {
                Label(entry.pestType.rawValue, systemImage: "ant.fill")
                    .font(.caption)
                    .foregroundStyle(AppConstants.onSurface)
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

    @ViewBuilder
    private func severityBadge(_ severity: PestSeverity) -> some View {
        Text(severity.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, AppConstants.Spacing.sm)
            .padding(.vertical, AppConstants.Spacing.xs)
            .background(severitySelectedBg(severity))
            .foregroundStyle(severitySelectedFg(severity))
            .clipShape(Capsule())
    }

    private func severitySelectedBg(_ severity: PestSeverity) -> Color {
        switch severity {
        case .low: return AppConstants.secondaryContainer
        case .medium: return AppConstants.primaryContainer.opacity(0.3)
        case .high: return Color.red.opacity(0.15)
        }
    }

    private func severitySelectedFg(_ severity: PestSeverity) -> Color {
        switch severity {
        case .low: return AppConstants.secondary
        case .medium: return AppConstants.primary
        case .high: return Color.red
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
