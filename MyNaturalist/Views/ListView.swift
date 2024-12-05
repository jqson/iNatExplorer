//
//  ListView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/4/24.
//

import SwiftUI

struct ListView: View {
    
    var observations: [Observation]
    
    var body: some View {
        List(observations) { observation in
            ItemView(observation: observation)
        }
    }
}

#Preview {
    let observation: Observation = Observation.Constants.preview
    ListView(observations: [observation, observation, observation])
}
