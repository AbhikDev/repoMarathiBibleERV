
import UIKit
import WebKit
class BibleCMS: BaseViewController {
    @IBOutlet var wkWebVW:WKWebView!
    var urlToLoad = privacyPolicy
    var headerText = "গোপনীয়তা নীতি"
    override func viewDidLoad() {
        super.viewDidLoad()

        //let str = "<!DOCTYPE html><html><body><h1>Bible Privacy Policy</h1> <p>My first paragraph.</p></body> </html>"
        //wkWebVW.loadHTMLString(str, baseURL: nil)
        wkWebVW.navigationDelegate = self
        wkWebVW.load(URLRequest.init(url: URL(string: urlToLoad)!))
        
        customNavigation.lblHeader.text = headerText
        customNavigation.headerType = .back
        self.wkWebVW.isOpaque = false
    }

}
extension BibleCMS:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /*
        let js = "document.body.outerHTML"
        webView.evaluateJavaScript(js) { (html, error) in
            let headerString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
            webView.loadHTMLString(headerString + (html as! String), baseURL: nil)
        }*/
        
    }
}
