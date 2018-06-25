//
//  Extensions.swift
//  hacker-news
//
//  Created by Shravan Sukumar on 23/06/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func htmlAttributedString(size: CGFloat) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt !important;" +
                "font-family: \("Helvetica"), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return NSAttributedString()
            }
            
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return NSAttributedString()
        }
    }
}
