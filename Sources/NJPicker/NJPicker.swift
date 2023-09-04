//
//  NJPicker.swift
//
//  Created by najin shin
//  contact : skwls2087@gmail.com
//

import SwiftUI

/**
 You Can Custom Picker!
 
 If you are bothered by the gray background in Picker, Try this!
 - warning: Available only in ios version 13.0 and later.
 ___
        NJPicker($selectedItem,
                data: ["1","2","3"],
                defaultValue: 0,
                hapticStyle: .light)
 
 ___
  >parameters.
  - parameters:
- data:Picker Data List
- defaultValue: initial value
- hapticStyle: intensity of haptic
*/

public struct NJPicker: View {
    
    let data: [String]
    
    @Binding private var selectedItem: String
    
    @State private var snappedItem: Int
    @State private var draggingItem = 0.0
    
    @State private var hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light
    @State private var hapticItem = 0
    
    public init(_ selectedItem: Binding<String>, data: [String], defaultValue: Int = 0, hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        self.data = data
        self.draggingItem = Double(defaultValue)
        self.hapticStyle = hapticStyle
        self.snappedItem = defaultValue
        
        self._selectedItem = selectedItem
    }
    
    public var body: some View {
        ZStack {
            ForEach(0..<data.count, id: \.self) { index in
                Text(String(format: data[index]))
                    .padding()
                    .offset(x: 0, y: myYOffset(index)) // 각 셀 위치
                    .scaleEffect(isSelectedItem(index) ? 1 : 0.9) // 비활성 셀 크기 작게
                    .opacity(isSelectedItem(index) ? 1 : 0.5) // 비활성 셀 투명하게
            }
        }
        .frame(height: 110)
        .clipped()
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged { value in
                    
                    // 타이머 숫자 이동
                    draggingItem = Double(snappedItem) + value.translation.height / 100
                    
                    // 셀 움직일 때마다 햅틱 진동 주기
                    if hapticItem != Int(draggingItem) {
                        self.hapticItem = Int(draggingItem)
                        HapticManager.instance.impact(style: hapticStyle)
                    }
                }
                .onEnded { value in
                    withAnimation {
                        //스크롤 여러개 띄어넘는 기능
                        draggingItem = Double(snappedItem) + value.predictedEndTranslation.height / 100
                        
                        // 딱 맞는 영역으로 고정시키는 기능
                        draggingItem = round(draggingItem)
                        
                        if draggingItem < 0 {
                            draggingItem = 0
                        } else if Int(draggingItem) >= data.count {
                            draggingItem = Double(data.count - 1)
                        }
                        
                        snappedItem = Int(draggingItem)
                        selectedItem = snappedItem >= 0 ? data[snappedItem] : data[data.count + snappedItem]
                    }
                }
        )
    }
    
    func isSelectedItem(_ item: Int) -> Bool {
        return (CGFloat(item) > draggingItem - 0.5) && (CGFloat(item) < draggingItem + 0.5)
    }
    func distance(_ item: Int) -> Double {
        return draggingItem - Double(item)
    }
    
    func myYOffset(_ item: Int) -> Double {
        return Double(40) * distance(item)
    }
}

class HapticManager {
    static let instance = HapticManager()
    private init() {}
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

