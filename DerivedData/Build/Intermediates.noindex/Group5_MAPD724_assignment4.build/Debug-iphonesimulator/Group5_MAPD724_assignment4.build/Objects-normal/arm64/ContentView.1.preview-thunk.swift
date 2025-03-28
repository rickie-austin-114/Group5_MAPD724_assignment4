import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/rickie/Documents/centennial/MAPD724/Group5_MAPD724_assignment4/Group5_MAPD724_assignment4/ContentView.swift", line: 1)
//
//  ContentView.swift
//  Group5_MAPD724_assignment4
//
//  Created by Rickie Au on 28/3/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: __designTimeString("#5291_0", fallback: "globe"))
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(__designTimeString("#5291_1", fallback: "Hello, world!"))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
