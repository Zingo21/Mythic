//
//  Support.swift
//  Mythic
//
//  Created by Esiayo Alegbe on 12/9/2023.
//

// Copyright © 2023 blackxfiied, Jecta

// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

// You can fold these comments by pressing [⌃ ⇧ ⌘ ◀︎], unfold with [⌃ ⇧ ⌘ ▶︎]

import SwiftUI
import Shimmer

struct SupportView: View {
    // TODO: https://arc.net/l/quote/icczlrwf
    
    var body: some View {
        HStack {
            VStack {
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.background)
            .clipShape(.rect(cornerRadius: 10))
            .shimmering(bandSize: 1)
            
            VStack {
                VStack {
                    HStack {
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background)
                .clipShape(.rect(cornerRadius: 10))
                .shimmering(bandSize: 1)
                
                VStack {
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background)
                .clipShape(.rect(cornerRadius: 10))
                .shimmering(bandSize: 1)
            }
        }
        .padding()
        .navigationTitle("Support")
}
}

#Preview {
    SupportView()
}
