//
//  AstronautView.swift
//  Moonshot
//
//  Created by Софья П. Рожина on 05/11/2019.
//  Copyright © 2019 Софья П. Рожина. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    let missions: [Mission]
    
    init(astronaut: Astronaut, missions: [Mission] = Global.missions) {
        self.astronaut = astronaut
        
        var currentMissions: [Mission] = []
        
        for mission in missions {
            if mission.crew.contains(where: { $0.name == astronaut.id
            }) {
                currentMissions.append(mission)
            }
        }
        
        self.missions = currentMissions
    }
    
    var body: some View {
        GeometryReader { geomery in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geomery.size.width)
                    
                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)
                                        
                    List(Global.missions) { mission in
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
                    
                    Spacer(minLength: 25)
                }
            }
        }.navigationBarTitle(Text(self.astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")

    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
