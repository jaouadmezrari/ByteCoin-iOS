//
//  RateData.swift
//  ByteCoin
//
//  Created by Abdeljaouad Mezrari on 30/02/2023.
//  Copyright © 2023 Abdeljaouad Mezrari. All rights reserved.
//

import Foundation

struct RateData: Codable{
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
