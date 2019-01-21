//
//  String.swift
//  Trackmoney
//
//  Created by Maxim Tolstikov on 21/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

extension String {
    
    func cleanWhitespace() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
