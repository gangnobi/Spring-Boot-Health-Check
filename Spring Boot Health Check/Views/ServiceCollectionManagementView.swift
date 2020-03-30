//
//  ServiceCollectionManagementView.swift
//  Spring Boot Health Check
//
//  Created by Waytis Laoniyomthai on 29/3/2563 BE.
//  Copyright © 2563 Waytis Laoniyomthai. All rights reserved.
//

import SwiftUI

struct ServiceCollectionManagementView: View {
    @Binding var currentCollection: [ServiceDetailViewModel]
    @Binding var currentCollectionName: String
    @Binding var showServiceCollection: Bool
    @State var onShow: Bool = false
    @State var collectionServiceData: [CollectionServiceView] = []

    let serviceCollectionService = ServiceCollectionService()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        self.showServiceCollection = false
                    }
                }) {
                    Image("down-arrow")
                        .rotationEffect(.degrees(self.onShow ? 90 : 0))
                        .animation(Animation.easeInOut)
                        .padding(6)
                        .foregroundColor(.primary)
                        .background(Color.primary.colorInvert().opacity(0.2))
                        .cornerRadius(4)
                        .onAppear {
                            self.onShow = true
                        }
                }.buttonStyle(PlainButtonStyle())
                    .disabled(self.currentCollectionName.isEmpty)
                Text("Collections")
                    .font(Font.system(size: 24.0))
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    self.openDialogDragFile()
                }) {
                    Text("Import")
                        .padding(6)
                        .padding(.horizontal, 6)
                        .foregroundColor(.primary)
                        .background(Color.primary.colorInvert().opacity(0.2))
                        .cornerRadius(4)
                }.buttonStyle(PlainButtonStyle())
            }.padding()
            Divider()
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    ForEach(self.collectionServiceData) { item in
                        Button(action: {
                            self.onSelectCollection(collectionSelected: item)
                        }) {
                            RoundedRectangle(cornerRadius: 8.0)
                                .frame(height: 70)
                                .opacity(0.3)
                                .colorInvert()
                                .overlay(
                                    HStack(spacing: 1) {
                                        Text(item.collectionName).padding()
                                        Spacer()
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                self.serviceCollectionService.removeServiceCollection(collectionName: item.collectionName)
                                                self.fetchCollections()
                                            }
                                    }) {
                                            Image("bin").padding().foregroundColor(Color.primary.opacity(0.5))
                                        }.buttonStyle(PlainButtonStyle())
                                    }
                                )
                                .padding(.vertical, 5)
                                .padding(.horizontal)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(width: 360.0, alignment: .topLeading)
            }
            .onAppear(perform: fetchCollections)
            .padding(.top, 10)
        }
        .frame(width: 360.0, height: 360.0, alignment: .top)
    }

    func fetchCollections() {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.collectionServiceData = self.serviceCollectionService.getCollectionServices().map { val in
                CollectionServiceView(collectionName: val.collectionName, services: val.services)
            }
            if self.collectionServiceData.first(where: { item in
                item.collectionName == self.currentCollectionName
            }) == nil {
                self.currentCollectionName = ""
            }
        }
    }

    func onSelectCollection(collectionSelected: CollectionServiceView) {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.currentCollection = collectionSelected.services.map { item in
                ServiceDetailViewModel(serviceName: item.serviceName, serviceEndpoint: item.healthCheckURL, links: item.links)
            }
            self.currentCollectionName = collectionSelected.collectionName
            self.showServiceCollection = false
        }
    }

    func openDialogDragFile() {
        let panel = NSOpenPanel()
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(.regular)
            let result = panel.runModal()
            if result == .OK {
                if self.serviceCollectionService.importCollectionService(fileUrl: panel.url!) {
                    self.fetchCollections()
                }
            }
            NSApp.setActivationPolicy(.prohibited)
        }
    }
}

struct ServiceCollectionManagementView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceCollectionManagementView(currentCollection: .constant([]), currentCollectionName: .constant(""), showServiceCollection: .constant(true))
    }
}
