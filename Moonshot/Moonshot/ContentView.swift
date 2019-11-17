//
//  ContentView.swift
//  Moonshot
//
//  Created by Софья П. Рожина on 05/11/2019.
//  Copyright © 2019 Софья П. Рожина. All rights reserved.
//

import SwiftUI

struct Global {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List(Global.missions) { mission in
                NavigationLink(destination: MissionView(mission: mission)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        Text(mission.formattedLaunchDate)
                    }
                }
            }.navigationBarTitle("Moonshot")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
