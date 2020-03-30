//
//  ServiceCollectionView.swift
//  Spring Boot Health Check
//
//  Created by Waytis Laoniyomthai on 29/3/2563 BE.
//  Copyright © 2563 Waytis Laoniyomthai. All rights reserved.
//

import SwiftUI

struct ServiceCollectionView: View {
    @EnvironmentObject var settings: UserSettings
    
    @Binding var showServiceCollection: Bool
    @State var onShow: Bool = false

    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm, d MMM y"
        return formatter
    }()
    
    @State var modelData: [ServiceDetailViewModel]
    @State var modelDataName: String
    @State private var searchText: String = ""
    @State private var isLoading = false
    @State private var showRefreshAllLoading = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button(action: {
                    withAnimation(.easeIn(duration: 0.2)) {
                        self.showServiceCollection = true
                    }
                }) {
                    Image("down-arrow")
                        .rotationEffect(.degrees(self.onShow ? 0 : 90))
                        .animation(Animation.easeInOut)
                        .padding(6)
                        .foregroundColor(.primary)
                        .background(Color.primary.colorInvert().opacity(0.2))
                        .cornerRadius(4)
                        .onAppear {
                            self.onShow = true
                        }
                }.buttonStyle(PlainButtonStyle())
                Text(self.modelDataName)
                    .font(Font.system(size: 24.0))
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    if !self.isLoading {
                        self.onRefreshAll()
                    }
                }) {
                    HStack(spacing: 5) {
                        if self.isLoading {
                            Image("refresh")
                                .renderingMode(.template)
                                .rotationEffect(.degrees(self.showRefreshAllLoading ? 0 : 360))
                                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                                .onAppear {
                                    self.showRefreshAllLoading.toggle()
                                }
                                .onDisappear {
                                    self.showRefreshAllLoading.toggle()
                                }
                        } else {
                            Text("Refresh All").font(.caption).transition(.opacity)
                        }
                    }
                }.buttonStyle(PlainButtonStyle())
            }.padding()
            TextField("Search", text: $searchText)
                .font(.subheadline)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.bottom, 10)
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    if self.searchText.isEmpty && self.settings.onRefresh && !self.modelData.isEmpty {
                    RoundedRectangle(cornerRadius: 8.0)
                    .frame(height: 70)
                    .opacity(0.3)
                    .colorInvert()
                    .overlay(
                        HStack(spacing: 0) {
                            VStack(alignment:.center){
                                Text("\(self.modelData.count)").font(.body)
                                Text("Service").font(.caption)
                            }
                            .frame(width: 360.0/3-(2/3))
                            Divider()
                            VStack(alignment:.center){
                                Text("\(self.countService(isUp: true))").font(.body)
                                Text("Up").font(.caption)
                            }
                            .frame(width: 360.0/3-(2/3)-15)
                            Divider()
                            VStack(alignment:.center){
                                Text("\(self.countService(isUp: false))").font(.body)
                                Text("Down").font(.caption)
                            }
                            .frame(width: 360.0/3-(2/3))
                    })
                    .padding(.vertical, 5)
                    .padding(.horizontal)}
                    ForEach(self.modelData.filter { item in
                        self.searchText.isEmpty ? true : item.serviceName.lowercased().contains(self.searchText.lowercased())
                    }) { item in
                        ServiceDetailView(serviceDetailItem: item)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                }
                .frame(width: 360.0, alignment: .topLeading)
            }
        }
        .padding(0)
        .frame(width: 360.0, height: 360.0, alignment: .top)
        .onAppear(){self.onRefreshAll()}
    }

    func toggleIsLoading(val: Bool) {
        withAnimation(.easeIn(duration: 0.2)) {
            self.isLoading = val
        }
    }

    func onRefreshAll() {
        self.toggleIsLoading(val: true)
        let fetchGroup = DispatchGroup()
        self.modelData.forEach { item in
            fetchGroup.enter()
            item.fetchStatus { _ in
                fetchGroup.leave()
            }
        }

        fetchGroup.notify(queue: .main) {
            self.toggleIsLoading(val: false)
            self.settings.onRefresh = true
        }
    }
    
    func countService(isUp:Bool) -> Int {
        self.modelData.filter { (item) -> Bool in
            (item.status?.isUp == isUp )
        }.count
    }
}

struct ServiceCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceCollectionView(showServiceCollection: .constant(false),modelData:[], modelDataName: "")
    }
}
