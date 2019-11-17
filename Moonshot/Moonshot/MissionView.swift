import SwiftUI

struct MissionView: View {
    let mission: Mission
    let astronauts: [CrewMember]
    
    init(mission: Mission, astronauts: [Astronaut] = Global.astronauts) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let astronaut = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: astronaut))
            } else {
                fatalError("Missing \(member)")
            }
        }
        
        self.astronauts = matches
    }
    
    var body: some View {
        GeometryReader { geomery in
            ScrollView(.vertical) {
                VStack {
                    Image(self.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geomery.size.width * 0.7)
                        .padding(.top)
                    
                    Text(self.mission.formattedLaunchDate)
                    
                    Text(self.mission.description)
                        .padding()
                    
                    Spacer(minLength: 25)
                    
                    ForEach(self.astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                                
                                VStack {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(Color.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }.navigationBarTitle(Text(self.mission.displayName), displayMode: .inline)
    }
    
    struct MissionView_Previews: PreviewProvider {
        static let missions: [Mission] = Bundle.main.decode("missions.json")
        static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")

        static var previews: some View {
            MissionView(mission: missions[0], astronauts: astronauts)
        }
    }
}

