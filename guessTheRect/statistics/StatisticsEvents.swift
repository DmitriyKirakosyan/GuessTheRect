//
//  StatisticsEvents.swift
//  guessTheRect
//
//  Created by Dmitriy Kirakosyan on 21/02/2015.
//  Copyright (c) 2015 Dmitriy Kirakosyan. All rights reserved.
//


struct StatisticsEvents {
    static let GAME_OVER = "Game_Over"
    static let TUTOR_COMPLETED = "Tutor_Completed"
    static let LEVEL_COMPLETED = "Level_Completed"
    static let GAME_SESSION_DURATION = "Game_Session_Duration"
    
    //UI
    
    static let RESET_BTN_CLICKED = "Reset_Btn_Clicked"
    static let PAUSE_BTN_CLICKED = "Pause_Btn_Clicked"
    
    
    //parameters for events
    
    static let PARAM_TIME = "time"
    static let PARAM_SCORE = "score"
    static let PARAM_LEVEL = "level"
}