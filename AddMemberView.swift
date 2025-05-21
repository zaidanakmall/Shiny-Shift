//
//  AddMemberView.swift
//  CleanPlot
//
//  Created by Frewin Saputra on 26/03/25.
//
import SwiftUI
import UIKit
import SwiftData

struct AddMemberView: View {
    
    let member: Member?
    private var editorTitle: String {
        member == nil ? "Tambah Anggota" : "Ubah Anggota"
    }
    private var photoTitle: String {
        member == nil ? "Tambah Foto" : "Ubah Foto"
    }
    
    @State private var name = ""
    @State private var address = ""
    @State private var phoneNumber = ""
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 100, maxHeight: 100)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(maxWidth: 100, maxHeight: 100)
                        .clipShape(Circle())
                }
                
                Button(action: { showImagePicker = true }) {
                    Text(photoTitle)
                        .bold()
                        .foregroundColor(.black)
                        .frame(width: 150, height: 50)
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(Capsule())
                        .padding()
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $selectedImage)
                }
                
                Form {
                    Section {
                        TextField("Name", text: $name)
                        TextField("Phone Number", text: $phoneNumber)
                            .keyboardType(.numberPad)
                        TextField("Address", text: $address)
                    }
                    .listRowBackground(Color.secondary.opacity(0.1))
                }
                .scrollContentBackground(.hidden)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                    .foregroundStyle(.black)
                }
                ToolbarItem(placement: .principal) {
                    Text(editorTitle)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    }
                    .foregroundStyle(.black)
                }
            }
            .onAppear {
                if let member {
                    name = member.name
                    phoneNumber = member.phone
                    address = member.address
                }
            }
        }
    }
    
    private func save() {
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        
        if let member {
            member.name = name
            member.phone = phoneNumber
            member.address = address
            member.isActive = true
            member.photo = imageData
            
            do {
                try modelContext.save()
            } catch {
                print("Error saving assignments: \(error)")
            }
            
        } else {
            let newMember = Member(name: name, phone: phoneNumber, address: address)
            modelContext.insert(newMember)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Member.self, configurations: config)

    return AddMemberView(member: nil)
        .modelContainer(container)
}


