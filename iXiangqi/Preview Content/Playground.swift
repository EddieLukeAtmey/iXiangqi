//
//  Playground.swift
//  iXiangqi
//
//  Created by Eddie Luke Atmey on 16/11/25.
//

import SwiftUI

struct Playground: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ParentView()
}

// Source - https://stackoverflow.com/q/79181523
// Posted by Vitaliy
// Retrieved 2025-11-16, License - CC BY-SA 4.0

import SwiftUI

class SharedData: ObservableObject {
    @Published var counter: Int = 0
}

// Source - https://stackoverflow.com/a/79181576
// Posted by ITGuy
// Retrieved 2025-11-16, License - CC BY-SA 4.0

struct ParentView: View {
    @StateObject private var data = SharedData()

    var body: some View {
        VStack {
            CounterView()
            AnotherView(data: $data.counter)
            AnotherView2(data: $data.counter)
        }.environmentObject(data)
    }
}

struct CounterView: View {
    @EnvironmentObject var data: SharedData

    var body: some View {
        VStack {
            Text("Counter: \(data.counter)")
            Button("Increment Counter") {
                data.counter += 1
            }
        }
    }
}

struct AnotherView: View {
    @Binding var data: Int

    var body: some View {
        Text("Another View Counter: \(data)")
    }
}

struct AnotherView2: View {
    @Binding var data: Int

    var body: some View {
        Text("Another View Counter: \(data)")
    }
}

