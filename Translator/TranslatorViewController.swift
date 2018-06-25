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
    
    @IBOutlet var swapLanguageButton: NSButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let languageNames = TranslatorAPI.languageNames
        sourceLanguageSelect?.addItem(withTitle: TranslatorAPI.AUTO_LANGUAGE)
        sourceLanguageSelect?.addItems(withTitles: languageNames)
        targetLanguageSelect?.addItems(withTitles: languageNames)
    }
    
    func didReceiveTranslation(_ translation: Translation?) {
        if let translation = translation {
            translationOutput?.stringValue = translation.translation
            if sourceLanguageSelect?.titleOfSelectedItem == TranslatorAPI.AUTO_LANGUAGE {
                if let sourceLanguageName = TranslatorAPI.getLanguageNameByCode(translation.src) {
                    self.sourceLanguageSelect?.selectedItem?.title = "\(TranslatorAPI.AUTO_LANGUAGE) (\(sourceLanguageName))"
                }
            }
        }
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
            let sourceLangCode = TranslatorAPI.supportedLanguages[selectedSourceLang!] ?? TranslatorAPI.AUTO_LANGUAGE_CODE
            let targetLangCode = TranslatorAPI.supportedLanguages[selectedTargetLang!] ?? TranslatorAPI.DEFAULT_TARGET_LANGUAGE
            
            TranslatorAPI.translate(sourceText: sourceText,
                                    sourceLang: sourceLangCode,
                                    targetLang: targetLangCode) { [weak self] (translation) in
                                        self?.didReceiveTranslation(translation)
            }
        }
        
    }
    
    @IBAction func swapSourceAndTargetLanguages(_ sender: NSButton) {
        guard let sourceLanguageName = sourceLanguageSelect?.titleOfSelectedItem, let targetLanguageName = targetLanguageSelect?.titleOfSelectedItem
            else {
                return
        }
        
        if sourceLanguageName == TranslatorAPI.AUTO_LANGUAGE {
            return
        }
        
        let targetLanguageInSourceSelectIndex = sourceLanguageSelect?.indexOfItem(withTitle: targetLanguageName)
        let sourceLanguageInTargetSelectIndex = targetLanguageSelect?.indexOfItem(withTitle: sourceLanguageName)
        
        if let newSourceIndex = targetLanguageInSourceSelectIndex, let newTargetIndex = sourceLanguageInTargetSelectIndex {
            sourceLanguageSelect?.selectItem(at: newSourceIndex)
            targetLanguageSelect?.selectItem(at: newTargetIndex)
        }
    }
}
