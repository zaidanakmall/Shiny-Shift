//
//  ContentView.swift
//  ShinyShiftTwo
//
//  Created by Zaidan Akmal on 18/05/25.
//

import SwiftUI
import SwiftData

enum PageSelection {
    case member
    case generate
}

struct ContentView: View {
    @State private var selectedMember: Member?
    @State private var showAddMember = false
    @State private var selectedPage: PageSelection? = .member
    
    var body: some View {
        NavigationSplitView {
            VStack(alignment: .leading) {
                Text("ShinyShift")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .foregroundStyle(.primaryGreen)
                List(selection: $selectedPage) {
                    // Pilihan menu di sidebar
                    NavigationLink(value: PageSelection.member) {
                        Label("Member", systemImage: "person.3.fill")
                    }
                    NavigationLink(value: PageSelection.generate) {
                        Label("Generate", systemImage: "wand.and.stars")
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.secondaryGreen.opacity(0.5))
            }
            .background(Color.secondaryGreen.opacity(0.5))
        } content: {
            switch selectedPage {
            case .member:
                VStack {
                    HStack {
                        Text("Member")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading)
                            .foregroundStyle(.primaryGreen)
                        Spacer()
                    }

                    MemberListView(selectedMember: $selectedMember)

                    Button {
                        showAddMember = true
                    } label: {
                        Label("Add Member", systemImage: "plus.square.dashed")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(.secondaryGreen)
                            .background(Color.primaryGreen)
                    }
                    .padding()
                    .sheet(isPresented: $showAddMember) {
                        AddMemberView(member: nil)
                    }
                }
                .background(Color.secondaryGreen)

            case .generate:
                VStack {
                    Spacer()
                    Text("Generate View")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .padding()
                    Spacer()
                }
              

            case .none:
                EmptyView()
            }
        } detail: {
            if let member = selectedMember {
                DetailMemberView(member: member)
                    .id(member.id)
            } else {
                Text("Select or add new member")
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Member.self, configurations: config)
    let context = container.mainContext
    
    // Insert dummy member for preview
    let dummy = Member(name: "Default", phone: "08321678923", address: "Jakarta")
    context.insert(dummy)
    
    return ContentView()
        .modelContainer(container)
}


