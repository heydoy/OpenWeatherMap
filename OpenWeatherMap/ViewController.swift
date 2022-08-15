//
//  ViewController.swift
//  OpenWeatherMap
//
//  Created by Doy Kim on 2022/08/15.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var lat = Double()
    var lon = Double()
    var weatherInfo = Weather()
    
    var weatherInfoArray: [String] = []
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: WeatherTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.register(UINib(nibName: WeatherImageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: WeatherImageTableViewCell.identifier)
        
        getSetTime()
        
        
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showRequestLocationServiceAlert()
    }
    // MARK: - Actions
    
    
    
    // MARK: - Helpers
    func getSetTime() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getCurrentTime), userInfo: nil, repeats: true)
    }
    
    @objc func getCurrentTime() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "M월 dd일 HH시 mm분"
        timeLabel.text = dateFormatter.string(from: Date())
    }
    
    func makeInfoText() {
        weatherInfoArray = [
            "현재 온도🌡는 \(String(format: "%.1f", weatherInfo.temp))도 , 체감온도🤒는 \(String(format: "%.1f", weatherInfo.feels_like))도에요",
            "오늘 최고온도🔥는 \(String(format: "%.1f", weatherInfo.temp_max))도, 최저온도❄️는 \(String(format: "%.1f", weatherInfo.temp_min))도입니다.",
            
            "오늘 습도💦는 \(String(format: "%.0f", weatherInfo.humidity)) % 에요.",
            "오늘 날씨는 \(weatherInfo.getWeatherText(id: weatherInfo.id))입니다."
        ]
    }

}

extension ViewController {
    
    
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            // 14 미만 버전일 경우
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {

            checkUserCurrentLocationAuthorization(authorizationStatus)
            
        } else {
            print("위치서비스가 꺼져있어서 위치권한 요청을 할 수 없습니다.")
        }
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOT DETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
            locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            showRequestLocationServiceAlert()
        case .authorizedWhenInUse:
            print("WHEN IN USE, 사용자가 앱을 사용하는 동안 허용")

            locationManager.startUpdatingLocation()
           
            
        default :
            // authorized, authorizedawlays
            print("DEFAULT")
            
        }
        
        
    }
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
          // 애플이 설정창으로 갈 수 있게 제공해줌
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }

}

extension ViewController: CLLocationManagerDelegate {
    
    // Location 5. 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        

        if let center = locations.last?.coordinate as? CLLocationCoordinate2D  {
            self.lat = Double(center.latitude)
            self.lon = Double(center.longitude)
            
            APIManager.shared.callWeather(lat: self.lat, lon: self.lon) { weather in
                self.weatherInfo = weather
                self.makeInfoText()
                self.locationButton.setTitle("  \(weather.name)  ", for: .normal)
                
                self.tableView.reloadData()
            }
         }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //
        print(#function, error)
    }
    

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    
    // iOS 14미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherInfoArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if indexPath.row < weatherInfoArray.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier , for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
            cell.textConfigure(text: weatherInfoArray[indexPath.row])
            return cell
        } else if indexPath.row == weatherInfoArray.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherImageTableViewCell.identifier , for: indexPath) as? WeatherImageTableViewCell else { return UITableViewCell() }
            cell.imageConfigure(image: weatherInfo.icon)
            print("웨더이미지", weatherInfo.icon)
            
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < weatherInfoArray.count {
            return UITableView.automaticDimension
        } else {
            return 200
        }
    }
}
