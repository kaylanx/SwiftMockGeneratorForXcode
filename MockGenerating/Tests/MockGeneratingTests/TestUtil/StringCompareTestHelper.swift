import Foundation
import Testing

public enum StringCompareTestHelper {

    private static let tempDir = NSTemporaryDirectory() + "codes.seanhenry.mockgenerator"

    private static func actualPath() -> String { "\(tempDir)/\(UUID().uuidString)-actual.txt" }

    private static func expectedPath() -> String { "\(tempDir)/\(UUID().uuidString)-expected.txt" }

    public static func expectEqualStrings(
        _ actual: String?,
        _ expected: String?
    ) {
        #expect(actual == expected)
        guard let actual, let expected, actual != expected else { return }
        try? FileManager.default.createDirectory(
            atPath: tempDir,
            withIntermediateDirectories: false,
            attributes: nil
        )
        let actualPath = self.actualPath()
        let expectedPath = self.expectedPath()
        try? actual.data(using: .utf8)?.write(to: URL(fileURLWithPath: actualPath))
        try? expected.data(using: .utf8)?.write(to: URL(fileURLWithPath: expectedPath))
        let process = Process()
        process.launchPath = "/usr/bin/opendiff"
        process.arguments = [actualPath, expectedPath]
        process.launch()
    }
}
