import UIKit
import CoreBluetooth

final class HomeDetailViewController: UIViewController {
    @IBOutlet private weak var coolingWaterTempLabel: UILabel!
    @IBOutlet private weak var engineLoadLabel: UILabel!
    @IBOutlet private weak var catalystTempLabel: UILabel!
    @IBOutlet private weak var connectOBDButton: UIButton!
    @IBOutlet private weak var carNameLabel: UILabel!
    @IBOutlet private weak var carDateLabel: UILabel!
    @IBOutlet private weak var carImageView: UIImageView!
    @IBOutlet private weak var reservationButton: UIButton!
    
    private var centralManager: CBCentralManager!
    private var obd2Peripheral: CBPeripheral!
    
    private let obd2DataServiceCBUUID = CBUUID(string: "FFF0")
    private let dataOutputCharacteristicCBUUID = CBUUID(string: "FFF1")
    private let dataInputCharacteristicCBUUID = CBUUID(string: "FFF2")
    
    private var dataOutputCharacteristic: CBCharacteristic!
    private var dataInputCharacteristic: CBCharacteristic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setCoolingWaterTemperature() {
        obd2Peripheral.writeValue(Data(Array("0105\r".utf8)), for: dataInputCharacteristic, type: .withoutResponse)
    }
    
    private func setEngineLoadState() {
        obd2Peripheral.writeValue(Data(Array("0104\r".utf8)), for: dataInputCharacteristic, type: .withoutResponse)
    }
    
    private func setCatalystTemperature() {
        obd2Peripheral.writeValue(Data(Array("013C\r".utf8)), for: dataInputCharacteristic, type: .withoutResponse)
    }
    
    private func setupViews() {
        coolingWaterTempLabel.isHidden = true
        engineLoadLabel.isHidden = true
        catalystTempLabel.isHidden = true
        carNameLabel.isHidden = true
        carDateLabel.isHidden = true
        carImageView.isHidden = true
        reservationButton.isHidden = true
    }
    
    private func loadViews() {
        coolingWaterTempLabel.isHidden = false
        engineLoadLabel.isHidden = false
        catalystTempLabel.isHidden = false
        carNameLabel.isHidden = false
        carDateLabel.isHidden = false
        carImageView.isHidden = false
        reservationButton.isHidden = false
    }
    
    private func showAlert(with title: String) {
        let alertViewController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.loadViews()
        })
        alertViewController.addAction(alertAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func connectOBDButtonTouched(_ sender: Any) {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        showAlert(with: "OBD가 연결 되었습니다.")
        connectOBDButton.tintColor = UIColor(named: "StableGreen")!
    }
    
    @IBAction func readDataButtonTouched(_ sender: Any) {
        DispatchQueue.global().sync { [weak self] in
            self?.setCoolingWaterTemperature()
        }
        DispatchQueue.global().sync { [weak self] in
            self?.setEngineLoadState()
        }
        DispatchQueue.global().sync { [weak self] in
            self?.setCatalystTemperature()
        }
    }
}

extension HomeDetailViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            centralManager.scanForPeripherals(withServices: nil)
        default:
            print(">>> central.state error \n=============\n")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        guard (peripheral.name?.hasPrefix("OBD") ?? false) else { return }
        obd2Peripheral = peripheral
        obd2Peripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(obd2Peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        obd2Peripheral.discoverServices([obd2DataServiceCBUUID])
    }
}

extension HomeDetailViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else { return }
        
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else { return }
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.properties.contains(.notify) {
                dataOutputCharacteristic = characteristic
            }
            if characteristic.properties.contains(.write) {
                dataInputCharacteristic = characteristic
            }
        }
        
        obd2Peripheral.setNotifyValue(true, for: dataOutputCharacteristic)
        
        obd2Peripheral.writeValue(Data(Array("ATSP0\r".utf8)), for: dataInputCharacteristic, type: .withoutResponse)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else { return }
        
        let returnedBytes = [UInt8](characteristic.value!)
        let encodedBytes = returnedBytes.map { String(UnicodeScalar($0)) }.joined()
        
        if encodedBytes.contains("OK") {
            return
        }
        
        guard !encodedBytes.contains("SEARCHING") else { return }
        
        if encodedBytes.hasPrefix("41 05") {
            let value = Int(String(encodedBytes.dropFirst(6).prefix(2)), radix: 16)! - 40
            DispatchQueue.main.async { [weak self] in
                self?.coolingWaterTempLabel.text = String(value) + " °C"
            }
        } else if encodedBytes.hasPrefix("41 04") {
            let value = Int(String(encodedBytes.dropFirst(6).prefix(2)), radix: 16)! * 100 / 255
            DispatchQueue.main.async { [weak self] in
                self?.engineLoadLabel.text = String(value) + " %"
            }
        } else if encodedBytes.hasPrefix("41 04") {
            let data = encodedBytes.dropFirst(6)
            let a = Int(String(data.prefix(2)), radix: 16)! * 256
            let b = Int(String(data.dropFirst(3).prefix(2)), radix: 16)!
            let value = ((a + b) / 10) - 40
            DispatchQueue.main.async { [weak self] in
                self?.catalystTempLabel.text = String(value) + " °C"
            }
        } else {
            return
        }
    }
}
