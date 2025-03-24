//
//  MediaCollectionViewCell.swift
//  DineWise
//
//  Created by Muhammad Mahad on 2025-03-22.
//

import UIKit
import AVKit
import SDWebImage

class MediaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var videoView: UIView!
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        player?.pause()
        playerLayer?.removeFromSuperlayer()
    }
    
    func configureImage(url: String) {
        imageView.isHidden = false
        videoView.isHidden = true
        imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder"))
    }

    func configureVideo(url: String) {
        imageView.isHidden = true
        videoView.isHidden = false
        
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = videoView.bounds
            playerLayer?.videoGravity = .resizeAspectFill
            videoView.layer.addSublayer(playerLayer!)
            
            player?.play()
        }
    }
}
