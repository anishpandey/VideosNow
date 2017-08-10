//
//  VideosViewController.swift
//  VocSdkExampleSwift
//
//  Created by Gensch, Larry on 5/17/17.
//  Copyright © 2017 Akamai Technologies. All rights reserved.
//

import VocSdk
import UIKit
import AVFoundation
import AVKit

class VideosViewController: UITableViewController, VocObjSetChangeListener {
	/// The latest video set received from the PCD SDK
	var pcdVideos : VocVideoSet? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

		AppDelegate.ours.pcdService!.getVideosWith(VocVideoFilter.all(withSort: nil)!) { (error, videoSet) in
			if (error != nil) {
				print("Unable to get videos: \(String(describing: error))")
				return
			}
			let numVideos = videoSet?.videos.count
			print("Recieved videos with \(String(describing: numVideos)) videos")
			if (self.pcdVideos != nil) {
				self.pcdVideos?.remove(self)
			}
			self.pcdVideos = videoSet
			self.pcdVideos?.add(self)
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let count = self.pcdVideos?.videos.count else { return 1 }
		return count
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell : UITableViewCell
		if let item = self.pcdVideos?.videos[indexPath.row] as? VocItem {
			let videoCell : VideoCell! = tableView.dequeueReusableCell(withIdentifier: "videoClip", for: indexPath) as? VideoCell
			videoCell.item = item
			cell = videoCell
		} else {
			cell = tableView.dequeueReusableCell(withIdentifier: "regularCell", for: indexPath)
			cell.textLabel?.text = "No videos received"
			cell.textLabel?.textAlignment = .center
		}
		return cell
	}

	/// If a row is selected, play the associated video (if possible)
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let video : VocItemVideo = self.pcdVideos?.videos[indexPath.row] as! VocItemVideo

		//Download Action
		let actionDownload : UIAlertAction = UIAlertAction.init(title: "DOWNLOAD", style: .default) { (action) in

			print("START DOWNLOAD")

			AppDelegate.ours.pcdService?.downloadItems([video],
			                                               options:
				[
					"videoPartialDownloadLength" : 0,
					"downloadBehavior" : VOCItemDownloadBehavior.fullAuto.rawValue
				],
			                                               completion: nil)

			tableView.reloadRows(at: [indexPath], with: .automatic)
		}

		//Pause Action
		let actionPause : UIAlertAction = UIAlertAction.init(title: "PAUSE", style: .default) { (action) in

			print("PAUSE DOWNLOAD")

			AppDelegate.ours.pcdService?.pauseItemDownload(video, completion: nil)

			tableView.reloadRows(at: [indexPath], with: .automatic)
		}

		//Playback of cached Contents
		let actionPlay : UIAlertAction = UIAlertAction.init(title: "PLAY", style: .default) { (action) in

			print("PLAY VIDEO")

			if (video.conforms(to: VocItemHLSVideo.self)) {

				AppDelegate.ours.pcdService?.startHLSServer(completion: { (success) in
					let hlsVideo = video as! VocItemHLSVideo
					let url = AppDelegate.ours.pcdService?.hlsServerUrl?.appendingPathComponent(hlsVideo.hlsServerRelativePath!)
					self.playVideoAt(url: url, description: url?.absoluteString)
				})

			} else {

				let url = URL.init(fileURLWithPath: video.file.localPath!)
				self.playVideoAt(url: url, description: url.path)
			}

		}
		//Delete Action
		let actionDelete : UIAlertAction = UIAlertAction.init(title: "DELETE", style: .default) { (action) in

			print("DELETE VIDEO")

			video.deleteFiles(false)

			tableView.reloadRows(at: [indexPath], with: .automatic)
		}

		let alert = UIAlertController.init(title: "Menu", message: nil, preferredStyle: .actionSheet)

		switch video.state {
		case .VOCItemDiscovered:
			alert.addAction(actionDownload)
			break

		case .VOCItemQueued:
			alert.addAction(actionPause)
			break

		case .VOCItemDownloading:
			alert.addAction(actionPause)
			break

		case .VOCItemIdle:
			alert.addAction(actionDownload)
			alert.addAction(actionPause)
			alert.addAction(actionDelete)
			break

		case .VOCItemPaused:
			alert.addAction(actionDownload)
			alert.addAction(actionDelete)
			break

		case .VOCItemCached, .VOCItemPartiallyCached:
			alert.addAction(actionPlay)
			alert.addAction(actionDelete)
			break

		case .VOCItemFailed:
			alert.addAction(actionDownload)			
			alert.addAction(actionDelete)
			break

		default:
			break;
		}

		alert.addAction(UIAlertAction.init(title: "Dismiss", style: .destructive))

		self.present(alert, animated: true, completion: nil)
	}

	func playVideoAt(url: URL!, description : String!) {
		print("Playing item: \(description ?? "???")")
		let playerViewController=AVPlayerViewController()
		let playerView = AVPlayer.init(url: url)
		playerViewController.player = playerView
		self.navigationController?.pushViewController(playerViewController, animated: true)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { 
			playerViewController.player?.play()
		}
	}

	// MARK: VocObjSetChangeListener

	func vocService(_ vocService: VocService, objSetDidChange objSet: VocObjSet, added: Set<AnyHashable>, updated: Set<AnyHashable>, removed: Set<AnyHashable>, objectsBefore: [Any]) {
		self.tableView.reloadData()
	}

}
