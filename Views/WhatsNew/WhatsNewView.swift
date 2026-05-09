//
//  WhatsNewView.swift
//  Minestagram
//

import SwiftUI

struct WhatsNewView: View {
    var onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("What’s New")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.primary)

                    Group {
                        whatsNewRow(
                            title: "Offline photos",
                            detail: "Cached images load from your device when you are offline."
                        )
                        whatsNewRow(
                            title: "Map & EXIF",
                            detail: "GPS from cached images appears on the map with quick directions."
                        )
                        whatsNewRow(
                            title: "Videos",
                            detail: "Stream curated clips with a full-screen player."
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Dismiss") {
                        onDismiss()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func whatsNewRow(title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    WhatsNewView(onDismiss: {})
}
