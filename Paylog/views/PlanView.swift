//
//  PlanView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 23..
//

import SwiftUI

enum PlanViewTextFields: Hashable {
    case title, description, modalTitle, modalPrice
}

struct PlanView: View {
    @Binding var plan: Plan
    @EnvironmentObject var planStore: PlanStore
    @EnvironmentObject var supabaseRepository: SupabaseRepository

    @FocusState private var currentTextFieldFocus: PlanViewTextFields?
    @State private var isFlowModalPresented: Bool = false

    func deleteFlow(flowId: UUID) async {
        await withAlert {
            try await supabaseRepository.deleteFlow(flowId: flowId)
        }
    }

    var body: some View {
        GeometryReader { _ in
            Form {
                Section("Plan Details") {
                    TextField("Title", text: $plan.title)
                        .font(.headline)
                        .padding(.vertical, 5)
                        .focused($currentTextFieldFocus, equals: .title)
                        .onAppear { if !isFlowModalPresented { currentTextFieldFocus = .title } }
                        .onSubmit { currentTextFieldFocus = .description }
                    TextField("Description", text: $plan.description)
                        .font(.subheadline)
                        .lineLimit(10)
                        .multilineTextAlignment(.leading)
                        .focused($currentTextFieldFocus, equals: .description)
                }
                List {
                    ForEach($plan.flows) { $flow in
                        EditFlowRowView(flowToEdit: $flow)
                    }
                    .onDelete { indexSet in
                        let flowToRemove = plan.flows.remove(at: indexSet.first!)
                        Task { await deleteFlow(flowId: flowToRemove.id) }
                    }
                }
            }
            .blur(radius: isFlowModalPresented ? 1 : 0)
            .onTapGesture {
                guard isFlowModalPresented else { return }
                withAnimation(springAnimation) {
                    isFlowModalPresented.toggle()
                }
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            AddNewFlowToPlanView(plan: $plan, willAddNewFlow: $isFlowModalPresented, focusedField: $currentTextFieldFocus)
                .padding()
                .background(.thinMaterial)
        })
        .overlay {
            AddFlowModalView(plan: $plan, isFlowModalPresented: $isFlowModalPresented, focusedField: $currentTextFieldFocus)
                .padding(5)
        }
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView(plan: .constant(Plan(title: "Some Plan", description: "Some desc", flows: [Flow(title: "Bus Ticket", price: 1000, isChecked: false)])))
            .environmentObject(PlanStore())
            .environmentObject(SupabaseRepository.getInstance(supabaseClient))
    }
}
