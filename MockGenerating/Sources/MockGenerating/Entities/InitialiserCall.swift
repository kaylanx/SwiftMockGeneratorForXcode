//
//  InitialiserCall.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

struct InitialiserCall {

    let parameters: [Parameter]
    let isFailable: Bool
    let `async`: Bool
    let `throws`: Bool

    init(
        parameters: [Parameter],
        isFailable: Bool,
        `async`: Bool = false,
        `throws`: Bool = false
    ) {
        self.parameters = parameters
        self.isFailable = isFailable
        self.`async` = `async`
        self.`throws` = `throws`
    }
}
