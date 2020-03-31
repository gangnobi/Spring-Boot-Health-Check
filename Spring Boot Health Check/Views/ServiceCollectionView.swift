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
    @State private var onHover: [String: Bool] = [:]
    @State private var selectedFilter: String = "allServiceBtn"

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
                    if self.settings.onRefresh && !self.modelData.isEmpty {
                        HStack(spacing: 0) {
                            Button(action: { self.onSelectFilter(name: "allServiceBtn") }) {
                                VStack(alignment: .center) {
                                    Text("\(self.countService(isUp: nil))").font(.headline)
                                    Text("Service").font(.caption)
                                }
                                .frame(width: 308 / 3, height: 70)
                                .background(self.getColorHover(name: "allServiceBtn"))
                                .animation(.spring())
                                .onHover { val in
                                    self.onHover["allServiceBtn"] = val
                                }
                            }
                            .buttonStyle(PlainButtonStyle())

                            Button(action: { self.onSelectFilter(name: "upServiceBtn") }) {
                                VStack(alignment: .center) {
                                    Text(self.isLoading ? "..." : "\(self.countService(isUp: true))").font(.headline)
                                    Text("Up").font(.caption)
                                }
                                .frame(width: 308 / 3, height: 70)
                                .background(self.getColorHover(name: "upServiceBtn"))
                                .animation(.spring())
                                .onHover { val in
                                    self.onHover["upServiceBtn"] = val
                                }
                                .padding(.horizontal, 10)
                            }
                            .buttonStyle(PlainButtonStyle())

                            Button(action: { self.onSelectFilter(name: "downServiceBtn") }) {
                                VStack(alignment: .center) {
                                    Text(self.isLoading ? "..." : "\(self.countService(isUp: false))").font(.headline)
                                    Text("Down").font(.caption)
                                }
                                .frame(width: 308 / 3, height: 70)
                                .background(self.getColorHover(name: "downServiceBtn"))
                                .animation(.spring())
                                .onHover { val in
                                    self.onHover["downServiceBtn"] = val
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                    }
                    ForEach(self.filterList()) { item in
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
        .onAppear { self.onRefreshAll() }
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

    func countService(isUp: Bool?) -> Int {
        let searchFiltered = self.modelData.filter { item in
            self.searchText.isEmpty ? true : item.serviceName.lowercased().contains(self.searchText.lowercased())
        }
        if isUp == nil {
            return searchFiltered.count
        }
        return searchFiltered.filter { (item) -> Bool in
            item.status?.isUp == isUp
        }.count
    }

    func getColorHover(name: String) -> some View {
        if self.onHover[name, default: false] && self.selectedFilter == name {
            return Color.secondary.colorInvert().opacity(0.7).cornerRadius(8).overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 2)
            )
        } else if self.onHover[name, default: false] {
            return Color.secondary.colorInvert().opacity(0.3).cornerRadius(8).overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 2)
            )
        } else if self.selectedFilter == name {
            return Color.secondary.colorInvert().opacity(0.7).cornerRadius(8).overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary, lineWidth: 0)
            )
        } else {
            return Color.secondary.colorInvert().opacity(0.3).cornerRadius(8).overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary, lineWidth: 0)
            )
        }
    }

    func onSelectFilter(name: String) {
        self.selectedFilter = name
    }

    func filterList() -> [ServiceDetailViewModel] {
        let searchFiltered = self.modelData.filter { item in
            self.searchText.isEmpty ? true : item.serviceName.lowercased().contains(self.searchText.lowercased())
        }
        return searchFiltered.filter { item in
            switch self.selectedFilter {
                case "allServiceBtn":
                    return true
                case "upServiceBtn":
                    return item.status?.isUp == true
                case "downServiceBtn":
                    return item.status?.isUp == false
                default:
                    return false
            }
        }
    }
}

struct ServiceCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceCollectionView(
            showServiceCollection: .constant(false),
            modelData: [ServiceDetailViewModel(serviceName: "Test Service", serviceEndpoint: "", links: [])],
            modelDataName: ""
        ).environmentObject(UserSettings())
    }
}
