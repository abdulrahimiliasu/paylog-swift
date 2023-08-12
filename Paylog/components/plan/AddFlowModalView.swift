
//
//  AddEditFlowView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 29..
//

import SwiftUI

struct AddFlowModalView: View {
    @AppStorage("defaultCurrency") var defaultCurrency: String = SettingDefaults.currency
    @EnvironmentObject var planStore: PlanStore

    @State private var flowToAdd: Flow = .init(title: "", price: 0, isChecked: false)
    @State private var modalPosition: CGSize = .zero
    @Binding var plan: Plan
    @Binding var isFlowModalPresented: Bool

    var focusedField: FocusState<PlanViewTextFields?>.Binding

    func toggleIsModalPresented() {
        withAnimation(springAnimation) { isFlowModalPresented.toggle() }
        resetFlowToAdd()
    }

    func resetFlowToAdd() {
        flowToAdd = .init(title: "", price: 0, isChecked: false)
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                RoundButton(image: "xmark.circle.fill", action: toggleIsModalPresented)
                Spacer()
                Button("Done") {
                    plan.flows.append(Flow(title: flowToAdd.title, price: flowToAdd.price, isChecked: flowToAdd.isChecked, type: flowToAdd.type))
                    notificationHaptics.notificationOccurred(.success)
                    toggleIsModalPresented()
                }
                .disabled(flowToAdd.title == "")
            }

            VStack {
                TextField("Title", text: $flowToAdd.title)
                    .font(.title2)
                    .focused(self.focusedField, equals: .modalTitle)
                HStack {
                    Text(currencies[defaultCurrency]!)
                    TextField("Price", value: $flowToAdd.price, formatter: NumberFormatter())
                        .font(.callout)
                        .keyboardType(.numberPad)
                        .onSubmit {
                            self.focusedField.wrappedValue = .modalPrice
                        }
                        .focused(self.focusedField, equals: .modalPrice)
                }
                .foregroundColor(.secondary)
                Picker(selection: $flowToAdd.type, label: Text("type")) {
                    Text("Expense").tag(FlowType.expense)
                    Text("Normal").tag(FlowType.normal)
                    Text("Income").tag(FlowType.income)
                }
                .pickerStyle(.segmented)
            }
        }
        .padding(20)
        .background(.thinMaterial)
        .cornerRadius(5)
        .offset(x: 0, y: modalPosition.height)
        .offset(x: 0, y: isFlowModalPresented ? screen.height / 100 : screen.height)
        .opacity(isFlowModalPresented ? 1 : 0)
        .gesture(
            DragGesture()
                .onChanged { val in
                    if val.translation.height < -100 { return }
                    if val.translation.height > 140 {
                        withAnimation(springAnimation) { isFlowModalPresented = false }
                        resetFlowToAdd()
                    }
                    else { withAnimation(springAnimation) { self.modalPosition = val.translation } }
                }
                .onEnded { _ in withAnimation(springAnimation) { self.modalPosition = .zero } }
        )
    }
}

struct AddEditFlowView_Previews: PreviewProvider {
    static var previews: some View {
        AddFlowModalView(plan: .constant(previewDummyPlan), isFlowModalPresented: .constant(true), focusedField: FocusState<PlanViewTextFields?>().projectedValue)
            .environmentObject(PlanStore())
    }
}
