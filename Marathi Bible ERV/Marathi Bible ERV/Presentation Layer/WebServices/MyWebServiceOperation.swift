
import UIKit
/**
  This class is used for initialization to call api in all pattern
 */
class MyWebServiceOperation: Operation {
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
}






extension Data {
    
    var dictionary:[String:Any]? {
        do{
            if let json = try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String:Any] {
                return json
            }
        }catch let e {
            print(e.localizedDescription)
            return nil
        }
        return nil
    }
}


extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    var prettyprintedJSON: String? {
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch let err {
            print(err.localizedDescription)
            return nil
        }
    }
    var data:Data? {
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return data
        } catch let err {
            print(err.localizedDescription)
            return nil
        }
    }
}

