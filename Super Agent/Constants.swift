//
//  Constants.swift
//  Super Agent
//
//  Created by Алексей Воронов on 30.01.2020.
//  Copyright © 2020 simonex. All rights reserved.
//

import Foundation

struct Constants {
    static let filtersSources: [FilterSource] = [
        FilterSource(name: "AdGuard Tracking Protection 1", // Filter name
                     url: "https://filters.adtidy.org/ios/filters/15_optimized.txt", // Filter url
                     description: "The most comprehensive list", // Filter description shows in UI
                     free: true,    //  Free or Premium list
                     activate: true), // Is avtivate by default
        FilterSource(name: "AdGuard Tracking Protection 2",
                     url: "https://filters.adtidy.org/ios/filters/3_optimized.txt",
                     description: "The most comprehensive list of various online counters and web analytics tools",
                     free: true,
                     activate: false),
//        FilterSource(name: "AdGuard Tracking Protection 3",
//                     url: "https://filters.adtidy.org/ios/filters/3_optimized.txt",
//                     description: "The most comprehensive list of various online counters and web analytics tools",
//                     free: false,
//                     activate: false),
        FilterSource(name: "AdGuard Tracking Protection 4",
                     url: "https://filters.adtidy.org/ios/filters/4_optimized.txt",
                     description: "The most comprehensive list of various online counters and web analytics tools",
                     free: true,
                     activate: false)
    ]
    struct Links {
        static let privacyPolicy = ""
        static let termsOfUse = ""
    }
    
    static let supportEmail = ""
}
