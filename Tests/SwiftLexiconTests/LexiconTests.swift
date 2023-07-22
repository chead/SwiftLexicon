//
//  LexiconTests.swift
//  
//
//  Created by Christopher Head on 7/19/23.
//

import XCTest
@testable import SwiftLexicon

final class LexiconTests: XCTestCase {
    func testGetTimeline() throws {
        let getTimelineJSON =
        """
        {
          "lexicon": 1,
          "id": "app.bsky.feed.like",
          "defs": {
            "main": {
              "type": "record",
              "key": "tid",
              "record": {
                "type": "object",
                "required": [
                  "subject",
                  "createdAt"
                ],
                "properties": {
                  "subject": {
                    "type": "ref",
                    "ref": "com.atproto.repo.strongRef"
                  },
                  "createdAt": {
                    "type": "string",
                    "format": "datetime"
                  }
                }
              }
            }
          }
        }
        """.data(using: .utf8)!
        
        let lexicon = try JSONDecoder().decode(Lexicon.self, from: getTimelineJSON)

        XCTAssertEqual(lexicon.id, "app.bsky.feed.like")
    }
}
