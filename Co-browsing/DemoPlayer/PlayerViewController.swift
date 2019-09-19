//
//  PlayerViewController.swift
//  Co-browsing
//
//  Created by Артем Бурдейный on 16/09/2019.
//  Copyright © 2019 Артем Бурдейный. All rights reserved.
//

import AVKit

class PlayerViewController: AVPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLandscapeMode()
        self.setValue(false, forKey: "canHidePlaybackControls")
        
//        //перемотка
//        createTaskForHitTest(point: CGPoint(x: 247, y: 340), completion: { [weak self] in
//            //стоп
//            self?.createTaskForHitTest(point: CGPoint(x: 106, y: 340), completion: { [weak self] in
//                //старт
//                self?.createTaskForHitTest(point: CGPoint(x: 106, y: 340), completion: { [weak self] in
//                    //закрыть
//                    self?.createTaskForHitTest(point: CGPoint(x: 27, y: 27))
//                })
//            })
//        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.play()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft, .landscapeRight]
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    private func setUpLandscapeMode() {
        if !UIDevice.current.orientation.isLandscape {
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    private func createTaskForHitTest(point: CGPoint, completion: (()->())? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
            guard let self = self else { return }
            let hitTestView = self.view.hitTest(point, with: nil)
            if let button = hitTestView as? UIButton {
                button.sendActions(for: .touchUpInside)
            } else if let textField = hitTestView as? UITextField {
                textField.becomeFirstResponder()
                textField.text = "Тестовый текст"
            } else if let slider = hitTestView as? UISlider {
                let time = CMTime(seconds: 75, preferredTimescale: 100)
                self.player?.seek(to: time)
//                UIView.animate(withDuration: 0.3, animations: {
//                    slider.setValue(0.8, animated: true)
//                })
            }
            if let completion = completion {
                completion()
            }
        }
    }
}
