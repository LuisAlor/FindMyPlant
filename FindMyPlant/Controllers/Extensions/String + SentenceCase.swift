//
//  String.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 19.08.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

extension String {
    
    //Create a sentence case function extending String
    func sentenceCase() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.sentenceCase()
    }
}
