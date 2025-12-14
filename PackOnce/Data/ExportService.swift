import Foundation
import PDFKit
import SwiftUI
import UIKit

enum ExportService {
    static func shareText(for pack: PackModel) -> String {
        var lines: [String] = []
        lines.append("Pack: \(pack.name)")
        if let when = pack.when {
            lines.append("When: \(DateFormatter.short.string(from: when))")
        }
        lines.append("Type: \(pack.typeTag.rawValue)")
        lines.append("")
        for item in pack.items {
            let prefix = item.isPacked ? "[x]" : "[ ]"
            let note = item.note.isEmpty ? "" : " - \(item.note)"
            let qty = item.quantity > 1 ? " x\(item.quantity)" : ""
            lines.append("\(prefix) \(item.title)\(qty)\(note)")
        }
        return lines.joined(separator: "\n")
    }

    static func renderPDF(for pack: PackModel) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "PackOnce",
            kCGPDFContextAuthor: "PackOnce"
        ] as CFDictionary

        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { context in
            context.beginPage()
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.preferredFont(forTextStyle: .title1)
            ]
            let bodyAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.preferredFont(forTextStyle: .body)
            ]

            let title = "Pack: \(pack.name)"
            title.draw(at: CGPoint(x: 40, y: 40), withAttributes: titleAttributes)

            var cursor = CGFloat(80)
            if let when = pack.when {
                "When: \(DateFormatter.short.string(from: when))".draw(at: CGPoint(x: 40, y: cursor), withAttributes: bodyAttributes)
                cursor += 24
            }

            "Type: \(pack.typeTag.rawValue)".draw(at: CGPoint(x: 40, y: cursor), withAttributes: bodyAttributes)
            cursor += 32

            for item in pack.items {
                let mark = item.isPacked ? "☑︎" : "☐"
                let qty = item.quantity > 1 ? " x\(item.quantity)" : ""
                let note = item.note.isEmpty ? "" : " – \(item.note)"
                let line = "\(mark) \(item.title)\(qty)\(note)"
                line.draw(at: CGPoint(x: 40, y: cursor), withAttributes: bodyAttributes)
                cursor += 22
            }
        }
        return data
    }
}

private extension DateFormatter {
    static let short: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
