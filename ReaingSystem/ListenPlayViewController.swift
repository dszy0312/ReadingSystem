//
//  ListenPlayViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/12.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import AVFoundation

class ListenPlayViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var currTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    //缓存记录
    @IBOutlet weak var slider: UISlider!
    //播放记录
    @IBOutlet weak var progressView: UIProgressView!
    //开关键
    @IBOutlet weak var controlButton: UIButton!
    
    @IBOutlet weak var addShelfButton: UIButton!
    
    //播放数据
    var listenData: ListenReturnData!
    var index = 0
    //音频播放
    var playerItem: AVPlayerItem!
    var avplayer: AVPlayer!
    //逐帧监测
    var link: CADisplayLink!
    //是否有滑动
    var sliding = false
    //是否在播放
    var playing = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //是否已加入书架
        if self.listenData.isOnShelf == "1" {
            self.addShelfButton.selected = true
            self.addShelfButton.setImage(UIImage(named: "readDetail_onShelf_gray"), forState: .Selected)
        }
        self.listenPlay(baseURl + listenData.dirList[index].audioUrl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.titleLabel.text = listenData.dirList[index].chapterName
        self.authorLabel.text = listenData.author
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        deleteListenData()
    }
    /*
    deinit {
        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem.removeObserver(self, forKeyPath: "status")
    }*/
    
    @IBAction func backClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //播放暂停按钮
    @IBAction func playClick(sender: UIButton) {
        playing = !playing
        if playing {
            sender.setImage(UIImage(named: "listen_zanting"), forState: .Normal)
            if self.avplayer.status == AVPlayerStatus.ReadyToPlay {
                self.avplayer.play()
            }
        } else {
            sender.setImage(UIImage(named: "listen_play"), forState: .Normal)
            self.avplayer.pause()
        }
    }
    @IBAction func addToShelf(sender: UIButton) {
        if sender.selected == false {
            
            self.addToShelf()
        }
    }
    
    @IBAction func beforeClick(sender: UIButton) {
        guard index != 0 else {
            return
        }
        index -= 1
        deleteListenData()
        listenPlay(baseURl + listenData.dirList[index].audioUrl)
        self.titleLabel.text = listenData.dirList[index].chapterName
        self.authorLabel.text = listenData.author
    }
    
    @IBAction func afterClick(sender: UIButton) {
        guard index != listenData.dirList.count - 1 else {
            return
        }
        index += 1
        deleteListenData()
        listenPlay(baseURl + listenData.dirList[index].audioUrl)
        self.titleLabel.text = listenData.dirList[index].chapterName
        self.authorLabel.text = listenData.author
    }
    
    
    //MARK:私有方法
    //数据设置
    func initData(listenData: ListenReturnData, index: Int) {
        self.listenData = listenData
        self.index = index
    }
    //音频下载播放
    func listenPlay(url: String) {
        guard let url = NSURL(string: baseURl + listenData.dirList[index].audioUrl) else {
            print("连接错误")
            return
        }
        playerItem = AVPlayerItem(URL: url)
        //监听缓冲进度
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.New, context: nil)
        //监听状态改变
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        
        //将音频资源赋值给音频播放对象
        self.avplayer = AVPlayer(playerItem: playerItem)
        
        self.link = CADisplayLink(target: self, selector: #selector(update(_:)))
        self.link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
        
        //按下时
        slider.addTarget(self, action: #selector(sliderTouchDown(_:)), forControlEvents: UIControlEvents.TouchDown)
        //弹起时
        slider.addTarget(self, action: #selector(sliderTouchUpOut(_:)), forControlEvents: UIControlEvents.TouchUpOutside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(_:)), forControlEvents: UIControlEvents.TouchCancel)
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "loadedTimeRanges" {
            print("缓冲进度")
            let loadedTime = availableDurtionWithPlayerItem()
            let totalTime = CMTimeGetSeconds(playerItem.duration)
            let precent = loadedTime / totalTime
            //改变进度条
            self.progressView.progress = Float(precent)
        } else if keyPath == "status" {
            //监听状态改变
            if playerItem.status == AVPlayerItemStatus.ReadyToPlay {
                // 只有这个状态下才能播放
                self.avplayer.play()
            } else {
                print("加载异常")
            }
        }
    }
    
    func formatPlayTime(seconds: NSTimeInterval) -> String {
        var hourStr = ""
        var minStr = ""
        var secStr = ""
        if seconds.isNaN {
            return "00:00:00"
        }
        let hour = Int(seconds / 3600)
        if hour < 10 {
            hourStr = "0\(hour)"
        } else {
            hourStr = "\(hour)"
        }
        let min = Int((seconds % 3600) / 60)
        if min < 10 {
            minStr = "0\(min)"
        } else {
            minStr = "\(min)"
        }
        let sec = Int(seconds % 60)
        if sec < 10 {
            secStr = "0\(sec)"
        } else {
            secStr = "\(sec)"
        }
        return "\(hourStr):\(minStr):\(secStr)"
    }
    
    func update(display: CADisplayLink) {
        //当前时间
        let currentTime = CMTimeGetSeconds(self.avplayer.currentTime())
        //总时间
        let totalTime = NSTimeInterval(playerItem.duration.value) / NSTimeInterval(playerItem.duration.timescale)
        //timescale 这里表示压缩比例
//        let timeStr = "\(formatPlayTime(currentTime))/\(formatPlayTime(totalTime))"
        currTimeLabel.text = formatPlayTime(currentTime)
        totalTimeLabel.text = formatPlayTime(totalTime)//赋值
        if !self.sliding {
            self.slider.value = Float(currentTime/totalTime)
        }
    }
    
    func sliderTouchDown(slider: UISlider) {
        self.sliding = true
    }
    func sliderTouchUpOut(slider: UISlider) {
        //当音频状态为AVPlayerStatusReadyToPlay
        if self.avplayer.status == AVPlayerStatus.ReadyToPlay {
            let duration = slider.value * Float(CMTimeGetSeconds(self.avplayer.currentItem!.duration))
            let seekTime = CMTimeMake(Int64(duration), 1)
            //指定音频位置
            self.avplayer.seekToTime(seekTime, completionHandler: { (b) in
                self.sliding = false
            })
        }
        
        
    }
    
    //缓冲进度
    func availableDurtionWithPlayerItem() -> NSTimeInterval {
        guard let loadedTimeRanges = avplayer.currentItem?.loadedTimeRanges, let first = loadedTimeRanges.first else {
            fatalError()
        }
        let timeRange = first.CMTimeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecond = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecond
        return result
    }
    
    //音频清理
    func deleteListenData() {
        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem.removeObserver(self, forKeyPath: "status")
        self.avplayer.pause()
        self.link.paused = true
        self.link.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        self.playerItem = nil
        self.avplayer = nil
    }
    

    //添加书架请求
    func addToShelf() {
        let parm: [String: AnyObject] = [
            "prID": listenData.audioID
        ]
        //用POST出错，未知原因
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.addToShelfURL.introduce(), parameter: parm, completion: { (dictionary, error) in
            
            if let flag = dictionary!["flag"] as? Int {
                print("flag= \(flag)")
                if flag == 1 {
                    self.addShelfButton.selected = true
                    self.addShelfButton.setImage(UIImage(named: "readDetail_onShelf_gray"), forState: UIControlState.Selected)
                } else {
                    print("添加未成功")
                }
                
            }
        })
    }

}
