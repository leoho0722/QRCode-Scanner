import UIKit
import IQKeyboardManagerSwift

class GenQRCodeViewController: UIViewController {

    @IBOutlet weak var qrcodeImageView:UIImageView!
    @IBOutlet weak var urlTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseBtnOnKeyBoard()
    }
    
    func addCloseBtnOnKeyBoard() {
        let doneBtn = UIBarButtonItem(title: "關閉", style: .done, target: self, action: #selector(closeBtnAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolBar.barStyle = .default
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(doneBtn)
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        self.urlTextField.inputAccessoryView = doneToolBar
    }
    @objc func closeBtnAction() {
        self.urlTextField.resignFirstResponder()
    }
    
    @IBAction func genQRCode(_ sender: Any) {
        let data = self.urlTextField.text?.data(using: .isoLatin1)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        if let ciImage = filter?.outputImage {
            let scaleX = qrcodeImageView.bounds.width / ciImage.extent.width
            let scaleY = qrcodeImageView.bounds.height / ciImage.extent.height
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            qrcodeImageView.image = UIImage(ciImage: ciImage.transformed(by: transform))
        }
    }
    
    @IBAction func cleanURLTextField(_ sender: Any) {
        if (urlTextField.text == "") {
            self.alertMessage()
        } else {
            urlTextField.text = ""
            qrcodeImageView.image = nil
        }
    }
    
    func alertMessage() {
        let alertController = UIAlertController(title: "", message: "URL 目前為空，不用再清除了！", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "關閉", style: .default, handler: nil)
        alertController.addAction(closeAction)
        self.present(alertController,animated: true)
    }
}

// 修正 QRCode 模糊 ↓
//https://medium.com/jeremy-xue-s-blog/d17-%E8%AB%8B%E6%94%B6%E4%B8%8B%E6%88%91%E7%9A%84-qrcode-5db78d330727
