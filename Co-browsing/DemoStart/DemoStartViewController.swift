//
//  ViewController.swift
//  Co-browsing
//
//  Created by Артем Бурдейный on 16/09/2019.
//  Copyright © 2019 Артем Бурдейный. All rights reserved.
//

import UIKit
import AVKit

class DemoStartViewController: UIViewController {
    

    let viewModel = DemoStartViewModel()
    
    @IBOutlet weak var sessionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
//        createTaskForHitTest(point: CGPoint(x: 20, y: 44), completion: { [weak self] in
//            self?.createTaskForHitTest(point: CGPoint(x: 20, y: 84), completion: { [weak self] in
//                self?.createTaskForHitTest(point: CGPoint(x: 20, y: 134), completion: { [weak self] in
//                    self?.createTaskForHitTest(point: self?.view.center ?? CGPoint.zero)
//                })
//            })
//        })
    }
    
    private func createTaskForHitTest(point: CGPoint, completion: (()->())? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            let hitTestView = self.view.hitTest(point, with: nil)
            if let button = hitTestView as? UIButton {
                button.sendActions(for: .touchUpInside)
            } else if let textField = hitTestView as? UITextField {
                textField.becomeFirstResponder()
                textField.text = "Тестовый текст"
            } else if let slider = hitTestView as? UISlider {
                UIView.animate(withDuration: 0.3, animations: {
                    slider.setValue(0.8, animated: true)
                })
            }
            if let completion = completion {
                completion()
            }
        }
    }
    
    @IBAction func playerAction(_ sender: UIButton) {
        guard let url = URL(string: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8") else {
            return
        }
        let player = AVPlayer(url: url)
        let controller = PlayerViewController()
        controller.player = player
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func startSessionButtonAction(_ sender: UIButton) {
        sender.isEnabled = false
        viewModel.didPressSessionButton(selected: sender.isSelected)
    }
}

extension DemoStartViewController: DemoStartViewModelDelegate {
    func changeSessionStatus(selected: Bool) {
        sessionButton.isEnabled = true
        sessionButton.isSelected = selected
    }
}

extension DemoStartViewController: WebSocketManagerDelegate {
    func recieveSocketMessage(message: Any) {
        
    }
}

