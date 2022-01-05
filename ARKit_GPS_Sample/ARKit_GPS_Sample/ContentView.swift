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
//        print(ARConfiguration.WorldAlignment.gravityAndHeading)
        
        print("1経度：" + String(coordinate?.longitude ?? 0))
        print("1緯度：" + String(coordinate?.latitude ?? 0))
        
        let arView = ARView(frame: .zero)
        
//        let anchor = AnchorEntity()
//        anchor.position = simd_make_float3(0, -0.5, -1) //アンカーの位置(デバイスからの相対座標)
//
//        let box = ModelEntity(mesh: .generateBox(size: simd_make_float3(0.3, 0.1, 0.2), cornerRadius: 0.03))
//        box.transform = Transform(pitch: 0, yaw: 1, roll: 0)
//
//        anchor.addChild(box)
//        arView.scene.anchors.append(anchor)

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
        
        // 大岡山駅
        let destinationLon = 139.68568724894678
        let destinationLat = 35.607606899236494
        
        let X = (destinationLon - currentLon) * 91287
        let Y = (destinationLat - currentLat) * -110940
        
        var phone_angle = direction?.magneticHeading ?? 0
        phone_angle = (phone_angle + 130).truncatingRemainder(dividingBy: 360) // スマホ壊れてるので加算
        let rad = phone_angle * Double.pi / 180
        
        let X_ = X * cos(rad) - Y * sin(rad)
        let Y_ = Y * cos(rad) + X * sin(rad)
        
        return [10, -50]
        return [X_,Y_]
    }
    
    // 位置情報を取得してからオブジェクトを配置したい
    // TODO:大きさ
    // TODO:文字表示(mは可変に)
    func updateUIView(_ uiView: ARView, context: Context) {
        print("UPDATE")
//        print("2経度：" + String(coordinate?.longitude ?? 0))
//        print("2緯度：" + String(coordinate?.latitude ?? 0))
//        print("方角:" + String(direction?.magneticHeading ?? 0))
        if (coordinate?.longitude == nil){
            return
        }
        
        
        let arView = uiView
        if(arView.scene.anchors.count==0){
            print("First")
            let diffs = calcObjectPosition()
            let x = Float(diffs[0])
            let z = Float(diffs[1])
            print("座標")
            print(x,z)
            let distance = sqrt(x * x + z * z)
            
            let anchor = AnchorEntity()
            print("anchor_type01：" + String(describing: type(of: anchor)))
            anchor.position = simd_make_float3(x, -0.5, z) //アンカーの位置(デバイスからの相対座標)
            
            let box = ModelEntity(mesh: .generateBox(size: simd_make_float3(30, 30, 30), cornerRadius: 0.03))
            box.transform = Transform(pitch: 0, yaw: 1, roll: 0)
            anchor.addChild(box)
            arView.scene.anchors.append(anchor)
        }else{
            print("already")
            var anchor:Entity = arView.scene.anchors.first!
            print("anchor_type02：" + String(describing: type(of: anchor)))
//            anchor.position = simd_make_float3(0, -0.5, -100)
//            let box = ModelEntity(mesh: .generateBox(size: simd_make_float3(30, 30, 30), cornerRadius: 0.03))
//            box.transform = Transform(pitch: 0, yaw: 1, roll: 0)
//            anchor.addChild(box)
        }
//        return arView
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
