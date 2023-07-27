//
//  LexiconTests.swift
//  
//
//  Created by Christopher Head on 7/19/23.
//

import XCTest
@testable import SwiftLexicon

final class LexiconTests: XCTestCase {
    func testGetPosts() throws {
        let getPostsJSON =
        """
        {
          "lexicon": 1,
          "id": "app.bsky.feed.getPosts",
          "defs": {
            "main": {
              "type": "query",
              "description": "A view of an actor's feed.",
              "parameters": {
                "type": "params",
                "required": [
                  "uris"
                ],
                "properties": {
                  "uris": {
                    "type": "array",
                    "items": {
                      "type": "string",
                      "format": "at-uri"
                    },
                    "maxLength": 25
                  }
                }
              },
              "output": {
                "encoding": "application/json",
                "schema": {
                  "type": "object",
                  "required": [
                    "posts"
                  ],
                  "properties": {
                    "posts": {
                      "type": "array",
                      "items": {
                        "type": "ref",
                        "ref": "app.bsky.feed.defs#postView"
                      }
                    }
                  }
                }
              }
            }
          }
        }
        """.data(using: .utf8)!
        
        let lexicon = try JSONDecoder().decode(Lexicon.self, from: getPostsJSON)
        
        XCTAssertEqual(lexicon.id, "app.bsky.feed.getPosts")
    }

    func testCreateSession() throws {
        let createSessionJSON =
        """
        {
          "lexicon": 1,
          "id": "com.atproto.server.createSession",
          "defs": {
            "main": {
              "type": "procedure",
              "description": "Create an authentication session.",
              "input": {
                "encoding": "application/json",
                "schema": {
                  "type": "object",
                  "required": [
                    "identifier",
                    "password"
                  ],
                  "properties": {
                    "identifier": {
                      "type": "string",
                      "description": "Handle or other identifier supported by the server for the authenticating user."
                    },
                    "password": {
                      "type": "string"
                    }
                  }
                }
              },
              "output": {
                "encoding": "application/json",
                "schema": {
                  "type": "object",
                  "required": [
                    "accessJwt",
                    "refreshJwt",
                    "handle",
                    "did"
                  ],
                  "properties": {
                    "accessJwt": {
                      "type": "string"
                    },
                    "refreshJwt": {
                      "type": "string"
                    },
                    "handle": {
                      "type": "string",
                      "format": "handle"
                    },
                    "did": {
                      "type": "string",
                      "format": "did"
                    },
                    "email": {
                      "type": "string"
                    }
                  }
                }
              },
              "errors": [
                {
                  "name": "AccountTakedown"
                }
              ]
            }
          }
        }
        """.data(using: .utf8)!
        
        let lexicon = try JSONDecoder().decode(Lexicon.self, from: createSessionJSON)
        
        XCTAssertEqual(lexicon.id, "com.atproto.server.createSession")
    }
}
