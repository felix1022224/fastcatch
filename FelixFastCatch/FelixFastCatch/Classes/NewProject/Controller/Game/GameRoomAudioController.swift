//
//  GameRoomAudioController.swift
//  FelixFastCatch
//
//  Created by 卢凡 on 2018/1/23.
//  Copyright © 2018年 felix. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - 游戏房间的声音管理
extension GameRoomViewController{
    
    /// 播放背景声音
    func playBackgroundMusic() -> () {
        
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch _ {
            print("switch speaker error~")
        }
        
        //获取bg.mp3文件地址
        let bgMusicURL =  Bundle.main.path(forResource: "background_music", ofType: "mp3")!
        //地址转换
        let baseURL = URL(fileURLWithPath: bgMusicURL)
        //根据背景音乐地址生成播放器
        try? bgMusicPlayer = AVAudioPlayer(contentsOf: baseURL)
        //设置为循环播放
        bgMusicPlayer.numberOfLoops = -1
        //准备播放音乐
        bgMusicPlayer.prepareToPlay()
        
        if !isCloseMusic {
            //播放音乐
            bgMusicPlayer.play()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseSong(notification:)), name:NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playSong(notification:)), name:NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc func pauseSong(notification : NSNotification) {
        if bgMusicPlayer != nil {
            bgMusicPlayer.pause()
        }
    }
    
    @objc func playSong(notification : NSNotification) {
        if !isCloseMusic {
            if bgMusicPlayer != nil {
                bgMusicPlayer.play()
            }
        }
    }
    
    /// 播放开始游戏的音效
    func playStartGame() -> () {
        if isCloseMusic {
            return
        }
        
        // 建立播放器
        let soundPath = Bundle.main.path(forResource: "游戏开始_音效", ofType: "wav")
        do {
            soundEffect = try AVAudioPlayer(
                contentsOf: NSURL.fileURL(withPath: soundPath!))
            
            // 重複播放次數 設為 0 則是只播放一次 不重複
            soundEffect.numberOfLoops = 0
            
            soundEffect.play()
        } catch {
            print("开始音效，error")
        }
        
        //振动
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    /// 播放抓取成功的音效
    func playGrapSuccess() -> () {
        if isCloseMusic {
            return
        }
        
        // 建立播放器
        let soundPath = Bundle.main.path(forResource: "抓取成功_音效", ofType: "wav")
        do {
            soundEffect = try AVAudioPlayer(
                contentsOf: NSURL.fileURL(withPath: soundPath!))
            
            // 重複播放次數 設為 0 則是只播放一次 不重複
            soundEffect.numberOfLoops = 0
            
            soundEffect.play()
        } catch {
            print("抓取成功音效，error")
        }
    }
    
    /// 播放抓取失败的音效
    func playGrapFail() -> () {
        if isCloseMusic {
            return
        }
        
        // 建立播放器
        let soundPath = Bundle.main.path(forResource: "抓取失败_音效", ofType: "wav")
        do {
            soundEffect = try AVAudioPlayer(
                contentsOf: NSURL.fileURL(withPath: soundPath!))
            
            // 重複播放次數 設為 0 則是只播放一次 不重複
            soundEffect.numberOfLoops = 0
            
            soundEffect.play()
        } catch {
            print("抓取失败音效，error")
        }
    }
    
    /// 播放切换镜头的音效
    func playSwitchMusic() -> () {
        if isCloseMusic {
            return
        }
        
        // 建立播放器
        let soundPath = Bundle.main.path(forResource: "镜头切换_音效", ofType: "wav")
        do {
            soundEffect = try AVAudioPlayer(
                contentsOf: NSURL.fileURL(withPath: soundPath!))
            
            // 重複播放次數 設為 0 則是只播放一次 不重複
            soundEffect.numberOfLoops = 0
            
            soundEffect.play()
        } catch {
            print("镜头切换音效，error")
        }
    }
    
    /// 关掉声音
    func closeMusic() -> () {
        isCloseMusic = true
        bgMusicPlayer.pause()
    }
    
}
