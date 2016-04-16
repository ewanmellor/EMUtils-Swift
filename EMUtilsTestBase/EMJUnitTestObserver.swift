//
//  EMJUnitTestObserver.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/15/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import AEXML
import EMUtils
import XCTest


/**
 * An XCTestObserver that emits a test report in JUnit format.
 */
@available(*, deprecated)
@objc(EMJUnitTestObserver)
public class EMJUnitTestObserver: XCTestObserver {
    private class RunInfo {
        private var failures: [String: String]?
        private var failureLocations: [String: String]?
        private var logs: [String: [String]]?
    }

    private let reportDestination: NSURL

    private var suites = [XCTestSuiteRun]()
    private var suiteRunInfo = [RunInfo]()
    private var suiteFailures: [String: String]?
    private var suiteFailureLocations = [String: String]()
    private var suiteLogs = [String: [String]]()
    private var topRun: XCTestRun!

    override init() {
        self.reportDestination = getReportDest()
        super.init()
    }

    override public func startObserving() {
        super.startObserving()

        suites.removeAll()
        suiteRunInfo.removeAll()
    }


    override public func stopObserving() {
        writeReport()

        suites.removeAll()
        suiteRunInfo.removeAll()

        super.stopObserving()
    }


    override public func testSuiteDidStart(testRun: XCTestRun!) {
        suiteFailures = [String: String]()
        suiteFailureLocations.removeAll()
        suiteLogs.removeAll()
    }


    override public func testSuiteDidStop(testRun: XCTestRun!) {
        if suiteFailures == nil {
            // XCTest has nested suites -- the "All tests" suite is
            // outermost, then your project, then the class.
            // We flatten all this, ignoring all the outer ones, because
            // they aren't representable in the JUnit format.
            topRun = testRun
            return
        }

        if testRun.testCaseCount > 0 {
            suites.append(testRun as! XCTestSuiteRun)
            let runInfo = RunInfo()
            runInfo.failures = suiteFailures
            runInfo.failureLocations = suiteFailureLocations
            runInfo.logs = suiteLogs
            suiteRunInfo.append(runInfo)
        }

        suiteFailures = nil
        suiteFailureLocations.removeAll()
        suiteLogs.removeAll()
    }


    override public func testCaseDidStart(testRun: XCTestRun!) {
        super.testCaseDidStart(testRun)
    }


    override public func testCaseDidStop(testRun: XCTestRun!) {
        suiteLogs[testRun.test.name!] = [String]()
    }


    override public func testCaseDidFail(testRun: XCTestRun!, withDescription description: String!, inFile filePath: String!, atLine lineNumber: UInt) {
        let name = testRun.test.name!
        suiteFailures![name] = description
        suiteFailureLocations[name] = "\(filePath):\(lineNumber)"
    }


    private func writeReport() {
        let doc = AEXMLDocument()
        let attrs = testSuiteRunAttrs(topRun)
        let suitesEl = doc.addChild(name: "testsuites", value: nil, attributes: attrs)

        Enumerate.pairwiseOver(suites, and: suiteRunInfo, block: { (suite, runInfo) in
            let _ = suitesEl.addChild(testSuiteRunToXML(suite, failures: runInfo.failures, failureLocations: runInfo.failureLocations, logs: runInfo.logs))
        })

        do {
            try doc.xmlString.writeToURL(reportDestination, atomically: false, encoding: NSUTF8StringEncoding)
            NSLog("Test results written to \(reportDestination)")
        }
        catch let exn {
            NSLog("Failed to write test results to \(reportDestination): \(exn)")
        }
    }
}


private let testNameRE = try! NSRegularExpression(pattern: "^-\\[[^ ]+ (.*)\\]$", options: [])


private func testSuiteRunToXML(suiteRun: XCTestSuiteRun, failures: [String: String]?, failureLocations: [String: String]?, logs: [String: [String]]?) -> AEXMLElement {
    let attrs = testSuiteRunAttrs(suiteRun)
    let result = AEXMLElement("testsuite", value: nil, attributes: attrs)

    for testRun in suiteRun.testRuns {
        let name = testRun.test.name!
        let testRunEl = testRunToXML(testRun, failures?[name], failureLocations?[name], logs?[name])
        result.addChild(testRunEl)
    }

    return result
}


private func testRunToXML(testRun: XCTestRun, _ failure: String?, _ failureLocation: String?, _ logs: [String]?) -> AEXMLElement {

    let testName = testRun.test.name!
    let matches = testNameRE.matchesInString(testName, options: [], range: NSMakeRange(0, testName.utf16.count))

    var bareTestName: String
    if matches.count > 0 {
        let match = matches[0]
        bareTestName = (testName as NSString).substringWithRange(match.rangeAtIndex(1))
    }
    else {
        bareTestName = testName
    }

    var attrs = [
        "name": bareTestName,
        "classname": NSStringFromClass(testRun.test.dynamicType.self),
        "time": String(testRun.testDuration),
    ]
    if let startDate = testRun.startDate {
        attrs["timestamp"] = startDate.iso8601String_24
    }
    let result = AEXMLElement("testcase", value: nil, attributes: attrs)

    if let failureEl = failureToXML(failure, failureLocation) {
        result.addChild(failureEl)
    }

//    if logs.count > 0 {
        #if false
            //                result.addChild(AEXMLElement("system-out", cdata:[logs componentsJoinedByString:"\n"]]];
        #endif
//    }

    return result;
}


private func failureToXML(msg: String?, _ location: String?) -> AEXMLElement? {
    if msg == nil && location == nil {
        return nil
    }

    var attrs = ["type": "Failure"]
    if (msg != nil) {
        attrs["message"] = msg
    }
    return AEXMLElement("failure", value: location, attributes: attrs)
}


private func testSuiteRunAttrs(run: XCTestRun) -> [String: String] {
    var attrs = [
        "name": run.test.name!,
        "tests": String(run.testCaseCount),
        "errors": String(run.unexpectedExceptionCount),
        "failures": String(run.failureCount),
        "time": String(run.testDuration),
    ]
    if let startDate = run.startDate {
        attrs["timestamp"] = startDate.iso8601String_24
    }
    return attrs
}


private func getReportDest() -> NSURL {
    if let dest = NSProcessInfo().environment["EMJUnitTestObserverReportDestination"] where dest != "" {
        return NSURL(fileURLWithPath: dest)
    }

    let cwd = NSURL(fileURLWithPath: NSFileManager.defaultManager().currentDirectoryPath)
    return cwd.URLByAppendingPathComponent("test-report.xml")
}
