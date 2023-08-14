//
//  Templates.swift
//  SetCapCore
//
//  Created by Kyle Satti on 8/13/23.
//

import Foundation

public enum Template: String, CaseIterable, Identifiable {
    public var id: Self { self }

    public typealias RawValue = String

    public var name: String {
        switch self {
        case .clean: return "Clean"
        case .minimal: return "Minimal"
        case .emoji: return "Emoji"
        }
    }

    case emoji = """
        📷 %{body}
        🔭 %{lens}
        ⚙️ ƒ%{fNumber} | %{shutter_speed} | ISO %{iso}
    """
    case minimal = """
        ƒ%{fNumber} | %{shutter_speed} | ISO %{iso}
        %{focal_length}
    """
    case clean = """
        %{body}
        %{focal_length} | ƒ%{fNumber} | %{shutter_speed} | ISO %{iso}
    """
}
