var Action = function() {};

Action.prototype = {
    
    run: function(arguments) {
        arguments.completionFunction({ "location" : location.href })
    },
    
    finalize: function(arguments) {
        
        var location = arguments["location"]
        if (location) {
            window.location = location
        }
    }
    
};
    
var ExtensionPreprocessingJS = new Action
