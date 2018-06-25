//
//  TranslationAPI.swift
//  Translator
//
//  Created by Alex Bass on 17/06/2018.
//  Copyright © 2018 Alex Bass. All rights reserved.
//

import Foundation

let ALL_LANGUAGES = [
    "Afrikaans": "af",
    "Albanian": "sq",
    "Amharic": "am",
    "Arabic": "ar",
    "Armenian": "hy",
    "Azerbaijani": "az",
    "Basque": "eu",
    "Belarusian": "be",
    "Bengali": "bn",
    "Bosnian": "bs",
    "Bulgarian": "bg",
    "Catalan": "ca",
    "Cebuano": "ceb",
    "Chichewa": "ny",
    "Chinese": "zh-CN",
    "Corsican": "co",
    "Croatian": "hr",
    "Czech": "cs",
    "Danish": "da",
    "Dutch": "nl",
    "English": "en",
    "Esperanto": "eo",
    "Estonian": "et",
    "Filipino": "tl",
    "Finnish": "fi",
    "French": "fr",
    "Frisian": "fy",
    "Galician": "gl",
    "Georgian": "ka",
    "German": "de",
    "Greek": "el",
    "Gujarati": "gu",
    "Haitian Creole": "ht",
    "Hausa": "ha",
    "Hawaiian": "haw",
    "Hebrew": "iw",
    "Hindi": "hi",
    "Hmong": "hmn",
    "Hungarian": "hu",
    "Icelandic": "is",
    "Igbo": "ig",
    "Indonesian": "id",
    "Irish": "ga",
    "Italian": "it",
    "Japanese": "ja",
    "Javanese": "jw",
    "Kannada": "kn",
    "Kazakh": "kk",
    "Khmer": "km",
    "Korean": "ko",
    "Kurdish (Kurmanji)": "ku",
    "Kyrgyz": "ky",
    "Lao": "lo",
    "Latin": "la",
    "Latvian": "lv",
    "Lithuanian": "lt",
    "Luxembourgish": "lb",
    "Macedonian": "mk",
    "Malagasy": "mg",
    "Malay": "ms",
    "Malayalam": "ml",
    "Maltese": "mt",
    "Maori": "mi",
    "Marathi": "mr",
    "Mongolian": "mn",
    "Myanmar (Burmese)": "my",
    "Nepali": "ne",
    "Norwegian": "no",
    "Pashto": "ps",
    "Persian": "fa",
    "Polish": "pl",
    "Portuguese": "pt",
    "Punjabi": "pa",
    "Romanian": "ro",
    "Russian": "ru",
    "Samoan": "sm",
    "Scots Gaelic": "gd",
    "Serbian": "sr",
    "Sesotho": "st",
    "Shona": "sn",
    "Sindhi": "sd",
    "Sinhala": "si",
    "Slovak": "sk",
    "Slovenian": "sl",
    "Somali": "so",
    "Spanish": "es",
    "Sundanese": "su",
    "Swahili": "sw",
    "Swedish": "sv",
    "Tajik": "tg",
    "Tamil": "ta",
    "Telugu": "te",
    "Thai": "th",
    "Turkish": "tr",
    "Ukrainian": "uk",
    "Urdu": "ur",
    "Uzbek": "uz",
    "Vietnamese": "vi",
    "Welsh": "cy",
    "Xhosa": "xh",
    "Yiddish": "yi",
    "Yoruba": "yo",
    "Zulu": "zu"
]

struct Translation: Codable {
    let sentences: [Sentence]
    let dict: [Dict]
    let src: String
    let translation: String
    let input: String
    
    init(_ dictionary: [String: Any] ) {
        var sentences = [Sentence]()
        var dicts = [Dict]()
        
        if let jsonDicts = dictionary["dict"] {
            for dict in jsonDicts as! [Dictionary<String, Any>] {
                let d = Dict(dict)
                dicts.append(d)
            }
        }
        
        if let jsonSentences = dictionary["sentences"] {
            for sentence in jsonSentences as! [Dictionary<String, Any>] {
                let s = Sentence(sentence)
                sentences.append(s)
            }
        }
        
        self.sentences = sentences
        self.dict = dicts
        
        self.src = dictionary["src"] as? String ?? ""
        self.translation = dictionary["translation"] as? String ?? ""
        self.input = dictionary["input"] as? String ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case sentences = "sentences"
        case dict = "dict"
        case src = "src"
        case translation = "translation"
        case input = "input"
    }
}

struct Dict: Codable {
    let terms: [String]?
    let entry: [Entry]?
    let baseForm: String?
    
    init(_ dictionary: [String: Any] ) {
        self.terms = dictionary["terms"] as? [String]
        self.baseForm = dictionary["base_form"] as? String
        
        var entries = [Entry]()
        if let jsonEntries = dictionary["dict"] {
            for entry in jsonEntries as! [Dictionary<String, Any>] {
                let e = Entry(entry)
                entries.append(e)
            }
        }
        self.entry = entries
    }
    
    enum CodingKeys: String, CodingKey {
        case terms = "terms"
        case entry = "entry"
        case baseForm = "base_form"
    }
}

struct Entry: Codable {
    let word: String?
    let reverseTranslation: [String]?
    let score: Double?
    
    init(_ dictionary: [String: Any] ) {
        self.word = dictionary["word"] as? String
        self.reverseTranslation = dictionary["reverse_translation"] as? [String]
        self.score = dictionary["score"] as? Double
    }
    
    enum CodingKeys: String, CodingKey {
        case word = "word"
        case reverseTranslation = "reverse_translation"
        case score = "score"
    }
}

struct Sentence: Codable {
    let trans: String
    let orig: String
    
    init(_ dictionary: [String: Any] ) {
        self.trans = dictionary["trans"] as! String
        self.orig = dictionary["orig"] as! String
    }
    
    enum CodingKeys: String, CodingKey {
        case trans = "trans"
        case orig = "orig"
    }
}

extension String {
    func encodeURIComponent() -> String? {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-_.!~*'()")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet)
    }
}

class TranslatorAPI {
    static let AUTO_LANGUAGE = "Detect language"
    
    static let AUTO_LANGUAGE_CODE = "auto"
    
    static let DEFAULT_TARGET_LANGUAGE = "en"
    
    static let supportedLanguages = ALL_LANGUAGES
    
    static let languageNames = [String](ALL_LANGUAGES.keys).sorted()
    
    static func getLanguageNameByCode(_ code: String) -> String? {
        let lang = ALL_LANGUAGES.first { (key, value) -> Bool in value == code }
        return lang?.key
    }
    
    static func translate(sourceText: String, sourceLang: String, targetLang: String,
                          _ callback: @escaping (Translation?) -> Void) {
        
        let query = sourceText.encodeURIComponent()
        let url = URL(string: "https://script.google.com/macros/s/AKfycbxVkjTukRRC__Zfellf8uXfH6GUE_vfG1LUHj1tvbcw0OYokZA6/exec?q=\(query!)&pretty=1&target=\(targetLang)&source=\(sourceLang)")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data
                else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                print(response)
                
                if let response = response {
                    let translation = Translation(response)

                    print(translation)
                    
                    print(translation.src)
                    
                    DispatchQueue.main.async {
                        callback(translation)
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
