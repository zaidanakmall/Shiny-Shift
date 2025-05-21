//
//  DetailMemberView.swift
//  ShinyShiftTwo
//
//  Created by Zaidan Akmal on 18/05/25.
//

import SwiftUI
import PhotosUI
import SwiftData

struct DetailMemberView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State var member: Member
    
    @State private var isEditing = false
    @State private var name = ""
    @State private var phone = ""
    @State private var address = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    
    @State private var showDeleteAlert = false
    @State private var showCancelEditAlert = false
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                // MARK: - Edit & Save / Cancel Buttons
                if isEditing {
                    HStack {
                        Button("Cancel", role: .cancel) {
                            isEditing = false
                        }
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        Spacer()
                        Button("Save") {
                            member.name = name
                            member.phone = phone
                            member.address = address
                            
                            if let img = selectedImage {
                                member.photo = img.jpegData(compressionQuality: 0.8)
                            }
                            
                            try? context.save()
                            isEditing = false
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal, 20)
                        .tint(Color.primaryGreen.opacity(0.8))
                        
                        
                    }
                } else {
                    HStack {
                        Spacer()
                        Button("Edit") {
                            name = member.name
                            phone = member.phone
                            address = member.address
                            isEditing = true
                        }
                        .buttonStyle(.bordered)
                        .cornerRadius(100)
                        .padding(.horizontal, 20)
                        .foregroundStyle(.primaryGreen)
                    }
                }
                // MARK: - Profile Image
                if let photoData = member.photo, let image = UIImage(data: photoData) {
                    Image(uiImage: selectedImage ?? image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding(.top)
                } else {
                    Image("Man")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding(.top, 100)
                        .foregroundColor(.gray)
                }
                if isEditing {
                    Button("Change Photo") {
                        showImagePicker = true
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(Color.primaryGreen.opacity(0.8))
                    .fontWeight(.semibold)
                    .cornerRadius(100)
                    .padding(.vertical)
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $selectedImage)
                    }
                }
                
                
                // MARK: - Detail / Edit Fields
                if isEditing {
                    Group {
                        TextField("Name", text: $name)
                        TextField("Phone", text: $phone)
                            .keyboardType(.numberPad)
                        TextField("Address", text: $address)
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                } else {
                    VStack {
                        Text(member.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 40.0)
                            .foregroundStyle(.primaryGreen)
                        
                        HStack {
                            Spacer()
                            Image(systemName: "phone.fill")
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                                .scaledToFit()
                                .padding()
                            VStack(alignment: .leading) {
                                Text("Phone")
                                    .opacity(0.5)
                                Text(member.phone)
                                    .font(.title3)
                                    .fontWeight(.medium)
                                
                            }
                            Spacer()
                            Image(systemName: "location.fill")
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                                .scaledToFit()
                                .padding()
                            VStack {
                                Text("Address")
                                    .opacity(0.5)
                                Text(member.address)
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                            Spacer()
                        }
                        .padding(.bottom, 30.0)
                        .foregroundStyle(Color.primaryGreen)
                    }
                    .padding(.horizontal)
                }
                
                if !isEditing {
                    Toggle("Active Status", isOn: $member.isActive)
                        .onChange(of: member.isActive) { _ in
                            try? context.save()
                        }
                        .padding(.horizontal, 50.0)
                        .frame(width: /*@START_MENU_TOKEN@*/750.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/70.0/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(Color.white)
                        .background(Color.primaryGreen)
                        .cornerRadius(15)
                        .fontWeight(.semibold)
                }
                Spacer()
                // MARK: - Delete Button
                if isEditing {
                    Button("Delete Member", role: .destructive) {
                        showDeleteAlert = true
                    }
                    .padding(.top, 70)
                    .alert("Are you sure you want to delete this member?", isPresented: $showDeleteAlert) {
                        Button("Yes", role: .destructive) {
                            context.delete(member)
                            try? context.save()
                            dismiss()
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                }
            }
        }
        .background(Color.secondaryGreen.opacity(0.5))
        .alert("Discard changes?", isPresented: $showCancelEditAlert) {
            Button("Yes", role: .destructive) {
                isEditing = false
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private func hasChanges() -> Bool {
        return name != member.name ||
        phone != member.phone ||
        address != member.address ||
        selectedImage != nil
    }
}
        
        #Preview {
            DetailMemberView(member: Member(name: "Jane Doe", phone: "08123456789", address: "Jakarta"))
        }
        
        
        
