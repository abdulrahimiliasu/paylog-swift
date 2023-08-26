//
//  ProfileStore.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 23..
//

import Combine
import Foundation
import Supabase

@MainActor
class ProfileStore: ObservableObject {
    @Published var userProfile: UserProfile? = nil
    @Published public var user: User? = nil

    let repository: SupabaseRepository

    init() { self.repository = SupabaseRepository.getInstance(supabaseClient) }

    func loadCurrentUser() async {
        guard let user = await self.repository.getCurrentUser() else { return }
        await self.setUser(to: user)
    }

    func updateUserProfile(to profile: UserProfile) async {
        await self.repository.updateUserProfile(to: profile)
        self.userProfile = profile
    }

    func setUser(to user: User) async {
        self.user = user
        guard let userProfile = await self.repository.getCurrentUserProfile(userId: user.id) else { return }
        self.userProfile = userProfile
    }

    func resetUser() {
        self.user = nil
        self.userProfile = nil
    }
}
