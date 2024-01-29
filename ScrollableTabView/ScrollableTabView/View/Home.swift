//
//  Home.swift
//  ScrollableTabView
//
//  Created by yangyang on 2024/1/29.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var selectedTab: Tab?
    @Environment(\.colorScheme) private var scheme
    /// Tab Progress
    @State private var tabProgress: CGFloat = 0
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button(action: {}, label: {
                    Image(systemName: "line.3.horizontal.decrease")
                })
                
                Spacer()
                
                Button(action: {}, label: {
                    Image(systemName: "bell.badge")
                })
            }
            .font(.title2)
            .overlay {
                Text("Messages")
                    .font(.title3.bold())
            }
            .foregroundStyle(.primary)
            .padding(15)
            
            /// Custom Tab Bar
            CustomTabBar()
            
            /// Paging View using new iOS 17 APIs
            GeometryReader {
                let size = $0.size
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        SampleView(.purple)
                            .id(Tab.chats)
                            .containerRelativeFrame(.horizontal)
                        
                        SampleView(.red)
                            .id(Tab.calls)
                            .containerRelativeFrame(.horizontal)
                        
                        SampleView(.blue)
                            .id(Tab.settings)
                            .containerRelativeFrame(.horizontal)
                    }
                    .scrollTargetLayout()
                    .offsetX { value in
                        /// Converting Offset into Progress
                        let progress = -value / (size.width * CGFloat(Tab.allCases.count - 1))
                        /// Capping Progress BTW 0-1
                        tabProgress = max(min(progress, 1), 0)
                    }
                }
                .scrollPosition(id: $selectedTab)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollClipDisabled()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.gray.opacity(0.1))
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                HStack(spacing: 10) {
                    Image(systemName: tab.systemImage)
                    
                    Text(tab.rawValue)
                        .font(.callout)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    /// Updating Tab
                    withAnimation(.snappy) {
                        selectedTab = tab
                    }
                }
            }
        }
        .tabMask(tabProgress)
        /// Scrollable Active Tab Indicator
        .background {
            GeometryReader {
                let size = $0.size
                let capusleWidth = size.width / CGFloat(Tab.allCases.count)
                
                Capsule()
                    .fill(scheme == .dark ? .black : .white)
                    .frame(width: capusleWidth)
                    .offset(x: tabProgress * (size.width - capusleWidth))
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
    
    /// Sample View For Demonstrating Scrollable Tab Bar Indicator
    @ViewBuilder
    func SampleView(_ color: Color) -> some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), content: {
                ForEach(1...10, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(color.gradient)
                        .frame(height: 150)
                        .overlay {
                            VStack(alignment: .leading) {
                                Circle()
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 50, height: 50)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 80, height: 8)
                                    
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 60, height: 8)
                                }
                                
                                Spacer(minLength: 0)
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 40, height: 8)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                }
            })
            .padding(15)
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .mask {
            Rectangle()
                .padding(.bottom, -100)
        }
    }
}

#Preview {
    ContentView()
}

