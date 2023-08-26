//
//  SupabaseRepository.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 08. 12..
//

import Foundation
import Supabase

class SupabaseRepository: ObservableObject {
    public static var _instance: SupabaseRepository? = nil
    public let client: SupabaseClient

    private init(_ client: SupabaseClient) { self.client = client }

    func getCurrentUser() async -> User? {
        do { return try await self.client.auth.session.user }
        catch {
            print("An Error has occured getting user: \(error)")
            return nil
        }
    }

    func createNewAccount(email: String, password: String, fullname: String) async throws -> User {
        do {
            try await self.client.auth.signUp(email: email, password: password)
            let user = try await self.client.auth.session.user
            try await self.client.database.from(supabaseTables.profiles).insert(values: UserProfile(userId: user.id, fullname: fullname), returning: .representation).execute()
            return user
        } catch {
            print("Sign Up Error: \(error)")
            throw error
        }
    }

    func signInUser(email: String, password: String) async throws -> User {
        do {
            try await self.client.auth.signIn(email: email, password: password)
            let user = try await self.client.auth.session.user
            return user
        } catch {
            print("Sign In Error: \(error)")
            throw error
        }
    }

    func signOutUser() async {
        do {
            try await self.client.auth.signOut()
        } catch {
            print("Sign Out Error: \(error)")
        }
    }

    func getCurrentUserProfile(userId: UUID) async -> UserProfile? {
        do {
            let userProfile: UserProfile = try await self.client.database.from(supabaseTables.profiles).select().eq(column: "user_id", value: userId).single().execute().value
            return userProfile
        } catch {
            print("An Error has occured loading profile for \(userId): \(error)")
            return nil
        }
    }

    func getUserPlans(userId: UUID) async throws -> [Plan] {
        do {
            let plans: [PlanRow] = try await self.client.database.from(supabaseTables.plans)
                .select(columns: "id, user_id, title, description, currency, flows: id (*)")
                .eq(column: "user_id", value: userId).execute().value

            return EntityToModelMapper.mapPlansToModel(plans)
        } catch {
            print("An Error has occured loading user plans for \(userId.uuidString): \(error)")
            throw error
        }
    }

    func getPlanFlows(plan: Plan) async throws -> [Flow] {
        do {
            let flows: [FlowRow] = try await self.client.database.from(supabaseTables.flows).select().eq(column: "plan_id", value: plan.id).execute().value
            return EntityToModelMapper.mapFlowsToModel(flows)
        } catch {
            print("An Error has occured loading flows for \(plan.id): \(error)")
            throw error
        }
    }

    func updateUserProfile(to profile: UserProfile) async {
        do {
            try await self.client.database.from(supabaseTables.profiles).update(values: profile).eq(column: "user_id", value: profile.userId).execute()
        } catch {
            print("User Profile update Error: \(error)")
        }
    }

    func addPlan(userId: UUID, plan: Plan) async throws -> Plan {
        let planToInsert = EntityToModelMapper.mapPlanToInsertEntity(userId: userId, plan: plan)
        do {
            try await self.client.database.from(supabaseTables.plans).insert(values: planToInsert, returning: .representation).execute()
            let _ = try await self.addFlows(planId: planToInsert.id, flows: plan.flows)
            return plan
        } catch {
            print("An Error has occured: \(error)")
            throw error
        }
    }

    func addFlows(planId: UUID, flows: [Flow]) async throws -> [Flow] {
        let flowsToInsert = EntityToModelMapper.mapFlowsToEntity(planId: planId, flows: flows)
        do {
            try await self.client.database.from(supabaseTables.flows).insert(values: flowsToInsert).execute()
            return flows
        } catch {
            print("An Error has occured: \(error)")
            throw error
        }
    }

    func updatePlan(userId: UUID, plan: Plan) async throws {
        let planToUpdate = EntityToModelMapper.mapPlanToInsertEntity(userId: userId, plan: plan)
        do {
            try await self.client.database.from(supabaseTables.plans).update(values: planToUpdate).eq(column: "id", value: planToUpdate.id).execute()
        } catch {
            print("An Error has occured: \(error)")
            throw error
        }
    }

    func updateFlow(planId: UUID, flow: Flow) async throws {
        let flowToUpdate = EntityToModelMapper.mapFlowsToEntity(planId: planId, flows: [flow]).first!
        do {
            try await self.client.database.from(supabaseTables.flows).update(values: flowToUpdate).eq(column: "id", value: flowToUpdate.id).execute()
        } catch {
            print("An Error has occured: \(error)")
            throw error
        }
    }

    func updateFlows(planId: UUID, flows: [Flow]) async throws {
        let flowToUpsert = EntityToModelMapper.mapFlowsToEntity(planId: planId, flows: flows)
        do {
            try await self.client.database.from(supabaseTables.flows).upsert(values: flowToUpsert).execute()
        } catch {
            print("An Error has occured: \(error)")
            throw error
        }
    }

    func deletePlan(planId: UUID) async throws {
        do {
            try await self.client.database.from(supabaseTables.plans).delete().eq(column: "id", value: planId).execute()
        } catch {
            print("Could not delete plan!, Error: \(error.localizedDescription)")
            throw error
        }
    }

    func deleteFlow(flowId: UUID) async throws {
        do {
            try await self.client.database.from(supabaseTables.flows).delete().eq(column: "id", value: flowId).execute()
        } catch {
            print("Could not delete flow!, Error: \(error)")
            throw error
        }
    }

    public static func getInstance(_ client: SupabaseClient) -> SupabaseRepository {
        if let instance = SupabaseRepository._instance { return instance }
        let singleton = SupabaseRepository(client)
        SupabaseRepository._instance = singleton
        return singleton
    }
}
