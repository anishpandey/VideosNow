//
//  VideoCell.swift
//  VocSdkExampleSwift
//
//  Created by Gensch, Larry on 5/17/17.
//  Copyright © 2017 Akamai Technologies. All rights reserved.
//

import UIKit
import VocSdk

class VideoCell: UITableViewCell {

	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var thumbnail: UIImageView!
	@IBOutlet weak var info: UILabel!
	@IBOutlet weak var info2: UILabel!
	@IBOutlet weak var progress: UILabel!

	override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	func setBGColorAndStateForItem(item : VocItem?) {
		guard let item = item else { return }

		switch item.state {
		case .VOCItemDiscovered:
			self.backgroundColor = UIColor.brown
			self.info.text = "DISCOVERED"

		case .VOCItemIdle:
			self.backgroundColor = UIColor.orange
			self.info.text = "IDLE"

		case .VOCItemDownloading:
			self.backgroundColor = UIColor.gray
			self.info.text = "DISCOVERED"

		case .VOCItemQueued:
			self.backgroundColor = UIColor.gray
			self.info.text = "QUEUED"

		case .VOCItemCached :
			self.backgroundColor = UIColor.white
			self.info.text = "CACHED"

		case .VOCItemPartiallyCached:
			self.backgroundColor = UIColor.white
			self.info.text = "P-CACHED"

		case .VOCItemPaused:
			self.backgroundColor = UIColor.yellow
			self.info.text = "PAUSED"

		case .VOCItemFailed:
			self.backgroundColor = UIColor.red
			self.info.text = "FAILED"

		default:
			self.backgroundColor = UIColor.gray
		}
	}

	var _item : VocItem?

	/// The VocItem to display in the table cell
	var item : VocItem? {
		get { return _item }
		set {
			guard let item = newValue else { _item = nil; return }

			_item = newValue

			self.title.text = _item?.title

			if let thumbnail = item.thumbnail, let path = thumbnail.localPath {
				self.thumbnail.image = UIImage.init(contentsOfFile: path)
			} else {
				self.thumbnail.image = nil;
			}
			self.info2.text = "Content ID:\(String(describing: _item!.contentId))"

			self.setBGColorAndStateForItem(item: item)

			switch item.state {
			case .VOCItemCached, .VOCItemPartiallyCached:
				self.progress.isHidden = true

			default:
				self.progress.isHidden = false
			}
		}
	}

	func updateProgress(size: Double, bytesDownloaded: Double) -> Void {
		if (size <= 0) {
			print("Size is wrong: \(size)")
			return
		}
		var progress : Int = Int((bytesDownloaded * 100.00) / size * 100.00)
		progress = progress < 100 ? progress : 100
		self.progress.text = "\(progress)"
	}
}
