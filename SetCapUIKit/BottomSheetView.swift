//
//  SwiftUIView.swift
//  SetCapUIKit
//
//  Created by Olly Boon on 30/07/2023.
//

import SwiftUI

struct BottomSheetView: View {
    @State var showMenu = false
    
       
    
    var body: some View {
        
        
        Button("open sheet") {
            showMenu = true
        }
        .sheet(isPresented: $showMenu) {
            MetadataView()
                .presentationDetents([.height(200), .large])
        }
        
        
        
               
           
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView()
    }
}
