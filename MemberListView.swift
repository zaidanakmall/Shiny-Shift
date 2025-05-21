//
//  MemberListView.swift
//  ShinyShiftTwo
//
//  Created by Zaidan Akmal on 18/05/25.
//

import SwiftUI
import SwiftData

struct MemberListView: View {
    @Environment(\.modelContext) private var context
    @Query private var members: [Member]
    @Binding var selectedMember: Member?
    
    @State private var searchText = ""
    @State private var sortType: SortType = .nameAscending
    @State private var isSelecting = false
    @State private var selectedMembers = Set<Member>()
    @State private var showDeleteAlert = false

    enum SortType {
        case nameAscending, nameDescending, activeFirst, inactiveFirst
    }

    private var filteredMembers: [Member] {
        let filtered = members.filter {
            searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
        }
        switch sortType {
        case .nameAscending:
            return filtered.sorted { $0.name < $1.name }
        case .nameDescending:
            return filtered.sorted { $0.name > $1.name }
        case .activeFirst:
            return filtered.sorted { $0.isActive && !$1.isActive }
        case .inactiveFirst:
            return filtered.sorted { !$0.isActive && $1.isActive }
        }
    }

    var body: some View {
        VStack {
            searchAndSortMenu
            if isSelecting { selectionActionButtons }
            memberList
        }
        .scrollContentBackground(.hidden)
        .background(Color.secondaryGreen)
        .foregroundStyle(.primaryGreen)
        .alert("Delete selected members?", isPresented: $showDeleteAlert, actions: {
            Button("Delete", role: .destructive) {
                for member in selectedMembers {
                    context.delete(member)
                }
                try? context.save()
                selectedMembers.removeAll()
                isSelecting = false
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Are you sure you want to delete \(selectedMembers.count) member(s)? This action cannot be undone.")
        })
    }

    private var searchAndSortMenu: some View {
        HStack {
            TextField("Search member...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.leading)

            Menu {
                Button("Sort by Name (A-Z)") { sortType = .nameAscending }
                Button("Sort by Name (Z-A)") { sortType = .nameDescending }
                Divider()
                Button("Sort by Active First") { sortType = .activeFirst }
                Button("Sort by Inactive First") { sortType = .inactiveFirst }
                Divider()
                Button(isSelecting ? "Cancel Selection" : "Multiple Delete", role: .destructive) {
                    isSelecting.toggle()
                    selectedMembers.removeAll()
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
                    .padding(.horizontal)
            }
        }
        .padding(.top)
    }

    private var selectionActionButtons: some View {
        HStack(spacing: 20) {
            Button(action: {
                showDeleteAlert = true
            }) {
                Label("Delete", systemImage: "trash")
                    .foregroundColor(selectedMembers.isEmpty ? .gray : .white)
                    .padding()
                    .background(selectedMembers.isEmpty ? Color.gray.opacity(0.5) : Color.red)
                    .cornerRadius(10)
            }
            .disabled(selectedMembers.isEmpty)

            Button(action: {
                isSelecting = false
                selectedMembers.removeAll()
            }) {
                Label("Cancel", systemImage: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
    }

    private var memberList: some View {
        List(filteredMembers, id: \.self) { member in
            Button {
                if isSelecting {
                    if selectedMembers.contains(member) {
                        selectedMembers.remove(member)
                    } else {
                        selectedMembers.insert(member)
                    }
                } else {
                    selectedMember = member
                }
            } label: {
                HStack(spacing: 12) {
                    memberPhoto(for: member)
                    VStack(alignment: .leading, spacing: 5) {
                        Text(member.name)
                            .font(.headline)
                        Text(member.phone)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Circle()
                        .fill(member.isActive ? Color.green : Color.red)
                        .frame(width: 10, height: 10)

                    if isSelecting {
                        Image(systemName: selectedMembers.contains(member) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedMembers.contains(member) ? .green : .gray)
                    }
                }
                .padding(.vertical)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            selectedMembers.contains(member) || selectedMember?.id == member.id
                            ? Color.darkGreen.opacity(0.7)
                            : Color.secondaryGreen
                        )
                )
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .buttonStyle(.plain)
        }
        .listStyle(.plain)
    }

    private func memberPhoto(for member: Member) -> some View {
        Group {
            if let data = member.photo, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("Man")
                    .resizable()
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 50, height: 50)
        .clipShape(Circle())
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Member.self, configurations: config)
    
    return MemberListView(selectedMember: .constant(nil))
        .modelContainer(container)
}


