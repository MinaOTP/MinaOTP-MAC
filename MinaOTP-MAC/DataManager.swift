import CloudKit


private let ALERT_OFF = "ALERT_OFF"
private let RECORD_KEY = "MinaOtp"
private let recordID = CKRecord.ID(recordName: RECORD_KEY)

final class DataManager {
    
    fileprivate init() {
        ///forbide to create instance of helper class
    }
    
    fileprivate static var cloudDatabase: CKDatabase {
        return CKContainer.default().privateCloudDatabase
    }
    
    static func initial(_ whenDataUpdate: (() -> Void)?) {
        checkLoginStatus { isLogged in
            print("iCloud isLogged: " + isLogged.description)
            if isLogged {
                fetchRemote { (totps, error) in
                    print("***** remote fetched *****")
                    print(totps)
                    if let error = error {
                        print(error)
                    } else {
                        UserDefaults.standard.set(totps, forKey: RECORD_KEY)
                        if let whenDataUpdate = whenDataUpdate {
                            DispatchQueue.main.async {
                                whenDataUpdate()
                            }
                        }
                    }
                }
            } else {
                let alertOff = UserDefaults.standard.value(forKey: ALERT_OFF) as? Bool ?? false
                if (!alertOff) {
                    showAlert()
                }
            }
        }
    }
    
    static func get() -> [String] {
        return UserDefaults.standard.value(forKey: RECORD_KEY) as? [String] ?? []
    }
    
    static func save(_ totps: [String]) {
        UserDefaults.standard.set(totps, forKey: RECORD_KEY)
        updateRemote(totps) { (saved, error) in
            if let error = error {
                print(error)
            } else {
                print("***** remote saved *****")
                print(saved)
            }
        }
    }
}


fileprivate extension DataManager {
    
    static func createRecord(_ totps: [String], _ completion: @escaping ([String], NSError?) -> Void) {
        let record = CKRecord(recordType: RECORD_KEY, recordID: recordID)
        record.setValue(totps, forKey: RECORD_KEY)
        cloudDatabase.save(record) { (savedRecord, error) in
            DispatchQueue.main.async {
                completion(savedRecord?.object(forKey: RECORD_KEY) as? [String] ?? [], error as NSError?)
            }
        }
    }
    
    static func fetchRemote(_ completion: @escaping ([String], NSError?) -> Void) {
        cloudDatabase.fetch(withRecordID: recordID) { (record, error) in
            DispatchQueue.main.async {
                completion(record?.object(forKey: RECORD_KEY) as? [String] ?? [], error as NSError?)
            }
        }
    }
    
    static func updateRemote(_ totps: [String], _ completion: @escaping ([String], NSError?) -> Void) {
        cloudDatabase.fetch(withRecordID: recordID) { record, error in
            guard let record = record else {
                createRecord(totps, completion)
                return
            }
            record.setValue(totps, forKey: RECORD_KEY)
            self.cloudDatabase.save(record) { savedRecord, error in
                DispatchQueue.main.async {
                    completion(savedRecord?.object(forKey: RECORD_KEY) as? [String] ?? [], error as NSError?)
                }
            }
        }
    }
    
    static func checkLoginStatus(_ handler: @escaping (_ islogged: Bool) -> Void) {
        CKContainer.default().accountStatus{ accountStatus, error in
            if let error = error {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                handler(accountStatus == .available)
            }
        }
    }
    
    static func showAlert() {
//        let alert = UIAlertController(title: "iCloud", message: "iCloud is unavailable, please login and try again if you need sync feature. or click [Cancel] for local usage", preferredStyle: .alert)
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
//            UserDefaults.standard.set(true, forKey: ALERT_OFF)
//        }
//        let settings = UIAlertAction(title: "Settings", style: .default) { _ in
//            guard let url = URL(string:"App-Prefs:root=General") else { return }
//            UIApplication.shared.openURL(url)
//        }
//        alert.addAction(cancel)
//        alert.addAction(settings)
//        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
}
