import UIKit

class CreateQRCodeVC: UIViewController {

    @IBOutlet weak var createImageView: UIImageView!
    @IBOutlet weak var inportTextVC: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func DoneBth(_ sender: Any) {
        view.endEditing(true)
        
        let str = inportTextVC.text ?? ""
        let centerImage = UIImage(named: "123")
        
        let image = QRCodeTool.generatorQRCode(inputStr: str, centerImage: centerImage)
        
        createImageView.image = image
    }
    
}
