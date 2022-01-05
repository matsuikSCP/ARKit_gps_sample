//
//  RequestLocation.swift
//  ShowLocationSample
//
//  Created by スカラパートナーズ on 2021/12/23.
//

import SwiftUI

struct RequestLocationView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    var body: some View {
        Button(action: {
            locationViewModel.requestPermission()
        }) {
            Text("位置情報の使用を許可する")
        }
    }
}

struct RequestLocationView_Previews: PreviewProvider {
    static var previews: some View {
        RequestLocationView().environmentObject(LocationViewModel())
    }
}
