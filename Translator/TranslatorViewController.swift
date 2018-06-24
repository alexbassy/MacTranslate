//
//  TranslatorViewController.swift
//  Translator
//
//  Created by Alex Bass on 16/06/2018.
//  Copyright © 2018 Alex Bass. All rights reserved.
//

import Cocoa

class TranslatorViewController: NSViewController {
    @IBOutlet var sourceInput: NSTextField?
    
    @IBOutlet var translationOutput: NSTextField?
    
    @IBOutlet var translateButton: NSButton?
    
    @IBOutlet var sourceLanguageSelect: NSPopUpButton?
    
    @IBOutlet var targetLanguageSelect: NSPopUpButton?
    
    @IBOutlet var swapLanguageButton: NSPopUpButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let languageNames = TranslatorAPI.languageNames
        sourceLanguageSelect?.addItems(withTitles: languageNames)
        targetLanguageSelect?.addItems(withTitles: languageNames)
    }
}

extension TranslatorViewController {
    static func freshController () -> TranslatorViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "TranslatorViewController")
        guard let viewController = storyboard.instantiateController(withIdentifier: identifier) as? TranslatorViewController else {
            fatalError("TranslatorViewController not found. Check Main.storyboard")
        }
        return viewController
    }
}

extension TranslatorViewController {
    @IBAction func translate(_ sender: NSButton) {
        let selectedSourceLang = sourceLanguageSelect?.titleOfSelectedItem
        let selectedTargetLang = targetLanguageSelect?.titleOfSelectedItem
        
        guard let sourceText = sourceInput?.stringValue.trimmingCharacters(in: .whitespaces)
            else {
                print("Need to enter some text, silly")
                return
            }
        
        if sourceText.count > 1 {
            let sourceLangCode = TranslatorAPI.supportedLanguages[selectedSourceLang!] ?? "auto"
            let targetLangCode = TranslatorAPI.supportedLanguages[selectedTargetLang!] ?? "en"
            
            TranslatorAPI.translate(sourceText: sourceText,
                                    sourceLang: sourceLangCode,
                                    targetLang: targetLangCode) { [weak self] (sourceText, translation) in
                                        self?.translationOutput?.stringValue = translation
            }
        }
        
    }
}
