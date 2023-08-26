//
//  Configs.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 08. 12..
//

import Foundation

import Supabase

let supabaseClient = SupabaseClient(
    supabaseURL: URL(string: "https://ilsokbhzdxormzhddele.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlsc29rYmh6ZHhvcm16aGRkZWxlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTEyNDgxOTgsImV4cCI6MjAwNjgyNDE5OH0.F5JYmQBS4--n_ErrsTkNGoFCH9tqP5wjx4eV8wuD-1M")

let supabaseTables = (profiles: "profiles", plans: "plans", flows: "flows")
