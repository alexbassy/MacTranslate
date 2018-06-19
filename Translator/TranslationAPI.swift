//
//  TranslationAPI.swift
//  Translator
//
//  Created by Alex Bass on 17/06/2018.
//  Copyright © 2018 Alex Bass. All rights reserved.
//

import Foundation

func encodeURIComponent(_ str: String) -> String? {
    var characterSet = CharacterSet.alphanumerics
    characterSet.insert(charactersIn: "-_.!~*'()")
    return str.addingPercentEncoding(withAllowedCharacters: characterSet)
}

struct TranslationResult {
    let sourceText: String
    let translatedText: String
}

class TranslatorAPI {
    static func translate(sourceText: String,
                          sourceLang: String,
                          targetLang: String,
                          _ callback: @escaping (String, String) -> Void) {
        
        let query = encodeURIComponent(sourceText)
        let source = "auto"
        let target = "de"
        let url = URL(string: "https://script.google.com/macros/s/AKfycbxVkjTukRRC__Zfellf8uXfH6GUE_vfG1LUHj1tvbcw0OYokZA6/exec?q=\(query!)&pretty=1&target=\(target)&source=\(source)")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                do {
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    
                    if let json = jsonSerialized,
                        let sourceText = json["sourceText"],
                        let translation = json["translation"] {
                        print("You entered \(sourceText)")
                        print("This translates to \"\(translation)\" in German")
                        
                        DispatchQueue.main.async {
                            callback(sourceText as! String, translation as! String)
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
