//
//  ContentView.swift
//  ARKit_GPS_Sample
//
//  Created by スカラパートナーズ on 2021/12/23.
//

import SwiftUI
import RealityKit
import CoreLocation

struct ContentView : View {
    @StateObject var locationViewModel = LocationViewModel()
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    @StateObject var locationViewModel = LocationViewModel()

    func makeUIView(context: Context) -> ARView {

        locationViewModel.requestPermission()


        let arView = ARView(frame: .zero)
        return arView

    }

    var coordinate: CLLocationCoordinate2D? {
        locationViewModel.lastSeenLocation?.coordinate
    }
    var direction: CLHeading? {
        locationViewModel.lastSeenHeading
    }

    func calcObjectPosition()->[Double]{
        let currentLon = coordinate?.longitude ?? 0
        let currentLat = coordinate?.latitude ?? 0

        // 渋谷駅(ハチ公)
        let destinationLon = 139.70062762914785
        let destinationLat = 35.659082769308576

        let X = (destinationLon - currentLon) * 91287
        let Y = (destinationLat - currentLat) * -110940

        var phone_angle = direction?.magneticHeading ?? 0
        phone_angle = (phone_angle).truncatingRemainder(dividingBy: 360)
        let rad = phone_angle * Double.pi / 180

        let X_ = X * cos(rad) - Y * sin(rad)
        let Y_ = Y * cos(rad) + X * sin(rad)

        return [X_,Y_]
    }

    // 位置情報を取得してからオブジェクトを配置したい
    func updateUIView(_ uiView: ARView, context: Context) {
        if (coordinate?.longitude == nil){
            return
        }

        let arView = uiView
        // オブジェクトが配置されていなければ配置
        if(arView.scene.anchors.count==0){
            let diffs = calcObjectPosition()
            let x = Float(diffs[0])
            let z = Float(diffs[1])
            let distance = sqrt(x * x + z * z)

            let anchor = AnchorEntity()
            anchor.position = simd_make_float3(x, -0.5, z) //アンカーの位置(デバイスからの相対座標)

            let box = ModelEntity(mesh: .generateBox(size: simd_make_float3(30, 30, 30), cornerRadius: 0.03))
            box.transform = Transform(pitch: 0, yaw: 1, roll: 0)
            anchor.addChild(box)
            arView.scene.anchors.append(anchor)
        }
    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
