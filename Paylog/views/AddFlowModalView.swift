//
//  AddEditFlowView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 29..
//

import SwiftUI

enum Fields {
    case title, desc
}

struct AddFlowModalView: View {
    @EnvironmentObject var flowModal: FlowModalStore
    @EnvironmentObject var planStore: PlanStore
    @FocusState private var focusedField: Fields?
    @State private var modalPosition: CGSize = .zero

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Button("Cancel") {
                    flowModal.toggleIsPresented()
                }
                Spacer()
                Button("Done") {
                    // Save Flow
                    flowModal.toggleIsPresented()
                }
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            VStack {
                TextField("Title", text: $flowModal.activeFlow.title)
                    .font(.title)
                    .focused($focusedField, equals: .title)
                TextField("Price", value: $flowModal.activeFlow.price, formatter: NumberFormatter())
                    .font(.callout)
                    .focused($focusedField, equals: .desc)
                Picker(selection: $flowModal.activeFlow.type, label: Text("type")) {
                    Text("Expense").tag(FlowType.expense)
                    Text("Normal").tag(FlowType.normal)
                    Text("Income").tag(FlowType.income)
                }
                .foregroundColor(.red)
                .pickerStyle(.segmented)
            }
        }
        .onAppear { if flowModal.isPresented { focusedField = .title } }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(20)
        .offset(x: 0, y: modalPosition.height)
        .gesture(
            DragGesture()
                .onEnded { _ in
                    withAnimation(springAnimation) {
                        self.modalPosition = .zero
                    }
                }
                .onChanged { val in
                    if val.translation.height < -200 { return }
                    if val.translation.height > 100 {
                        // Below
                        return
                    }
                    withAnimation(springAnimation) { self.modalPosition = val.translation }
                })
        .offset(x: 0, y: flowModal.isPresented ? screen.height / 100 : screen.height)
    }
}

struct AddEditFlowView_Previews: PreviewProvider {
    static var previews: some View {
        AddFlowModalView()
            .environmentObject(PlanStore())
            .environmentObject(FlowModalStore())
    }
}
