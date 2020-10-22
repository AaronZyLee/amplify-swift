//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import Amplify
@testable import AmplifyTestCommon

@available(iOS 13.0.0, *)
class DevMenuExtensionTests: XCTestCase {
    let provider = MockDevMenuContextProvider()
    override func setUp() {
        do {
            Amplify.enableDevMenu(contextProvider: provider)

            /// After Amplify.reset() is called in teardown(), Amplify.configure() doesn't
            /// initialize the plugin for LoggingCategory . This doesn't call Amplify.getLoggingCategoryPlugin()
            /// and the plugin is not updated to PersistentLoggingPlugin. Making a call to
            /// add() so that configure() updates the plugin
            try Amplify.add(plugin: AWSUnifiedLoggingPlugin())

            try Amplify.configure(AmplifyConfiguration())
        } catch {
            XCTFail("Failed \(error)")
        }
    }
    ///  Test if dev menu is enabled
    ///
    /// - Given:  Amplify is configured with Dev Menu enabled
    /// - When:
    ///    - I check whether dev menu is enabled
    /// - Then:
    ///    -  isDevMenuEnabled() should return true
    ///
    func testAmplifyInit() {
        XCTAssertTrue(Amplify.isDevMenuEnabled())
    }
    /// Test if PersistentLoggingPlugin is returned on enabling dev menu
    ///
    /// - Given:  Amplify is configured with Dev Menu enabled
    /// - When:
    ///    - I check the type of LoggingCategoryPlugin
    /// - Then:
    ///    - It should be of PersistentLoggingPlugin type
    ///
    func testLoggingCategoryPlugin() throws {
        let devMenuPlugin = try Amplify.Logging.getPlugin(for: DevMenuStringConstants.persistentLoggingPluginKey)
        XCTAssertTrue(devMenuPlugin is PersistentLoggingPlugin)
    }
    override func tearDown() {
        Amplify.reset()
    }
}
