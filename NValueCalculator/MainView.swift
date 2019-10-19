//
//  MainView.swift
//  NValueCalculator
//
//  Created by 御堂 大嗣 on 2019/10/18.
//  Copyright © 2019 御堂 大嗣. All rights reserved.
//

import SwiftUI
import Combine

class Config: ObservableObject {
    // 出隅かどうか
    @Published var isCorner = false
    // 筋交いの有無
    @Published var withLeftCapitalDiagonal = false
    @Published var withLeftPedestalDiagonal = false
    @Published var withRightCapitalDiagonal = false
    @Published var withRightPedestalDiagonal = false
    // 窓か壁か
    static let wallTypes = ["壁", "窓"]
    @Published var selectedLeftWallTypes = 0
    @Published var selectedRightWallTypes = 0
    
    
    
    var leftWallValue: NSDecimalNumber {
        return selectedLeftWallTypes == 1 ?
            0.0 :
            withLeftPedestalDiagonal ? withLeftCapitalDiagonal ?
            3.0 : 1.5 : 0
    }
    var rightWallValue: NSDecimalNumber {
        return selectedRightWallTypes == 1 ?
        0.0 :
        withRightPedestalDiagonal ? withRightCapitalDiagonal ?
        3.0 : 1.5 : 0
    }
    var complement: NSDecimalNumber {
        // 左筋交い無し
        if !withLeftCapitalDiagonal && !withLeftPedestalDiagonal{
            if withRightCapitalDiagonal && withRightPedestalDiagonal{
                //右たすき
                return 0.0
            }else if withRightPedestalDiagonal {
                //右柱脚
                return -0.5
            }else if withRightCapitalDiagonal {
                //右柱頭
                return 0.5
            }else{
                //右無し
                return 0.0
            }
        }
        // 左柱頭
        else if withLeftCapitalDiagonal && !withLeftPedestalDiagonal{
            if withRightCapitalDiagonal{
                if withRightPedestalDiagonal{
                    //右両側
                    return 0.5
                }else{
                    //右柱頭
                    return 1.0
                }
            }else if withRightPedestalDiagonal{
                //右柱脚
                return 1.0
            }else{
                //右無し
                return 0.5
            }
        }
        //左柱脚
        else if withLeftPedestalDiagonal && !withLeftCapitalDiagonal{
            if withRightCapitalDiagonal{
                if withRightPedestalDiagonal{
                    //右両側
                    return 0.0
                }else{
                    //右柱頭
                    return 1.0
                }
            }else if withRightPedestalDiagonal{
                //右柱脚
                return 0.0
            }else{
                //右無し
                return -0.5
            }
        }
        //左無し
        else{
            if withRightCapitalDiagonal{
                if withRightPedestalDiagonal{
                    //右両側
                    return 0.0
                }else{
                    //右柱頭
                    return 0.5
                }
            }else if withRightPedestalDiagonal{
                //右柱脚
                return -0.5
            }else{
                //右無し
                return 0.0
            }
        }
        
        
        
    }
    
    var B1: NSDecimalNumber {
        return isCorner ? 0.8 : 0.5
    }
    var L: NSDecimalNumber {
        return isCorner ? 0.4 : 0.6
    }
    var nValue: NSDecimalNumber{
        return NSDecimalNumber(value:
                abs(Double(truncating: leftWallValue.subtracting(rightWallValue))
                )
            )
            .adding(complement)
            .multiplying(by: B1)
            .subtracting(L)
    }
    let labels = ["(い)", "(ろ)", "(は)", "(に)", "(ほ)", "(へ)", "(と)", "(ち)", "(り)", "(ぬ)", "-"]
    let maxNValues = [0, 0.65, 1, 1.4, 1.6, 1.8, 2.8, 3.7, 4.7, 5.6, 7.5]
    var jointLevelForNeed: Int? {
        for (index, max) in maxNValues.enumerated() {
            if (Double(truncating: nValue) <= max) {
                return Int?.init(index)
            }
        }
        return Int?.none
    }
    var jointForNeed: String {
        return jointLevelForNeed.map({labels[$0]}) ?? "エラー"
    }
    var jointLevelForNotification1460: Int {
        let withPedestal = withLeftPedestalDiagonal || withRightPedestalDiagonal
        return isCorner
            ? withPedestal ? 1 : 3
            : withPedestal ? 0 : 1
    }
    var jointForNotification1460: String{
        return labels[jointLevelForNotification1460]
    }
    var selectedJoint: String {
        return jointLevelForNeed
            .map({min($0, jointLevelForNotification1460)})
            .map({labels[$0]})
            ?? "エラー"
    }
    
    
}

class BenchmarkForJoints: ObservableObject {
    /*
    let labels = ["(い)", "(ろ)", "(は)", "(に)", "(ほ)", "(へ)", "(と)", "(ち)", "(り)", "(ぬ)", "-"]
    let maxNValue = [0, 0.65, 1, 1.4, 1.6, 1.8, 2.8, 3.7, 4.7, 5.6, 7.5]
    var neededJointLevel = Int {
        for (index, max) in selft.maxNValue {
            if
        }
    }*/
}

struct MainView: View {
    
    @ObservedObject var config = Config()
    
    var body: some View {
        NavigationView{
            
            Form{
                
                Section{
                    Toggle(isOn: $config.isCorner) {
                        Text("出隅")
                    }
                }
                
                Section(header: Text("左壁の設定")){
                    Picker(
                        selection: $config.selectedLeftWallTypes,
                        label: Text("壁/窓")
                    ) {
                        ForEach(0 ..< Config.wallTypes.count) {
                            Text(Config.wallTypes[$0])
                       }
                    }
                    .scaledToFill()
                    Toggle(isOn: $config.withLeftCapitalDiagonal) {
                        Text("筋交い 柱頭")
                    }
                    Toggle(isOn: $config.withLeftPedestalDiagonal) {
                        Text("筋交い 柱脚")
                    }
                }
                
                Section(header: Text("右壁の設定")){
                    Picker(
                        selection: $config.selectedRightWallTypes,
                        label: Text("壁/窓")
                    ) {
                        ForEach(0 ..< Config.wallTypes.count) {
                            Text(Config.wallTypes[$0])
                       }
                    }.scaledToFill()
                    Toggle(isOn: $config.withRightCapitalDiagonal) {
                        Text("筋交い 柱頭")
                    }
                    Toggle(isOn: $config.withRightPedestalDiagonal) {
                        Text("筋交い 柱脚")
                    }
                }
                
                Section(header: Text("計算結果")){
                    List{
                        Text("(| \(config.leftWallValue.description) - \(config.rightWallValue.description) | +  (\(config.complement.description) )) × \(config.B1.description) - \(config.L.description) = \(config.nValue.description)"
                        )
                        HStack{
                            Text("N値")
                            Spacer()
                            Text(config.nValue.description)
                        }
                        HStack{
                            Text("必要金物")
                            Spacer()
                            Text(config.jointForNeed)
                        }
                        HStack{
                            Text("告示1460金物")
                            Spacer()
                            Text(config.jointForNotification1460)
                        }
                        HStack{
                            Text("選定金物")
                            Spacer()
                            Text(config.selectedJoint)
                        }
                    }
                }
                
            }
            .navigationBarTitle(Text("N値計算"))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
