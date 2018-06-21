//
//  EditViewController.swift
//  StudyUnit
//
//  Created by Dabeer Masood on 3/26/18.
//  Copyright © 2018 Dabeer Masood. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet var classLabel: UILabel!
    @IBOutlet var classTextField: UITextField!
    
    weak var editClassDelegate: EditClassDelegate?
    
    var currClass: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let c = currClass {
            classLabel.text = c
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeClassButton(_ sender: Any) {
        if let text = classTextField.text {
            if text != "" {
                classLabel.text = text
                self.editClassDelegate?.editClass(classId: text)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: step 1 Add Protocol here.
protocol EditClassDelegate: class {
    func editClass(classId: String)
}
