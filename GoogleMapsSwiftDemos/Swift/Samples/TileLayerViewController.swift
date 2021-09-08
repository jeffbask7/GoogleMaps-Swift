// Copyright 2020 Google LLC. All rights reserved.
//
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.

import GoogleMaps
import UIKit

final class TileLayerViewController: UIViewController {
  private var selectedIndex = 0 {
    didSet {
      updateTileLayer()
    }
  }
  private var tileLayer: GMSURLTileLayer?

  private lazy var mapView: GMSMapView = {
    let camera = GMSCameraPosition(latitude: 30.00, longitude: -90.00, zoom: 7)
    return GMSMapView(frame: .zero, camera: camera)
  }()

  private lazy var segmentedControl: UISegmentedControl = {
    let floorNames = ["1", "2", "3"]
    return UISegmentedControl(items: floorNames)
  }()

  override func loadView() {
    mapView.isBuildingsEnabled = false
    mapView.isIndoorEnabled = false
    view = mapView

    // The possible floors that might be shown.
    segmentedControl.selectedSegmentIndex = 0
    selectedIndex = 0
    navigationItem.titleView = segmentedControl

    // Listen to touch events on the UISegmentedControl, force initial update.
    segmentedControl.addTarget(self, action: #selector(changeFloor), for: .valueChanged)
    changeFloor()
  }

  @objc func changeFloor() {
    guard segmentedControl.selectedSegmentIndex != selectedIndex else { return }
    selectedIndex = segmentedControl.selectedSegmentIndex
  }

  func updateTileLayer() {
    // Clear existing tileLayer, if any.
    tileLayer?.map = nil
    // Create a new GMSTileLayer with the new floor choice.
    let urls: GMSTileURLConstructor = { (x, y, zoom) in
      let url = "https://aerocast.s3.amazonaws.com/radar/klix/lixtileskml/\(zoom)/\(x)/\(y).png"
      return URL(string: url)
      
    }
    let tilelayer = GMSURLTileLayer(urlConstructor: urls)
    
    tilelayer.map = mapView
    tilelayer.opacity = 1.0
  }
}
