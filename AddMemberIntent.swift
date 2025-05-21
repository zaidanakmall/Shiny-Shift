//
//  AddMemberIntent.swift
//  ShinyShiftTwo
//
//  Created by Zaidan Akmal on 19/05/25.
//

//import AppIntents
//import SwiftData
//
//struct AddMemberIntent: AppIntent {
//    static var title: LocalizedStringResource = "Add Member"
//    static var description = IntentDescription("Add a new member with name, phone, and address.")
//
//    @Parameter(title: "Name")
//    var name: String
//
//    @Parameter(title: "Phone Number")
//    var phone: String
//
//    @Parameter(title: "Address")
//    var address: String
//
//    func perform() async throws -> some IntentResult {
//        do {
//            let container = try ModelContainer(for: Member.self)
//            let context = await container.mainContext
//            let newMember = Member(name: name, phone: phone, address: address, isActive: true)
//            context.insert(newMember)
//            try context.save()
//            return .result(dialog: "Member '\(name)' added successfully.")
//        } catch {
//            return .result(dialog: "Failed to add member: \(error.localizedDescription)")
//        }
//    }
//}

