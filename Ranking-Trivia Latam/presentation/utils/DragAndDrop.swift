//
//  DragAndDrop.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/15/24.
//

import SwiftUI
import Combine

struct LongPressDraggable<Content: View>: View {
    @StateObject private var dragInfo = DragTargetInfo()
    
    let content: () -> Content
    
    var body: some View {
        ZStack {
            content()
                .environmentObject(dragInfo)
            
            if dragInfo.isDragging, let flag = dragInfo.dataToDrop {
                Image(uiImage: flag.loadImage() ?? UIImage())
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaleEffect(0.7)
                    .opacity(0.8)
                    .position(x: dragInfo.dragPosition.x + dragInfo.dragOffset.width,
                              y: dragInfo.dragPosition.y + dragInfo.dragOffset.height)
            }
        }
    }
}


struct DragTarget: View {
    @EnvironmentObject var dragInfo: DragTargetInfo
    let triviaFlag: TriviaFlag
    let content: () -> AnyView

    @State private var currentPosition: CGPoint = .zero
    @GestureState private var dragOffset: CGSize = .zero
    
    var body: some View {
        content()
            .onAppear {
                currentPosition = CGPoint.zero
            }
            .gesture(
                LongPressGesture(minimumDuration: 0.5)
                    .onEnded { _ in
                        dragInfo.dataToDrop = triviaFlag
                        dragInfo.isDragging = true
                        dragInfo.dragPosition = currentPosition
                    }
                    .exclusively(before: DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation
                        }
                        .onEnded { _ in
                            dragInfo.isDragging = false
                            dragInfo.dragOffset = .zero
                        }
                    )
            )
            .onChange(of: dragOffset) { oldValue, newValue in
                dragInfo.dragOffset = newValue
            }
    }
}

struct DropTarget: View {
    
    @EnvironmentObject var dragInfo: DragTargetInfo
    let content: (Bool, TriviaFlag?) -> AnyView
    
    var body: some View {
        GeometryReader { geo in
            content(isDropTarget(geo: geo), dragInfo.dataToDrop)
                .onChange(of: dragInfo.dragPosition) { oldValue, newValue in
                    if isDropTarget(geo: geo) && !dragInfo.isDragging {
                        // Se puede manejar la lógica de soltar aquí
                        dragInfo.dataToDrop = nil
                    }
                }
        }
    }
    
    private func isDropTarget(geo: GeometryProxy) -> Bool {
        let rect = geo.frame(in: .global)
        let dropArea = CGRect(x: rect.minX - 50,
                              y: rect.minY - 50,
                              width: rect.width + 100,
                              height: rect.height + 100)
        return dropArea.contains(dragInfo.dragPosition)
    }
}

class DragTargetInfo: ObservableObject {
    @Published var isDragging: Bool = false
    @Published var dragPosition: CGPoint = .zero
    @Published var dragOffset: CGSize = .zero
    @Published var dataToDrop: TriviaFlag? = nil
}
