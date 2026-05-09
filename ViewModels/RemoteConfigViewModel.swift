//
//  RemoteConfigViewModel.swift
//  Minestagram
//

import Foundation

@MainActor
final class RemoteConfigViewModel: ObservableObject {
    @Published var presentWhatsNew: Bool = false

    private let service: RemoteConfigServiceProtocol

    init(service: RemoteConfigServiceProtocol = RemoteConfigService()) {
        self.service = service
    }

    func refreshWhatsNewFlag() async {
        do {
            let show = try await service.fetchAndActivateShowWhatsNew()
            presentWhatsNew = show
        } catch {
            // Requirement: default `true` when Remote Config is unavailable.
            presentWhatsNew = true
        }
    }

    func dismissWhatsNew() {
        presentWhatsNew = false
    }
}
