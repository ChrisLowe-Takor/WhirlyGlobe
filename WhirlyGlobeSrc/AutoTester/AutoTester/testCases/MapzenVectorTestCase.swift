//
//  MapzenVectorTestCase.swift
//  AutoTester
//
//  Created by jmnavarro on 29/10/15.
//  Copyright © 2015 mousebird consulting. All rights reserved.
//

import UIKit

class MapzenVectorTestCase: MaplyTestCase {

	override init() {
		super.init()

		self.name = "Mapzen Vectors"
		self.captureDelay = 5
		self.implementations = [ .map, .globe]
	}
    
    func setupMapzenLayer(_ baseVC: MaplyBaseViewController)
    {
        //let styleData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("MapzenGLStyle", ofType: "json")!)
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            
//            let styleData = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "MapzenSLDStyle", ofType: "sld")!))
            let styleData = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "cinnabar-style-more-labels", ofType: "yaml")!))
            
            let mzSource = MapzenSource(
                base: "http://vector.mapzen.com/osm",
                layers: ["all"],
                apiKey: "vector-tiles-ejNTZ28",
                sourceType: MapzenSourcePBF,
                styleData: styleData,
//                styleType: .sldStyle,
                styleType: .tangramStyle,
                viewC: baseVC)
            
            mzSource?.minZoom = Int32(0)
            mzSource?.maxZoom = Int32(24)
            
            let pageLayer = MaplyQuadPagingLayer(
                coordSystem: MaplySphericalMercator(),
                delegate: mzSource!)
            
            pageLayer?.numSimultaneousFetches = Int32(8)
            pageLayer?.flipY = false
            pageLayer?.importance = 512*512
            pageLayer?.useTargetZoomLevel = true
            pageLayer?.singleLevelLoading = true
            baseVC.add(pageLayer!)
            
        });
    }
    
    override func setUpWithGlobe(_ globeVC: WhirlyGlobeViewController) {
        let baseLayer = CartoDBLightTestCase()
        baseLayer.setUpWithGlobe(globeVC)

        setupMapzenLayer(globeVC)

        globeVC.animate(toPosition: MaplyCoordinateMakeWithDegrees(-122.290,37.7793), height: 0.0005, heading: 0.0, time: 0.1)
    }

	override func setUpWithMap(_ mapVC: MaplyViewController) {
		let baseLayer = CartoDBLightTestCase()
		baseLayer.setUpWithMap(mapVC)
        
        setupMapzenLayer(mapVC)
        
        mapVC.animate(toPosition: MaplyCoordinateMakeWithDegrees(-122.290,37.7793), height: 0.0005, time: 0.1)
	}

}
