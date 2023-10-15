//
//  FlowView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 24..
//

import SwiftUI

struct EditFlowRowView: View {
    @EnvironmentObject var planStore: PlanStore
    @State private var isEditMode: Bool = false
    @Binding var flowToEdit: Flow

    let currency: String

    func toggleEditMode() {
        isEditMode.toggle()
        HapticsManager.impact(.soft)
    }

    func didCheck() {
        flowToEdit.isChecked.toggle()
        HapticsManager.impact(.medium)
    }

    var body: some View {
        HStack {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: flowToEdit.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .onTapGesture { didCheck() }
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(flowToEdit.title)")
                    Text("\(getPricePrefix(flow: flowToEdit, currency: currency)) \(flowToEdit.price)")
                        .foregroundColor(getPriceForeGroundColor(flowToEdit))
                        .font(.subheadline)
                }
                .strikethrough(flowToEdit.isChecked)
            }
            .foregroundColor(flowToEdit.isChecked ? .gray : .primary)
            Spacer()
            Button("Edit", systemImage: "pencil") { toggleEditMode() }
                .labelStyle(.iconOnly)
        }
        .sheet(isPresented: $isEditMode, content: {
            EditFlowView(currency: currency, flowToEdit: $flowToEdit, isEditMode: $isEditMode)
                .presentationBackground(.ultraThinMaterial)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(30)
        })
        .onTapGesture { toggleEditMode() }
        .contentShape(Rectangle())
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button { flowToEdit.isChecked.toggle() } label: {
                Image(systemName: "checkmark.circle.fill")
            }
            .tint(.accentColor)
        }
        .contextMenu(menuItems: {
            Button { toggleEditMode() } label: {
                Label("Edit", systemImage: "pencil")
            }
            Button { didCheck() } label: {
                Label(flowToEdit.isChecked ? "Mark as new" : "Mark as done", systemImage: flowToEdit.isChecked ? "circle" : "checkmark.circle.fill")
            }
        })
    }
}

struct EditFlowView: View {
    let currency: String
    @Binding var flowToEdit: Flow
    @Binding var isEditMode: Bool

    var body: some View {
        VStack(spacing: 20) {
            VStack {
                TextField("Title", text: $flowToEdit.title, prompt: Text("Title"))
                    .font(.title)
                    .padding(10)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 10))
                TextField("Amount", value: $flowToEdit.price, formatter: getNumberFormatter(currency: currency))
                    .keyboardType(.numbersAndPunctuation)
                    .font(.title2)
                    .padding(10)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 10))
            }
            FlowTypePickerView(flow: $flowToEdit)
            Button(action: {
                isEditMode.toggle()
                HapticsManager.impact(.soft)
            }, label: {
                Text("Finish")
                    .frame(height: 35)
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct FlowView_Previews: PreviewProvider {
    static var previews: some View {
        EditFlowRowView(flowToEdit: .constant(Flow(title: "Expense", price: 1000, isChecked: false)), currency: "$")
            .environmentObject(PlanStore())
    }
}
