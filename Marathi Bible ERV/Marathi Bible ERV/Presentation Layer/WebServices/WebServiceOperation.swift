
import UIKit
import Alamofire
//import SwiftyJSON
/**
  This class is used for calling Api for over all section GET, PUT, POST, Multipart
 */
struct MultiPartDataFormatStructure {
    
    enum MIME_TYPE {
        case text_plain
        case text_html
        case file_pdf
        case image_jpg
        case image_jpeg
        case image_png
        case image_gif
        case audio_mpeg
        case audio_ogg
        case audio_any
        case audio_wav
        case video_mp4
        case video_MOV
      
        func getMimeType() -> String {
            switch self {
            case .text_plain:
                return "text/plain"
            case .text_html:
                return "text/html"
            case .file_pdf:
                return "application/pdf"
            case .image_jpg:
                return "image/jpg"
            case .image_jpeg:
                return "image/jpeg"
            case .image_png:
                return "image/png"
            case .image_gif:
                return "image/gif"
            case .audio_mpeg:
                return "audio/mpeg"
            case .audio_ogg:
                return "audio/ogg"
            case .audio_any:
                return "audio/*"
            case .audio_wav:
                return "audio/x-wav"
            case .video_mp4:
                return "video/mp4"
            case .video_MOV:
                return "video/MOV"
          
            }
        }
    }
    
    internal let strKey:String?
    internal let strFileName:String?
    internal let mimeType:MIME_TYPE?
    internal let data:Data?
    
    init(key:String?,mimeType:MIME_TYPE?,data:Data?,name:String?) {
        self.strKey = key
        self.mimeType = mimeType
        self.data = data
        self.strFileName = name
    }
}

class WebServiceOperation: MyWebServiceOperation {
    
    private class WebServiceCallingClass:NSObject {
        
        enum WEB_SERVICE_TYPE:Int {
            case WEB_SERVICE_TYPE_GET = 0
            case WEB_SERVICE_TYPE_POST
            case WEB_SERVICE_TYPE_MULTI_PART
        }
        
        class func callWebserviceFor(URL url:URL,SERVICE_TYPE serviceType:WEB_SERVICE_TYPE,PARAM param:Dictionary<String,AnyObject>?,HANDLER handler:((_ response:Data?,_ isError:Bool)->())?) {
           
            print(serviceType)
            
            let headers: HTTPHeaders = [
                "X-REQUEST-SIGN" : "VAjK7RkzEyFryDyX2wVtFGNg"
            ]
             Alamofire.request(url, method: (serviceType == .WEB_SERVICE_TYPE_POST) ? .post : .get, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                guard let data = response.data, data.count > 0 else{
                    if let handler = handler {
                        DispatchQueue.main.async {
                            handler(nil,true)
                        }
                    }
                    return
                }
                if let handler = handler {
                    DispatchQueue.main.async {
                        handler(data,false)
                    }
                }
            }
        }
        
        class func callMultiPart(URL url:URL,PARAM param:Dictionary<String,Any>?,MultiPartArray arrMultipart:[MultiPartDataFormatStructure]?,HANDLER handler:((_ response:Data?,_ isError:Bool)->())?) {
            
            print(param as Any)
            print(arrMultipart as Any)
            print(url as Any)
            
            let headers: HTTPHeaders = [
                /* "Authorization": "your_access_token",  in case you need authorization header */
                "Content-type": "multipart/form-data",
                "X-REQUEST-SIGN" : "VAjK7RkzEyFryDyX2wVtFGNg"
            ]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                // Add normal param
                if let param = param, param.count > 0 {
                    for (key, value) in param {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
                
                
                if let arr = arrMultipart, arr.count > 0 {
                    for obj in arr {
                        if let strKey = obj.strKey, let mimeType = obj.mimeType, let data = obj.data, let strName = obj.strFileName {
                            multipartFormData.append(data, withName: strKey, fileName: strName, mimeType: mimeType.getMimeType())
                        }
                    }
                }
                
                
                
            }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: HTTPMethod.post, headers: headers) { result in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        ////print progress
                        print(progress.fractionCompleted as Any)
                    })
                    
                    upload.responseJSON { (response) in
                        print(response.result)
                        if let handler = handler {
                            DispatchQueue.main.async {
                                handler(response.data,false)
                                return
                            }
                        }
                        
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                        }
                        if let handler = handler {
                            DispatchQueue.main.async {
                                handler(response.data,false)
                            }
                        }
                    }
                    
                    
                    
                case .failure(let encodingError):
                    print(encodingError.localizedDescription)
                    if let handler = handler {
                        DispatchQueue.main.async {
                            handler(nil,true)
                            return
                        }
                    }
                }
            }
        }
    }
    
    enum WEB_SERVICE:Int {
        case WEB_SERVICE_GET = 0
        case WEB_SERVICE_POST
        case WEB_SERVICE_MULTI_PART
    }
    
    private var urlString:String = ""
    private var param:Dictionary<String,AnyObject>? = nil
    private var arrMultipart:[MultiPartDataFormatStructure]? = nil
    private var serviceType:WebServiceCallingClass.WEB_SERVICE_TYPE = .WEB_SERVICE_TYPE_POST
    
    public static let __kStrVideoRawDataKey = "__kStrVideoRawDataKey"
    public static let __kStrVideoSnapshotDataKey = "__kStrVideoSnapshotDataKey"
    
    var responseData:Data?
    var dictResponse:[String:Any]?
    
    var dictModifiedResponcs:[[String:Any]]?
    
    //var responceJson: JSON = JSON.null
    
    private override init() {
        super.init()
    }
    
    init(_ url:String!,_ param:Dictionary<String,AnyObject>?,_ serviceType:WEB_SERVICE , _ arrMultipartData:[MultiPartDataFormatStructure]? = nil) {
        
        self.urlString = url
        self.param = param
        self.arrMultipart = arrMultipartData
        
        if serviceType == .WEB_SERVICE_POST {
            self.serviceType = .WEB_SERVICE_TYPE_POST
        }
        if serviceType == .WEB_SERVICE_GET {
            self.serviceType = .WEB_SERVICE_TYPE_GET
        }
        if serviceType == .WEB_SERVICE_MULTI_PART {
            self.serviceType = .WEB_SERVICE_TYPE_MULTI_PART
        }
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        
        guard let url = URL(string: self.urlString) else {
            finish(true)
            return
        }
        
        
        if self.serviceType == .WEB_SERVICE_TYPE_MULTI_PART {
            WebServiceCallingClass.callMultiPart(URL: url, PARAM: self.param, MultiPartArray: self.arrMultipart) { (data:Data?, error:Bool) in
                self.responseData = data
                if let data = data, data.count > 0 {
                    do{
                        self.dictResponse = try (JSONSerialization.jsonObject(with: data, options: []) as? [String : Any])
                    }catch let err {
                        print(err.localizedDescription)
                    }
                }
                self.executing(false)
                self.finish(true)
            }
        }
        else {
            WebServiceCallingClass.callWebserviceFor(URL: url, SERVICE_TYPE: self.serviceType, PARAM: self.param) { (response, error) in
                self.responseData = response
                if let data = response, data.count > 0 {
                    do{
                        self.dictResponse = try (JSONSerialization.jsonObject(with: data, options: []) as? [String : Any])
                       // self.responceJson = JSON(data)
                        
                    }catch let err {
                        print(err.localizedDescription)
                    }
                }
                self.executing(false)
                self.finish(true)
            }
        }
    }
}




