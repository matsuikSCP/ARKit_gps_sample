//
//  ErrorView.swift
//  ShowLocationSample
//
//  Created by スカラパートナーズ on 2021/12/23.
//

import SwiftUI

struct ErrorView: View {
    var errorText: String
    
    var body: some View {
        Text(errorText)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(errorText: "エラーメッセージ")
    }
}
