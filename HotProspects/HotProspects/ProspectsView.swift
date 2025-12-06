//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Deepankar Das on 02/12/25.
//

import AVFoundation
import CodeScanner
import SwiftData
import SwiftUI
import UserNotifications


struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @Query(sort : \Prospect.name) var prospects : [Prospect]
    @Environment(\.modelContext) var modelContext
    
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<Prospect>()
    
    @State private var sortOrder = SortDescriptor(\Prospect.name)
    
    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }
    }
    
    var sortedProspects: [Prospect] {
        prospects.sorted(using: sortOrder)
    }
    
    var body: some View {
        NavigationStack {
            List(sortedProspects, selection: $selectedProspects) { prospect in
                NavigationLink{
                    EditView(prospect: prospect)
                } label: {
                    Label{
                        Text(prospect.name).font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundStyle(.secondary)
                        Text(prospect.date, format: .dateTime)
                        
                    } icon: {
                        Image(systemName:  prospect.isContacted ? "person.fill.checkmark" : "person.fill.xmark")
                            .foregroundStyle(prospect.isContacted ? .green : .red)
                    }
                }
                
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    }else{
                        Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }.tint(.green)
                        Button("Remind Me", systemImage: "bell"){
                            addNotification(for: prospect)
                        }.tint(.orange)
                    }
                    
                }
                .tag(prospect)
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Name")
                                .tag(SortDescriptor(\Prospect.name))
                            
                            Text("Date")
                                .tag(SortDescriptor(\Prospect.date))
                        }
                        .pickerStyle(.inline)
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner.toggle()
                    }
                }
                if selectedProspects.isEmpty == false {
                    ToolbarItem(placement: .automatic) {
                        Button("Delete", systemImage: "trash") {
                            delete()
                        }
                    }
                }
                
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
        }
        
    }
    
    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
        selectedProspects = Set<Prospect>()
    }
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let scanResult):
            let details = scanResult.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
            modelContext.insert(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
        
    }
    func addNotification(for prospect : Prospect) {
        let center = UNUserNotificationCenter.current()
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact : \(prospect.name)"
            content.body = prospect.emailAddress
            content.sound = .default
            //            var dateComponents = DateComponents()
            //            dateComponents.hour = 9
            //            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            }else{
                center.requestAuthorization(options: [.alert,.badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    }else{
                        print(error!.localizedDescription)
                    }
                }
            }
        }
        
    }
    init(filter: FilterType) {
        self.filter = filter
        
        switch filter {
        case .none:
            _prospects = Query(sort: [sortOrder])
        case .contacted:
            _prospects = Query(filter: #Predicate{
                $0.isContacted == true
            }, sort: [sortOrder])
            
        case .uncontacted:
            _prospects = Query(filter: #Predicate{
                $0.isContacted == false
            }, sort: [sortOrder])
        }
    }
    
    
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
}
