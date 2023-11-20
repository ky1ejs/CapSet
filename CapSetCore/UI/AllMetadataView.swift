//
//  AllMetadataView.swift
//  CapSet
//
//  Created by Kyle Satti on 8/14/23.
//

import SwiftUI

enum States: String, Identifiable, CaseIterable {
    public var id: Self { self }

    case table = "Table"
    case json = "JSON"
}

struct AllMetadataView: View {
    let metadata: ImageMetadata
    @State private var selectionIndex = States.table

    var body: some View {
        VStack {
            Picker("State", selection: $selectionIndex) {
                ForEach(States.allCases) { value in
                    Text(value.rawValue)
                }
            }.pickerStyle(.segmented)

            switch selectionIndex {
            case .table:
                TableThing(data: metadata)
            case .json:
                List {
                    Cell(title: "Exif", data: metadata.exifData.exifData)
                    Cell(title: "Exif Aux", data: metadata.exifAuxData.exifData)
                    Cell(title: "Tiff", data: metadata.tiffData.exifData)
                }
            }
        }.navigationTitle("All Image Metadata")
    }
}

struct TableThing: View {
    @State var searchText = ""
    let data: [SectionData]

    var searchResults: [SectionData] {
        if searchText.isEmpty {
            return data
        } else {
            let term = searchText.lowercased()
            return data.map { section in
                let rows = section.rows.filter {
                    $0.path.lowercased().contains(term) || $0.value.lowercased().contains(term)
                }
                return SectionData(title: section.title, rows: rows)
            }
        }
    }

    init(data: ImageMetadata) {
        let toParse = [
            "Exif": data.exifData.exifData,
            "Exif Aux": data.exifAuxData.exifData,
            "Tiff": data.tiffData.exifData
        ].compactMap {$0}
        self.data = toParse.map { entry in
            var rows = [RowData]()
            if let dict = entry.value {
                rows = createTableData(dict: dict).sorted { $0.path < $1.path }
            }
            return SectionData(title: entry.key, rows: rows)
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.title) { section in
                    Section(section.title) {
                        ForEach(section.rows, id: \.path) { datum in
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    SubText(datum.key)
                                    Spacer()
                                    switch datum.type {
                                    case "__NSCFNumber":
                                        SubText("Number")
                                    case "__NSCFString":
                                        SubText("String")
                                    default:
                                        SubText(datum.type)
                                    }
                                }
                                Text(datum.value).fontWeight(.bold).padding(.vertical, 1)
                                if datum.key != datum.path {
                                    SubText("full path: "  + datum.path)
                                }
                            }
                        }
                    }
                }

            }
        }
        .searchable(text: $searchText)

    }
}

struct SubText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text).foregroundColor(.gray).font(.system(size: 12))
    }
}

struct SectionData {
    let title: String
    let rows: [RowData]
}

struct RowData {
    let key: String
    let path: String
    let value: String
    let type: String
}

func createTableData(dict: MetadataDict) -> [RowData] {
    let result = dict.map { k, v in createItems(key: k, value: v) }
    return Array(result.joined())
}

func createItems(key: String, value: Any, parents: [String] = []) -> [RowData] {
    let newParent = parents + [key]
    switch value {
    case let value as [String: Any]:
        let result =  value.map {(k, v) in
            return createItems(
                key: k,
                value: v,
                parents: newParent
            )
        }
        return Array(result.joined())
    case let value as [Any]:
        let result = (0..<value.count).map { i in
            let item = value[i]
            return createItems(
                key: String(i),
                value: item,
                parents: newParent
            )
        }
        return Array(result.joined())
    default:
        return [
            RowData(
                key: key,
                path: (parents + [key]).joined(separator: "."),
                value: String(describing: value),
                type: String(describing: type(of: value))
            )
        ]
    }
}

private struct Cell: View {
    let title: String
    let data: [String: Any]?

    var body: some View {
        Section(title) {
            HStack {
                if let data = data, let json = transfrom(dict: data) {
                    Text(json).font(.system(size: 12))
                }
                Spacer()
            }.padding(.leading, 0)
        }
    }
}

func transfrom(dict: MetadataDict) -> String? {
    guard let json = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {
        return nil
    }
    let text = String(data: json, encoding: .utf8)!

    return text
}

struct AllMetadataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            let data = SwiftUIDevResources.loadExampleImageData()
            let metadata = ImageMetadata(imageData: data)
            AllMetadataView(metadata: metadata)
        }
    }
}
