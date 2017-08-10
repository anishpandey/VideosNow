//
//  VideoCell.swift
//  D2GExample
//
//  Created by Tzvetan Todorov on 6/26/17.
//  Copyright © 2017 Akamai. All rights reserved.
//

import UIKit
import VocSdk


class VideoCell: UITableViewCell {

	@IBOutlet weak var thumbnail: UIImageView!
	@IBOutlet weak var info: UILabel!
	@IBOutlet weak var info2: UILabel!
	@IBOutlet weak var progress: UILabel!

	var _video : VocItemVideo?

	/// The VocItem to display in the table cell
	var video : VocItemVideo? {
		get { return _video }
		set {
			_video = newValue

			self.info.text = _video?.summary

			if let thumbnail = _video?.thumbnail, let path = thumbnail.localPath {
				self.thumbnail.image = UIImage.init(contentsOfFile: path)
			} else {
				self.thumbnail.image = nil;
			}

			self.updateProgress(size: _video!.size, bytesDownloaded: _video!.bytesDownloaded)

			var stateInfo : String = ""

			switch _video!.state {
			case .VOCItemDiscovered:
				self.progress.isHidden = false
				self.backgroundColor = UIColor.lightGray
				stateInfo = "NEW"
				break

			case .VOCItemQueued:
				self.progress.isHidden = false
				self.backgroundColor = UIColor.white
				stateInfo = "QUEUE"
				break

			case .VOCItemDownloading:
				self.progress.isHidden = false
				self.backgroundColor = UIColor.white
				stateInfo = "DL"
				break

			case .VOCItemIdle:
				self.progress.isHidden = false
				self.backgroundColor = UIColor.orange
				stateInfo = "IDLE"
				break

			case .VOCItemPaused:
				self.progress.isHidden = false
				self.backgroundColor = UIColor.yellow
				stateInfo = "PAUSE"
				break

			case .VOCItemCached:
				self.progress.isHidden = true
				self.backgroundColor = UIColor.green
				stateInfo = "CACHE"
				break

			case .VOCItemPartiallyCached:
				self.progress.isHidden = true
				self.backgroundColor = UIColor.green
				stateInfo = "CACHE%"
				break

			case .VOCItemFailed:
				self.progress.isHidden = false
				self.backgroundColor = UIColor.red
				stateInfo = "ERROR"
				break

			default:
				self.progress.isHidden = false
				self.backgroundColor = UIColor.gray
			}

			var progress : Int64 =  _video!.size <= 0 ? 0 :  _video!.bytesDownloaded * 100 /  _video!.size
			progress = progress <= 100 ? progress : 100

			self.info2.text = "\(_video!.contentId)\n\(stateInfo)\n\(progress)"
		}
	}

	func updateProgress(size: Int64, bytesDownloaded: Int64) -> Void {

		if (size <= 0) {
			print("Size is wrong: \(size)")
			self.progress.text = "???"
			return
		}

		var progress : Int64 = bytesDownloaded * 100 / size
		progress = progress <= 100 ? progress : 100

		self.progress.text = "\(progress)"
	}


}
