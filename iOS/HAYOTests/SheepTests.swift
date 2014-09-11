//
//  SheepTests.swift
//  SheepTests
//
//  Created by mono on 7/24/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Quick
import Nimble

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("the table of contents below") {
            it("has everything you need to get started") {
                expect("Quick: Examples and Example Groups").to(contain("Quick: Examples and Example Groups"))
            }
            
            context("if it doesn't have what you're looking for") {
                it("needs to be updated") {
                    expect{true}.toEventually(beTruthy())
                }
            }
        }
    }
}
