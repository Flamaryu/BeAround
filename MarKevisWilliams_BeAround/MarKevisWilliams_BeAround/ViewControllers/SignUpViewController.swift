//
//  SignUpViewController.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/12/22.
//

import UIKit

class SignUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FormatLook()
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension SignUpViewController{
    
    func FormatLook(){
        let gradientlayer = CAGradientLayer()
        let primaryColor = UIColor(rgb: 0x5398c5 )
        let secondaryColor = UIColor(rgb: 0x977096)
        gradientlayer.frame = view.bounds
        gradientlayer.colors = [primaryColor.cgColor  ,secondaryColor.cgColor ]
        view.layer.insertSublayer(gradientlayer, at: 0)
        
        // look of nav bar buttons
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(rgb: 0xF3E622)]
        navigationItem.standardAppearance?.buttonAppearance = buttonAppearance
       
    }
}
