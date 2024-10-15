//
//  PlayScreen.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


struct PlayScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var dragInfo = DragTargetInfo()
    
    
    @State private var leftItems: [EmptySpace] = [
        EmptySpace(id: 0, flag: nil),
        EmptySpace(id: 1, flag: nil),
        EmptySpace(id: 2, flag: nil),
    ]
    @State private var rightItems: [TriviaFlag] = [
        TriviaFlag(id: .AR, name: NSLocalizedString("country_name_argentina", comment: ""), image: "flag_argentina", alreadyPlayed: false),
        TriviaFlag(id: .BZ, name: NSLocalizedString("country_name_belize", comment: ""), image: "flag_belize", alreadyPlayed: false),
        TriviaFlag(id: .BO, name: NSLocalizedString("country_name_bolivia", comment: ""), image: "flag_bolivia", alreadyPlayed: false),
        TriviaFlag(id: .BR, name: NSLocalizedString("country_name_brasil", comment: ""), image: "flag_brasil", alreadyPlayed: false)
    ]
    
    @State var draggedItem: TriviaFlag?
    
    var body: some View {
        ZStack {
            PlayScreenBackground()
            
            VStack {
                HeaderBackAndCategory {
                    presentationMode.wrappedValue.dismiss()
                }
                
                HStack {
                    GeometryReader { geometry in
                        LazyVStack(spacing: 20) {
                            ForEach(Array(leftItems.enumerated()), id: \.offset) { i, item in
                                CardEmptySpace(index: i,emptySpace: item)
                                    .onDrop(of: [.text], delegate: EmptySpaceDropDelegate(draggedItem: $draggedItem, leftItems: $leftItems, index: i))
                            }
                        }
                    }
                    
                    GeometryReader { geometry in
                        LazyVStack(spacing: 20) {
                            ForEach(rightItems, id: \.self) { item in
                                CardFlag(flag: item)
                                    .onDrag {
                                        draggedItem = item
                                        return NSItemProvider(object: item)
                                    }
                                    .opacity(draggedItem == item ? 0 : 1)
                            }
                        }
                        .onDrop(of: [.text], delegate: MyDropDelegato(draggedItem: $draggedItem, items: $rightItems, geometry: geometry))
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
            .padding(.horizontal, 196)
        }
    }
    
    struct EmptySpaceDropDelegate: DropDelegate {
        
            @Binding var draggedItem: TriviaFlag?
            @Binding var leftItems: [EmptySpace]
            var index: Int
            
            func performDrop(info: DropInfo) -> Bool {
                guard let item = draggedItem else { return false }
                
                // Asignar el item al espacio vacío si no tiene uno
                if leftItems[index].flag == nil {
                    leftItems[index].flag = item
                    //draggedItem?.alreadyPlayed = true
                }
                
                // Resetea el ítem arrastrado
                draggedItem = nil
                return true
            }
            
            func dropEntered(info: DropInfo) {
                // Aquí podrías agregar animaciones o efectos al entrar al área de drop
            }
            
            func dropUpdated(info: DropInfo) -> DropProposal? {
                return DropProposal(operation: .move)
            }
        }
    
    
    struct MyDropDelegato: DropDelegate {
        /// The item currently being dragged
        @Binding var draggedItem: TriviaFlag?
        
        /// The items in the column
        @Binding var items: [TriviaFlag]
        
        /// The geometry of the grid
        var geometry: GeometryProxy
        
        func performDrop(info: DropInfo) -> Bool {
            withAnimation {
                /// Reset dragged item
                draggedItem = nil
            }
            return true
        }
        
        func dropUpdated(info: DropInfo) -> DropProposal? {
            /// Get the index from the drop info location
            let destination = getIndexForItem(itemPosition: info.location)
            
            withAnimation {
                if let item = draggedItem, let origin = items.firstIndex(of: item) {
                    let adjustedDestination = destination < origin ? destination : min(destination + 1, items.count)
                    items.move(fromOffsets: IndexSet(integer: origin), toOffset: adjustedDestination)
                }
            }
            return DropProposal(operation: .move)
        }
        
        func dropEntered(info: DropInfo) {
            guard let item = draggedItem else { return }
            if items.firstIndex(of: item) == nil {
                items.append(item)
            }
        }
        
        func dropExited(info: DropInfo) {
            guard let item = draggedItem else { return }
            if let index = items.firstIndex(of: item) {
                items.remove(at: index)
            }
        }
        
        func getIndexForItem(itemPosition: CGPoint) -> Int {
            let itemWidth: CGFloat = 80
            let itemHeight: CGFloat = 50
            let spacing: CGFloat = 20
            
            let numberOfColumns = Int(geometry.size.width / itemWidth)
            let column = Int(itemPosition.x / itemWidth)
            let row = Int(itemPosition.y / (itemHeight + spacing))
            
            let index = row * numberOfColumns + column
            return index
        }
    }
    
    struct DragAndDropView_Previews: PreviewProvider {
        static var previews: some View {
            PlayScreen()
        }
    }
}

struct PlayScreenBackground: View {
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(named: "pyramid_one")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VignetteInverseEffect()
        }
    }
}
