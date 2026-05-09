//
//  ProfileHeaderView.swift
//  Minestagram
//

import SwiftUI

struct ProfileHeaderView: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 16) {
                avatar
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name ?? "Unknown name")
                        .font(.title2.bold())
                        .foregroundStyle(.primary)
                    if let company = user.company {
                        Text(company)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer(minLength: 0)
            }

            if let bio = user.bio, !bio.isEmpty {
                Text(bio)
                    .font(.body)
                    .foregroundStyle(.primary)
            }
        }
    }

    @ViewBuilder
    private var avatar: some View {
        Group {
            if let urlString = user.avatarURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        placeholderAvatar
                    @unknown default:
                        placeholderAvatar
                    }
                }
            } else {
                placeholderAvatar
            }
        }
        .frame(width: 88, height: 88)
        .clipShape(Circle())
        .overlay {
            Circle().strokeBorder(Color(.separator), lineWidth: 1)
        }
    }

    @ViewBuilder
    private var placeholderAvatar: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.secondary)
    }
}

#Preview {
    ProfileHeaderView(
        user: User(
            id: 1,
            avatarURL: nil,
            name: "Sample User",
            company: "Acme",
            bio: "Building Minestagram."
        )
    )
    .padding()
}
