//
//  ContentView.swift
//  NValueCalculator
//
//  Created by 御堂 大嗣 on 2019/10/17.
//  Copyright © 2019 御堂 大嗣. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        /*
        TabView(selection: $selection){
            MainView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("First")
                    }
                }
                .tag(0)
            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Second")
                    }
                }
                .tag(1)
        }*/
        MainView().font(.title)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
