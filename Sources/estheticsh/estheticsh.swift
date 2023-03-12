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
    
    // Flag character definition.
    struct FlagChar {
        static let color = Character("c")
        static let bgColor = Character("b")
        static let bold = Character("B")
        static let dim = Character("d")
        static let italic = Character("i")
        static let underline = Character("u")
        static let blink = Character("k")
        static let swap = Character("s")
        static let strikethrough = Character("S")
        static let noNewLine = Character("n")
        static let toStderr = Character("e")
    }
    
    var flagInfo = false

    
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
    @Option(name: .customShort(FlagChar.color), help: "Foreground text color.")
    var color: String? = nil
    @Option(name: .customShort(FlagChar.bgColor), help: "Background text color.")
    var bgColor: String? = nil
   
    // Flags.
    @Flag(name: .customShort(FlagChar.bold), help: "Text bold style.")
    var styleBold = false
    @Flag(name: .customShort(FlagChar.dim), help: "Text dim style.")
    var styleDim = false
    @Flag(name: .customShort(FlagChar.italic), help: "Text italic style.")
    var styleItalic = false
    @Flag(name: .customShort(FlagChar.underline), help: "Text underline style.")
    var styleUnderline = false
    @Flag(name: .customShort(FlagChar.blink), help: "Text blink style.")
    var styleBlink = false
    @Flag(name: .customShort(FlagChar.swap), help: "Text swap style.")
    var styleSwap = false
    @Flag(name: .customShort(FlagChar.strikethrough), help: "Text strikethrough style.")
    var styleStrikethrough = false
    @Flag(name: .customShort(FlagChar.noNewLine), help: "No new line character at the end.")
    var noNewLine = false
    @Flag(name: .customShort(FlagChar.toStderr), help: "Print output to stderr.")
    var toStderr = false
    @Flag(name: .long, help: "Print all available colors.")
    var colors = false
    @Flag(name: .long, help: "Print all available styles.")
    var styles = false
    @Flag(name: .long, help: "Print the original name of this application.")
    var name = false
    @Flag(name: .long, help: "Print the app author information.")
    var author = false
    @Flag(name: .long, help: "Print the link to the application repository.")
    var repository = false
    
    
    // App main.
    mutating func run() throws {
        
        // Dependent on the given flags - information printouts.
        if name { print(PkgInfo.name); flagInfo = true }
        if author { print(PkgInfo.author); flagInfo = true }
        if repository { print(PkgInfo.repository); flagInfo = true }
        if colors { printAllColors(); flagInfo = true }
        if styles { printAllStyles(); flagInfo = true }
        // Exit app, if some info has been printed.
        if flagInfo { Estheticsh.exit() }
        
        // Exit app with error, if the "text" argument is not given.
        if text == "" {
            stderr.printError("Required argument.")
            Estheticsh.exit(
                withError: ExitCode(rawValue: PkgInfo.ExitCode.requiredArgument.rawValue)
            )
        }
        
        // Print output.
        parseAndPrint()
    }
    
    
    // Parse all given information and print output.
    func parseAndPrint() {
        var output = self.text
        let terminator = self.noNewLine ? "" : "\n"
        
        // Foreground color. Apply color only if given color name exists in NamedColor (Rainbow).
        if let color {
            for c in Color.allCases {
                if color == "\(c)" {
                    output = output.applyingColor(c)
                }
            }
        }
        
        // Background color. Apply color only if given color name exists in NamedColor (Rainbow).
        if let bgColor {
            for b in BackgroundColor.allCases {
                if bgColor == "\(b)" {
                    output = output.applyingBackgroundColor(b)
                }
            }
        }
        
        // Styles.
        if styleBold            { output = output.applyingStyle(.bold) }
        if styleDim             { output = output.applyingStyle(.dim) }
        if styleItalic          { output = output.applyingStyle(.italic) }
        if styleUnderline       { output = output.applyingStyle(.underline) }
        if styleBlink           { output = output.applyingStyle(.blink) }
        if styleSwap            { output = output.applyingStyle(.swap) }
        if styleStrikethrough   { output = output.applyingStyle(.strikethrough) }
        
        // Print output.
        if self.toStderr {
            stderr.write(output + terminator)
        } else {
            print(output, terminator: terminator)
        }
    }
    
    
    // Print all available colors.
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
    
    
    // Print all available styles.
    func printAllStyles() {
        let minLength = 36
        let marginLeft = String(repeating: " ", count: 2)
        let bannerText = " Styles "
        let header = "Style:" + String(repeating: " ", count: minLength - 5) + "Option:"
        
        // Dictionary key: Style, value: flag.
        let stylesDict = [
            Style.bold: "-\(FlagChar.bold)",
            Style.dim: "-\(FlagChar.dim)",
            Style.italic: "-\(FlagChar.italic)",
            Style.underline: "-\(FlagChar.underline)",
            Style.blink: "-\(FlagChar.blink)",
            Style.swap: "-\(FlagChar.swap)",
            Style.strikethrough: "-\(FlagChar.strikethrough)",
        ]
        
        func printStyleRow(style: Style, flag: String) {
            let text = "This is a '\(style)' style."
            
            print(
                marginLeft + text.applyingStyle(style) +
                String(repeating: " ", count: minLength - text.count) +
                flag
            )
        }
        
        // Print banner.
        print(
            "\n" +
            String(repeating: "-", count: (header.count - bannerText.count) / 2) +
            bannerText +
            String(repeating: "-", count: (header.count - bannerText.count) / 2) +
            "\n\(header)"
        )
        
        // Print style rows.
        printStyleRow(style: Style.default, flag: "")   // Separated to keep this row on top.
        
        for (s, f) in stylesDict {
            printStyleRow(style: s, flag: f)
        }
        
        // Blank line.
        print()
    }
    
}


