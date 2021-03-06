//
//  PackCollectionViewController.swift
//  Consequences
//
//  Created by Christopher Harrison on 16/11/2017.
//  Copyright © 2017 Christopher Harrison. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

let screenSize: CGRect = UIScreen.main.bounds
let screenWidth = screenSize.size.width
let screenHeight = screenSize.size.height

class PackCollectionViewController: UICollectionViewController {
    
    let cellSize = CGSize(width:screenWidth*0.5 , height:screenWidth*0.85)
    var cellRecordIndexPath = IndexPath()
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
    let blurEffectView = UIVisualEffectView()
    let previewPack = UIView()
    var backPreviewPack = UIImageView()
    var animating = false
    let blurTapRecognizer = UITapGestureRecognizer()
    var absoluteForgroundFrame = CGPoint()
    var tempCellRect = CGRect()
    let shiftMultiplier = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        addGestureRecognisers()
    }
    override func viewDidAppear(_ animated: Bool) {
        updateVisibleCells(visibleCells: (collectionView?.visibleCells)! as! [PackCollectionViewCell])
    }

    func setupCollectionView(){
        self.collectionView!.register(PackCollectionViewCell.self, forCellWithReuseIdentifier: "PackCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        self.collectionView?.setCollectionViewLayout(layout, animated: true)
        self.collectionView?.reloadData()
    }
    
    func addGestureRecognisers() {
        blurTapRecognizer.addTarget(self, action: #selector(self.reverseCellSelect(_:)))
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackCell", for: indexPath) as! PackCollectionViewCell
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateVisibleCells(visibleCells: (collectionView?.visibleCells)! as! [PackCollectionViewCell])
    }
    
    func updateVisibleCells(visibleCells:[PackCollectionViewCell]){
        for cell in visibleCells {
            let absoluteframe = cell.superview?.convert(cell.frame.origin, to: nil)
            let cellScreenPercentage = (((((absoluteframe?.y)! + (cellSize.height/2)) / (screenSize.size.height))*100)-50) * CGFloat(shiftMultiplier)
            cell.foregroundPack.center.y = cell.backgroundPack.center.y + cellScreenPercentage
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isAnimating()
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        let cell = collectionView.cellForItem(at: indexPath) as! PackCollectionViewCell
        cellRecordIndexPath = indexPath
        addBlurView(collectionView: collectionView)
        showBlurView()
        addPreviewPack(cell: cell)
        hideCellContents(cell: cell)
        self.disableUserInteraction()
        animateCell()
    }
    
    func flipCardAnimation(){
        isAnimating()
        createBackPreviewPack()
        previewPackTransition()
    }
    
    @objc func reverseCellSelect(_ sender: UITapGestureRecognizer) {
        if !self.animating {
            isAnimating()
            transitionBack()
        }
        
    }
    
    func transitionBack(){
        let transitionOptions = UIViewAnimationOptions.transitionFlipFromLeft
        UIView.transition(with: previewPack, duration: 1.5, options: transitionOptions, animations: {
            self.backPreviewPack.isHidden = true
            self.backPreviewPack.removeFromSuperview()
        }) { (finished) in
            self.moveBack()
        }
    }
    
    func moveBack(){
        //Do after
        let cell = self.collectionView?.cellForItem(at: self.cellRecordIndexPath) as! PackCollectionViewCell
        let moveAnimation = UIViewPropertyAnimator(duration: 0.6, curve: .easeInOut)
        let blurAnimation = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
        moveAnimation.addAnimations {
            self.previewPack.center.x = self.tempCellRect.midX
            self.previewPack.center.y = self.tempCellRect.midY
            self.previewPack.transform = CGAffineTransform.identity
        }
        blurAnimation.addAnimations {
            self.blurEffectView.alpha = 0
        }
        moveAnimation.addCompletion {_ in
            self.showCellContents(cell: cell)
            blurAnimation.startAnimation()
        }
        blurAnimation.addCompletion {_ in
            self.blurEffectView.removeFromSuperview()
            self.previewPack.removeFromSuperview()
            self.notAnimating()
        }
        moveAnimation.startAnimation()
    }
    
    func disableUserInteraction() {
        self.blurEffectView.isUserInteractionEnabled = false
        self.previewPack.isUserInteractionEnabled = false
    }
    
    func enableUserInteraction(){
        self.blurEffectView.isUserInteractionEnabled = true
        self.previewPack.isUserInteractionEnabled = true
    }
    
    func isAnimating(){
        self.animating = true
    }
    
    func notAnimating(){
        self.animating = false
    }
    
    func addBlurView(collectionView :UICollectionView) {
        blurEffectView.effect = blurEffect
        blurEffectView.frame = self.view.bounds
        blurEffectView.tag = 1
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.addGestureRecognizer(blurTapRecognizer)
        collectionView.superview?.addSubview(blurEffectView)
        blurEffectView.alpha = 0
    }
    
    func showBlurView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.blurEffectView.alpha = 1.0
            self.disableUserInteraction()
        }, completion: {
            (value: Bool) in
            self.animating = false
            self.enableUserInteraction()
        })
    }
    
    func addPreviewPack(cell: PackCollectionViewCell){
        absoluteForgroundFrame = (cell.foregroundPack.superview?.convert(cell.foregroundPack.frame.origin, to: nil))!
        tempCellRect = CGRect(x: absoluteForgroundFrame.x, y: absoluteForgroundFrame.y, width: cell.foregroundPack.frame.width, height: cell.foregroundPack.frame.height)
        previewPack.frame = tempCellRect
        previewPack.layer.cornerRadius = cell.foregroundPack.layer.cornerRadius
        previewPack.backgroundColor = .green
        collectionView?.superview?.addSubview(previewPack)
    }
    
    func hideCellContents(cell: PackCollectionViewCell){
        cell.backgroundPack.isHidden = true
        cell.foregroundPack.isHidden = true
    }
    
    func showCellContents(cell: PackCollectionViewCell){
        cell.backgroundPack.isHidden = false
        cell.foregroundPack.isHidden = false
    }
    
    func animateCell(){
        let animation = UIViewPropertyAnimator(duration: 0.6, curve: .easeInOut)
        animation.addAnimations {
            self.previewPack.center.x = screenSize.width/2
            self.previewPack.center.y = screenSize.height/2
            self.previewPack.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
        animation.addCompletion {_ in
            self.animating = false
            self.enableUserInteraction()
            self.flipCardAnimation()
        }
        animation.startAnimation()
    }
    
    func createBackPreviewPack(){
        backPreviewPack.frame = CGRect(x: 0, y: 0, width: self.previewPack.frame.width/2, height: self.previewPack.frame.height/2)
        backPreviewPack.layer.cornerRadius = self.previewPack.layer.cornerRadius
        backPreviewPack.backgroundColor = .blue
        backPreviewPack.isHidden = true
        previewPack.addSubview(backPreviewPack)
    }
    
    func previewPackTransition(){
        let transitionOptions = UIViewAnimationOptions.transitionFlipFromLeft
        UIView.transition(with: previewPack, duration: 1.5, options: transitionOptions, animations: {
            self.backPreviewPack.isHidden = false
        }) { (finished) in
            self.notAnimating()
        }
    }
}
