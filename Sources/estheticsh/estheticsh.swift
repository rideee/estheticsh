import ArgumentParser
import Foundation
import Rainbow


// StandardErrorOutputStream global instance.
let stderr = StandardErrorOutputStream(
    appName: PkgInfo.name,
    appVersion: PkgInfo.version,
    errorMsgFooter: "\nRun:\n    \(PkgInfo.name) --help"
)


@main
struct Estheticsh: ParsableCommand {
    
    // App config.
    static let configuration = CommandConfiguration(
        abstract: "\n" + PkgInfo.description,
        discussion: PkgInfo.fullDescription,
        version: PkgInfo.version
    )
        
    // Arguments.
    @Argument(help: "User text input (Default: '' empty string).")
    var text: String = ""
    
    // Options.
    @Option(name: .shortAndLong, help: "Foreground text color.")
    var color: String? = nil
    @Option(name: .shortAndLong, help: "Background text color.")
    var bgColor: String? = nil
   
    // Flags.
    @Flag(name: .long, help: "Print all available color names.")
    var colors = false
    @Flag(name: .long, help: "Print usage examples.")
    var examples = false
    @Flag(name: .long, help: "Print the original name of this application.")
    var name = false
    @Flag(name: .long, help: "Print the app author information.")
    var author = false
    @Flag(name: .long, help: "Print the link to the application repository.")
    var repository = false
    
    
    // App main.
    mutating func run() throws {
        
        // Dependent on the given flags - information printouts.
        if name { print(PkgInfo.name); Estheticsh.exit() }
        if author { print(PkgInfo.author); Estheticsh.exit() }
        if repository { print(PkgInfo.repository); Estheticsh.exit() }
        if colors { printAllColors(); Estheticsh.exit() }

        
        // Exit app with error, if the "text" argument is not given.
        if text == "" {
            stderr.printError("Required argument.")
            Estheticsh.exit(
                withError: ExitCode(rawValue: PkgInfo.ExitCode.requiredArgument.rawValue)
            )
        }
    }
    
    
    // Print all available color names.
    func printAllColors() {
        let minLength = 20
        let header = "Name:" + String(repeating: " ", count: minLength - 5) + "Option:"
        let marginLeft = String(repeating: " ", count: 2)
        var colorNameLength = 0
        var colorNameString = ""
             
        // Background colors.
        print("\n---- Background Colors ----\n\(header)")
        for b in BackgroundColor.allCases {
            colorNameLength = "\(b)".count
            colorNameString = marginLeft + "\(b)"
            colorNameString += String(
                repeating: " ",
                count: minLength - colorNameLength - marginLeft.count
            )
            
            // Change the foreground color for better visibility in some cases.
            if  b != BackgroundColor.black &&
                b != BackgroundColor.default &&
                b != BackgroundColor.lightBlack
            {
                colorNameString = colorNameString.applyingColor(Color.black)
            }
            
            print(
                colorNameString.applyingBackgroundColor(b) +
                marginLeft + "-b \(b)"
            )
        }
        
        // Foreground colors.
        print("\n---- Foreground Colors ----\n\(header)")
        for c in Color.allCases {
            colorNameLength = "\(c)".count
            colorNameString = "\(c)"
            
            // If fg color is black, change background color for better visibility.
            if c == Color.black {
                colorNameString = colorNameString
                    .applyingBackgroundColor(BackgroundColor.lightBlack)
            }
            
            colorNameString = marginLeft + colorNameString
            colorNameString += String(repeating: " ", count: minLength - colorNameLength)
            
            print(colorNameString.applyingColor(c) + "-c \(c)")
        }
        
        // Blank line.
        print()
    }
    
}


