//
//  VideosViewController.swift
//  D2GExample
//
//  Created by Tzvetan Todorov on 6/26/17.
//  Copyright © 2017 Akamai. All rights reserved.
//

import UIKit
import VocSdk
import AVFoundation
import AVKit


class VideosViewController: UITableViewController, VocObjSetChangeListener {

	// The latest video set received from the PCD SDK
	var pcdVideos : VocVideoSet? = nil
	var fetching : Bool = false

    //Update the on demand content details:
    let onDemandContentIds: Set<String> = ["contentId_1","contentId_2"]
    let providerName = "Content_Provider"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false

		if self.pcdVideos == nil {

			AppDelegate.instance.pcdService!.getVideosWith(VocVideoFilter.all(withSort: nil)!) { (error, videoSet) in
				if (error != nil) {
					print("Unable to get videos: \(String(describing: error))")
					return
				}

				print("Recieved videos with \(String(describing: videoSet?.videos.count)) videos")
				self.pcdVideos = videoSet
				self.pcdVideos?.add(self)
			}
		}
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
        //Content Reload Header Row
		case 0:
			return 1

        //Content Rowz
		case 1:
			guard let count = self.pcdVideos?.videos.count else { return 0 }
			return count

		default:
			break
		}
		return 0
    }

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

		switch indexPath.section {
		case 0:
			return tableView.rowHeight / 2

		default:
			break
		}

		return tableView.rowHeight
	}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		switch indexPath.section {

			case 1:
				let video = self.pcdVideos?.videos[indexPath.row] as? VocItemVideo
				let videoCell : VideoCell! = tableView.dequeueReusableCell(withIdentifier: "cellVideo", for: indexPath) as? VideoCell
				videoCell.video = video
				return videoCell

			default:
				break
		}

		let cell : UITableViewCell
		cell = tableView.dequeueReusableCell(withIdentifier: "cellGetIds", for: indexPath)
		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)

		switch indexPath.section {

		case 1:
			break

		default:

			if self.fetching {
				return
			}
			self.fetching = true

			AppDelegate.instance.pcdService!.getItemsWithContentIds(
				onDemandContentIds,
				sourceName: providerName) { (error, itemSet) in

					self.fetching = false
			}

			return
		}

		let video : VocItemVideo = self.pcdVideos?.videos[indexPath.row] as! VocItemVideo

        //Download Action
		let actionDownload : UIAlertAction = UIAlertAction.init(title: "DOWNLOAD", style: .default) { (action) in

			print("START DOWNLOAD")

			AppDelegate.instance.pcdService?.downloadItems([video],
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

			AppDelegate.instance.pcdService?.pauseItemDownload(video, completion: nil)

			tableView.reloadRows(at: [indexPath], with: .automatic)
		}

        //Playback of cached Contents
		let actionPlay : UIAlertAction = UIAlertAction.init(title: "PLAY", style: .default) { (action) in

			print("PLAY VIDEO")

			if (video.conforms(to: VocItemHLSVideo.self)) {

				AppDelegate.instance.pcdService?.startHLSServer(completion: { (success) in
					let hlsVideo = video as! VocItemHLSVideo
					let url = AppDelegate.instance.pcdService?.hlsServerUrl?.appendingPathComponent(hlsVideo.hlsServerRelativePath!)
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
		print("Playing video: \(description ?? "???")")
		let playerViewController=AVPlayerViewController()
		let playerView = AVPlayer.init(url: url)
		playerViewController.player = playerView
        self.present(playerViewController, animated: true) { 
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                playerViewController.player?.play()
            }
        }

	}

	// MARK: VocObjSetChangeListener

    /*
    * Any update for the contents retrieved through the ObjectSet
    * will be notified through VocObjSetChangeListener delegate methods.
    */
	func vocService(_ vocService: VocService, objSetDidChange objSet: VocObjSet,
	                added: Set<AnyHashable>,
	                updated: Set<AnyHashable>,
	                removed: Set<AnyHashable>,
	                objectsBefore: [Any]) {

		self.tableView.reloadData()
	}
}
