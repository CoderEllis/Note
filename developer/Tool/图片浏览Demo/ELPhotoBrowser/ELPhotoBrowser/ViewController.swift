//
//  ViewController.swift
//  ELPhotoBrowser
//
//  Created by Soul on 18/4/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var collectionView : UICollectionView!
    var dataArray = [String]()
    var imageView : UIImageView!
    var urls = [URL]()
    
    lazy var photoBrowserAnimator = PhotoBrowserAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        for _ in 0...1 { //      0...10   0-10
            for i in 0..<dataArray.count { //0..9  0-9
                let url = URL(string: dataArray[i])!
                urls.append(url)
            }
        }
        
        for i in 0...10 {
            print(i)
        }
    }
    
    
    
    func setUI() {
        dataArray = ["https://weiliicimg9.pstatp.com/weili/l/57431194589069685.jpg", 
                     "https://weiliicimg1.pstatp.com/weili/l/57435824563815547.webp",
                     "http://ww2.sinaimg.cn/bmiddle/72635b6agw1eyqehvujq1j218g0p0qai.jpg",
                     "http://ww2.sinaimg.cn/bmiddle/e67669aagw1f1v6w3ya5vj20hk0qfq86.jpg",
                     "http://ww3.sinaimg.cn/bmiddle/61e36371gw1f1v6zegnezg207p06fqv6.gif",
                     "http://ww4.sinaimg.cn/bmiddle/7f02d774gw1f1dxhgmh3mj20cs1tdaiv.jpg",
                     "https://a-ssl.duitang.com/uploads/item/201501/06/20150106162007_nkhis.gif",
                     "https://b-ssl.duitang.com/uploads/blog/201411/20/20141120173436_nPWAG.thumb.700_0.gif",
                     "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1547550294481&di=def2eb8bdc57ef1dfeac2ce5af88c1d5&imgtype=0&src=http%3A%2F%2Fpic1.16pic.com%2F00%2F51%2F64%2F16pic_5164026_b.jpg"]
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width / 3 - 10, height: view.bounds.width / 3 - 20)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.clear
        if #available(iOS 10.0, *) {
            collectionView.isPrefetchingEnabled = true //预加载
        } else {
            // Fallback on earlier versions
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
    }
    
    
    
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        for view in cell.subviews {
            view.removeFromSuperview()
        }
        
        imageView = UIImageView(frame: cell.bounds)
        
        let url = urls[indexPath.row]
        imageView.kf.setImage(with: url)
        
        cell.addSubview(imageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photoBrowserVc = PhotoBrowserController(collectionView, indexPath: indexPath, picURLs: urls, photoBrowserAnimator: photoBrowserAnimator) { [weak self] (alph) -> Void? in
            self?.photoBrowserAnimator.maskAlpha = alph
        }
        present(photoBrowserVc, animated: true, completion: nil)
    }
    
    
    
}


