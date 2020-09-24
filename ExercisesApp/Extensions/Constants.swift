//
//  Constants.swift
//  SafeRole
//
//  Created by Vishal Chandran on 18/09/18.
//  Copyright © 2018 Vishal Vijayashekkar. All rights reserved.
//

import UIKit
import Foundation

let baseURL = "http://humblerings.com"
// MARK: - Colors

let BACKGROUND_COLOR = UIColor(named: "BackgroundColor")
let MAIN_COLOR = UIColor(named: "MainColor")
let SHADOW_COLOR = UIColor(named: "ShadowColor")
let SIGNBUTTON_COLOR = UIColor(named: "SignBtnColor")
let SUB_COLOR = UIColor(named: "SubColor")
let START_COLOR = UIColor(named: "startColor")
let END_COLOR = UIColor(named: "endColor")
let UNSELECT_COLOR = UIColor(named: "unselectColor")
let SELECT_COLOR = UIColor(named: "selectColor")
let COLOR1 = UIColor(named: "Color1")
let COLOR2 = UIColor(named: "Color2")
let COLOR3 = UIColor(named: "Color3")
let COLOR4 = UIColor(named: "Color4")
let COLOR5 = UIColor(named: "Color5")




// MARK: - Strings

let UNSAFE_PHOTOS_STRING = "UNSAFE PHOTOS"
let HIDDEN_PHOTOS_STRING = "HIDDEN PHOTOS"
let MARK_AS_SAFE_STRING = "MARK AS SAFE"
let MARK_AS_UNSAFE_STRING = "MARK AS UNSAFE"
let HIDE_PHOTOS_STRING = "HIDE IMAGES"
let UNHIDE_PHOTOS_STRING = "UNHIDE IMAGE"
let DELETE_PHOTO_STRING = "DELETE IMAGES"

let BACK_STRING = "BACK"
let SELECT_STRING = "SELECT"
let ALL_STRING = "ALL"
let SETTINGS_STRING = "SETTINGS"
let CANCEL_STRING = "CANCEL"
let LIBRARY_STRING = "LIBRARY"
let CLEAR_STRING = "CLEAR"

// MARK: - Font

func SYSTEM_FONT_REGULAR(ofSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: ofSize, weight: .regular)
}

func SYSTEM_FONT_BOLD(ofSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: ofSize, weight: .bold)
}

// MARK: - Directory

func HIDDEN_IMAGES_DIRECTORY() -> String {
    let aDocumentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    let aProductDirectory = aDocumentDirectory?.appending("/SafeRollHiddenGallery")
    
    do {
        try FileManager.default.createDirectory(atPath: aProductDirectory!, withIntermediateDirectories: false, attributes: nil)
    } catch {
    }
    
    return aProductDirectory!
}

func HIDDEN_IMAGES_THUMBNAIL_DIRECTORY() -> String {
    let aDocumentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    let aProductDirectory = aDocumentDirectory?.appending("/SafeRollHiddenThumbnailGallery")
    
    do {
        try FileManager.default.createDirectory(atPath: aProductDirectory!, withIntermediateDirectories: false, attributes: nil)
    } catch {
    }
    
    return aProductDirectory!
}


func removeDuplicates(array: [String]) -> [String] {
    var encountered = Set<String>()
    var result: [String] = []
    for value in array {
        if encountered.contains(value) {
            // Do not add a duplicate element.
        }
        else {
            // Add value to the set.
            encountered.insert(value)
            // ... Append the value.
            result.append(value)
        }
    }
    return result
}
