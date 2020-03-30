//
//  ServiceDetailView.swift
//  Spring Boot Health Check
//
//  Created by Waytis Laoniyomthai on 29/3/2563 BE.
//  Copyright © 2563 Waytis Laoniyomthai. All rights reserved.
//

import SwiftUI

struct ServiceDetailView: View {
    @EnvironmentObject var settings: UserSettings
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss, d MMM y"
        return formatter
    }()

    @ObservedObject var serviceDetailItem: ServiceDetailViewModel
    @State var loading: Bool = false

    var body: some View {
        RoundedRectangle(cornerRadius: 8.0)
            .frame(height: 70)
            .opacity(0.3)
            .colorInvert()
            .overlay(
                HStack(spacing: 1) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(self.serviceDetailItem.serviceName)").font(.body)
                        HStack(spacing: 5) {
                            Button(action: {
                                if !self.loading {
                                    self.loading = true
                                    self.serviceDetailItem.fetchStatus { _ in
                                        self.loading = false
                                        self.settings.onRefresh = true
                                    }
                                }
                            }) {
                                Image("refresh")
                                    .resizable()
                                    .renderingMode(.template)
                                    .rotationEffect(.degrees(self.loading ? 0 : 360))
                                    .animation(self.loading ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : Animation.linear(duration: 0))
                                    .padding(5)
                                    .foregroundColor(Color.primary)
                                    .background(Color.primary.colorInvert().opacity(0.3))
                                    .cornerRadius(5)
                                    .frame(width: 20, height: 20)
                            }.buttonStyle(PlainButtonStyle())
                            
                            ForEach(self.serviceDetailItem.links) { item in
                                Button(action: {
                                    if let url = URL(string: item.url) {
                                            NSWorkspace.shared.open(url)
                                        }
                                }) {
                                        HStack {
                                            Text(item.name).font(.caption)
                                        }
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .foregroundColor(Color.primary)
                                        .background(Color.primary.colorInvert().opacity(0.3))
                                        .cornerRadius(5)

                                    }.buttonStyle(PlainButtonStyle())
                            }
                            
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        self.getStatusText()
                        self.serviceDetailItem.status.map { status in
                            VStack(alignment: .trailing, spacing: 0) {
                                Text("Last updated").font(.system(size: 10)).fontWeight(.light)
                                Text("\(status.updatedDateTime, formatter: Self.dateFormat)")
                                    .font(.system(size: 10)).fontWeight(.light)
                            }
                        }
                    }
                }
                .padding()
        )
    }

    func getStatusText() -> Text {
        guard let status = serviceDetailItem.status else {
            return Text("No Data").font(.system(size: 14)).foregroundColor(Color.primary.opacity(0.5))
        }
        if status.isUp {
            return Text("UP").font(.system(size: 16)).foregroundColor(.green).fontWeight(.semibold)
        } else {
            return Text("\(status.httpStatusCode)").font(.system(size: 16)).foregroundColor(.red).fontWeight(.semibold)
        }
    }
}

struct ServiceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceDetailView(serviceDetailItem: ServiceDetailViewModel(serviceName: "Service Name", serviceEndpoint: "", links: []))
    }
}
