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
                GlassEffectContainer {
                    VStack(alignment: .leading, spacing: AppConstants.Spacing.md) {
                        Text("Log a Pest Observation")
                            .font(.headline)
                            .foregroundStyle(.white)

                        DatePicker("Date Observed", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .tint(Color(hex: "#865300"))
                            .foregroundStyle(.white)

                        // Pest Type chips
                        VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                            Text("Pest Type")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.75))
                            GlassEffectContainer {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: AppConstants.Spacing.sm) {
                                        ForEach(PestType.allCases, id: \.self) { pest in
                                            Button {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                                    pestType = pest
                                                }
                                            } label: {
                                                Text(pest.rawValue)
                                                    .font(.subheadline.weight(.medium))
                                                    .padding(.horizontal, AppConstants.Spacing.md)
                                                    .padding(.vertical, AppConstants.Spacing.sm)
                                                    .foregroundStyle(pestType == pest ? Color(hex: "#865300") : .white.opacity(0.85))
                                                    .glassEffect(in: .capsule)
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Severity chips
                        VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
                            Text("Severity")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.75))
                            GlassEffectContainer {
                                HStack(spacing: AppConstants.Spacing.sm) {
                                    ForEach(PestSeverity.allCases, id: \.self) { sev in
                                        Button {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                                severity = sev
                                            }
                                        } label: {
                                            Text(sev.rawValue)
                                                .font(.subheadline.weight(.medium))
                                                .padding(.horizontal, AppConstants.Spacing.md)
                                                .padding(.vertical, AppConstants.Spacing.sm)
                                                .foregroundStyle(severity == sev ? severitySelectedFg(sev) : .white.opacity(0.85))
                                                .glassEffect(in: .capsule)
                                        }
                                    }
                                }
                            }
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
            entries = StorageService.shared.loadPestEntries()
        }
    }

    @ViewBuilder
    private func entryRow(entry: PestEntry) -> some View {
        VStack(alignment: .leading, spacing: AppConstants.Spacing.xs) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundStyle(.white.opacity(0.7))
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                Spacer()
                severityBadge(entry.severity)
            }
            HStack(spacing: AppConstants.Spacing.sm) {
                Label(entry.pestType.rawValue, systemImage: "ant.fill")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.85))
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
        case .low:    return Color.green.opacity(0.25)
        case .medium: return Color(hex: "#865300").opacity(0.25)
        case .high:   return Color.red.opacity(0.25)
        }
    }

    private func severitySelectedFg(_ severity: PestSeverity) -> Color {
        switch severity {
        case .low:    return Color.green
        case .medium: return Color(hex: "#865300")
        case .high:   return Color.red
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
