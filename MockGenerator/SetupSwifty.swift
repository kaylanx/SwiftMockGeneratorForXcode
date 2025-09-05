import Foundation
import var SwiftyKit.resolverFactory
import var SwiftyKit.formatterFactory
import var SwiftyKit.makeService
import var SwiftyKit.makeDeserializer
import var SwiftyKit.parserFactory
import class SwiftyKit.FormatterFactory
import class SwiftyKit.ParserFactory
import class Resolver.ResolverFactory
import class ASTSerialize.ASTDeserializer
import class SwiftyServiceImpl.SwiftyServiceImpl

public func setUpSwifty(projectURL: URL, useTabs: Bool, indentationWidth: Int) {
    let sourceFiles = SourceFileFinder(projectRoot: projectURL).findSourceFiles()
    resolverFactory = .init {
        ResolverFactory.createResolver(filePaths: filterUniqueFileNames(sourceFiles))
    }
    formatterFactory = FormatterFactory {
        DefaultFormatter(useTabs: useTabs, indentationWidth: indentationWidth)
    }
    makeService = { SwiftyServiceImpl() }
    makeDeserializer = { ASTDeserializer() }
    parserFactory = ParserFactory { PositionParser() }
}

private func filterUniqueFileNames(_ fileNames: [URL]) -> [String] {
    var sourceFileSet = Set<String>()
    return fileNames.map { file in
        (file.path, file.lastPathComponent)
    }.compactMap { (file, name) in
        if sourceFileSet.contains(name) {
            return nil
        }
        sourceFileSet.insert(name)
        return file
    }
}
