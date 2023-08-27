//
//  Text+Util.swift
//  SetCapCore
//
//  Created by Kyle Satti on 8/27/23.
//

import SwiftUI

public extension View {
    func fontSize(_ size: CGFloat) -> some View {
        return font(.system(size: size))
    }
}
