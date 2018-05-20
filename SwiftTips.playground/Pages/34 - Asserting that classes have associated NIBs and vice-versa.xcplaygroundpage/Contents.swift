//: [Previous](@previous)

/*
 Most of the time, when we create a `.xib` file, we give it the
 same name as its associated class. From that, if we later
 refactor our code and rename such a class, we run the risk of
 forgetting to rename the associated `.xib`.
 
 While the error will often be easy to catch, if the `.xib` is
 used in a remote section of its app, it might go unnoticed for
 sometime. Fortunately it's possible to build custom test
 predicates that will assert that 1) for a given class, there
 exists a `.nib` with the same name in a given `Bundle`, 2) for
 all the `.nib` in a given `Bundle`, there exists a class with
 the same name.
 */

import XCTest

public func XCTAssertClassHasNib(_ class: AnyClass, bundle: Bundle, file: StaticString = #file, line: UInt = #line) {
    let associatedNibURL = bundle.url(forResource: String(describing: `class`), withExtension: "nib")
    
    XCTAssertNotNil(associatedNibURL, "Class \"\(`class`)\" has no associated nib file", file: file, line: line)
}

public func XCTAssertNibHaveClasses(_ bundle: Bundle, file: StaticString = #file, line: UInt = #line) {
    guard let bundleName = bundle.infoDictionary?["CFBundleName"] as? String,
        let basePath = bundle.resourcePath,
        let enumerator = FileManager.default.enumerator(at: URL(fileURLWithPath: basePath),
                                                        includingPropertiesForKeys: nil,
                                                        options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants]) else { return }
    
    var nibFilesURLs = [URL]()
    
    for case let fileURL as URL in enumerator {
        if fileURL.pathExtension.uppercased() == "NIB" {
            nibFilesURLs.append(fileURL)
        }
    }
    
    nibFilesURLs.map { $0.lastPathComponent }
        .compactMap { $0.split(separator: ".").first }
        .map { String($0) }
        .forEach {
            let associatedClass: AnyClass? = bundle.classNamed("\(bundleName).\($0)")
            
            XCTAssertNotNil(associatedClass, "File \"\($0).nib\" has no associated class", file: file, line: line)
    }
}

XCTAssertClassHasNib(MyFirstTableViewCell.self, bundle: Bundle(for: AppDelegate.self))
XCTAssertClassHasNib(MySecondTableViewCell.self, bundle: Bundle(for: AppDelegate.self))

XCTAssertNibHaveClasses(Bundle(for: AppDelegate.self))

//: [Next](@next)
