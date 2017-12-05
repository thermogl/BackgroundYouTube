import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    
    func beginRequest(with context: NSExtensionContext) {
        
        var found = false
        
        // Find the item containing the results from the JavaScript preprocessing.
        outer:
            for item in context.inputItems as! [NSExtensionItem] {
                if let attachments = item.attachments {
                    for itemProvider in attachments as! [NSItemProvider] {
                        if itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypePropertyList)) {
                            itemProvider.loadItem(forTypeIdentifier: String(kUTTypePropertyList), options: nil, completionHandler: { (item, error) in
                                let dictionary = item as! [String: Any]
                                let processed = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! [String: Any]? ?? [:]
                                OperationQueue.main.addOperation {
                                    self.itemLoadCompletedWithPreprocessingResults(processed, context: context)
                                }
                            })
                            found = true
                            break outer
                        }
                    }
                }
        }
        
        if !found {
            self.doneWithResults(nil, context: context)
        }
    }
    
    func itemLoadCompletedWithPreprocessingResults(_ javaScriptPreprocessingResults: [String: Any], context: NSExtensionContext) {
        
        let anyLocation: Any? = javaScriptPreprocessingResults["location"]
        if let location = anyLocation as? String {
            let fullLocation = "backgroundYT://" + (location.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
            self.doneWithResults(["location": fullLocation], context: context)
        } else {
            self.doneWithResults(nil, context: context)
        }
    }
    
    func doneWithResults(_ resultsForJavaScriptFinalizeArg: [String: Any]?, context: NSExtensionContext) {
        if let resultsForJavaScriptFinalize = resultsForJavaScriptFinalizeArg {
            
            let resultsDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: resultsForJavaScriptFinalize]
            let resultsProvider = NSItemProvider(item: resultsDictionary as NSDictionary, typeIdentifier: String(kUTTypePropertyList))
            
            let resultsItem = NSExtensionItem()
            resultsItem.attachments = [resultsProvider]
            
            context.completeRequest(returningItems: [resultsItem], completionHandler: nil)
        } else {
            context.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
}
