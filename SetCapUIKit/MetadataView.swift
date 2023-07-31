//
//  MetadataView.swift
//  SetCapUIKit
//
//  Created by Olly Boon on 30/07/2023.
//

import SwiftUI

struct MetadataView: View {
    
    var imageFormat = "JPEG"
    var focalLength = "24"
    var aperture = "4.0"
    var exposureComp = "0"
    var iso = "1500"
    var shutterSpeed = "1/150"
    let cornerRadius = CGFloat(6)
    let errorState = false
    
    
    var body: some View {
        
        VStack{
            
            HStack() {
                Text("Apple iPhone 14 Pro")
                    .font(.system(size: 16.0, weight: .medium, design: .rounded))
                    
                Spacer()
                Text(imageFormat)
                    .font(.system(size: 16.0, weight: .medium, design: .rounded))
                    .padding(4)
                    .foregroundColor(.primary)
                    .background(.regularMaterial)
                    .cornerRadius(cornerRadius)

            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial)
            
            HStack() {
                
                if errorState == true{
                    Text("-")
                        .font(.system(size: 16.0))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Missing Info")
                        .font(.system(size: 16.0))
                        .foregroundColor(.red)
                } else {
                    Text("Telephoto Camera - 77mm  ƒ2.8")
                        .font(.system(size: 16.0))
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(8)
            
            HStack() {
                
                Text(focalLength + "mm")
                    .font(.custom("SF Compact", size: 16 ))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .cornerRadius(cornerRadius)
                
                Spacer()
                
                
                Text("ƒ" + aperture)
                    .font(.custom("SF Compact", size: 16 ))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .cornerRadius(cornerRadius)
                
                
                Spacer()
                
                if exposureComp == "0" {
                    
                    
                    
                } else {
                    
                    Text(exposureComp + " ev")
                        .font(.custom("SF Compact", size: 16 ))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial)
                        .cornerRadius(cornerRadius)
                    
                    Spacer()
                    
                }
                
                
                
                
                
                Text("ISO " + iso)
                    .font(.custom("SF Compact", size: 16 ))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .cornerRadius(cornerRadius)
                
                Spacer()
                
                Text(shutterSpeed + "s")
                    .font(.custom("SF Compact", size: 16 ))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .cornerRadius(cornerRadius)
                
                
                
            }
            .frame(alignment: .topLeading)
            .padding(8)
            
            
            
            
        }
        .frame(width: .infinity, alignment: .topLeading)
        .background(.ultraThinMaterial)
        .cornerRadius(cornerRadius)
        .padding(.horizontal, 16)
        
    }
}



struct MetadataView_Previews: PreviewProvider {
    static var previews: some View {
        MetadataView()
    }
}
