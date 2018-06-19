//
//  TranslatorViewController.swift
//  Translator
//
//  Created by Alex Bass on 16/06/2018.
//  Copyright © 2018 Alex Bass. All rights reserved.
//

import Cocoa

class TranslatorViewController: NSViewController {
    @IBOutlet var sourceInput: NSTextField!
    
    @IBOutlet var translationOutput: NSTextField!
    
    @IBOutlet var translateButton: NSButton!
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
    @IBAction func quit(_ sender: NSButton) {
        NSApplication.shared.terminate(sender)
    }
    
    @IBAction func translate(_ sender: NSButton) {
        let source = sourceInput.stringValue
        if source.count > 0 {
            TranslatorAPI.translate(sourceText: source,
                                    sourceLang: "en",
                                    targetLang: "de") { (sourceText, translation) in
                self.translationOutput.stringValue = translation
            }
        }
    }
}
