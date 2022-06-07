//
//  NSAttributedString+Extension.swift
//  airbnb
//
//  Created by seongha shin on 2022/05/23.
//

import UIKit

enum AttributedStringOption {
    case font(_ font: UIFont)
    case foreground(color: UIColor)
    case background(color: UIColor)
    case underLined
    case strikethrough
    case paragraphStyle(_ style: NSMutableParagraphStyle)
}

extension NSAttributedString {
    static func options(_ options: [AttributedStringOption]) -> [NSAttributedString.Key: Any] {
        var attributes = [NSAttributedString.Key: Any]()
        options.forEach { option in
            switch option {
            case .font(let font):
                attributes[.font] = font
            case .foreground(let color):
                attributes[.foregroundColor] = color
            case .background(let color):
                attributes[.backgroundColor] = color
            case .underLined:
                attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
            case .strikethrough:
                attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
            case .paragraphStyle(let style):
                attributes[.paragraphStyle] = style
            }
        }
        return attributes
    }
    
    static func create(_ string: String, options: [AttributedStringOption] = []) -> NSAttributedString {
        let attributes = Self.options(options)
        return NSAttributedString(string: string, attributes: attributes)
    }
}
