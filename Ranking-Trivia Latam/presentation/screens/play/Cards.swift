//
//  Cards.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import SwiftUI

struct CardFlag: View {
    
    let flag: TriviaFlag
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.appCustomGreen.opacity(0.8))
            .frame(width: 120, height: 110)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 2)
            )
            .overlay {
                VStack {
                    if let uiImage = flag.loadImage() {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 0.8)
                            )
                    }
                    
                    Text(flag.name)
                        .multilineTextAlignment(.center)
                        .font(.custom("FredokaCondensed-Bold", size: 18))
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding(.top, 2)
                    
                }
            }
    }
}

#Preview {
    CardFlag(flag: TriviaFlag(
        id: .MX,
        name: NSLocalizedString("country_name_mexico", comment: ""),
        image: "flag_mexico",
        alreadyPlayed: false)
    )
}


struct CardEmptySpace: View {
    
    let index: Int
    let emptySpace: EmptySpace
    let viewModel: PlayViewModel
    
    var body: some View {
        HStack {
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 12)
                    .fill(emptySpace.flagIsOver ? Color.red : Color.white)
                    .frame(width: 120, height: 110)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 2)
                    ).overlay {
                        VStack {
                            if emptySpace.flag == nil {
                                Text("\(index + 1)°")
                                    .font(.custom("FredokaCondensed-Bold", size: 28))
                                    .shadow(color: .gray, radius: 1, x: 1, y: 1)
                                    .foregroundColor(.gray).opacity(0.5)
                            } else {
                                CardFlag(flag: emptySpace.flag!)
                            }
                        }
                    }
                    .onAppear {
                        /*
                        let rect = geometry.frame(in: .global)
                            
                        // Ajustar las coordenadas moviendo el cuadro un poco hacia la izquierda.
                        let adjustedX = rect.origin.x - 200 // Ajusta el valor según lo que necesites.
                        // Aumentar el ancho del cuadro en 20 puntos (o el valor que prefieras).
                        let increasedWidth = rect.width + 150
                        
                        // Ajustar las coordenadas moviendo el cuadro un poco hacia la izquierda.
                        let adjustedY = rect.origin.y + 200 // Ajusta el valor según lo que necesites.
                        // Aumentar el ancho del cuadro en 20 puntos (o el valor que prefieras).
                        let increasedHeight = rect.height + 20
                        //let increasedHeight = 210.0
                        
                        // Crear un nuevo CGRect con el nuevo valor ajustado y el ancho aumentado.
                        let adjustedRect = CGRect(x: adjustedX, y: adjustedY, width: increasedWidth, height: increasedHeight)
                        
                        viewModel.spaces[index].frame = adjustedRect
                        */
                        
                        let i = geometry.frame(in: .global)
                        viewModel.spaces[index].frame = i
                    }
            }
            .frame(width: 120, height: 110)
            
            
            /*if emptySpace.flag != nil {
                Image("ic_remove_filled")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    .onTapGesture {
                        if viewModel.shouldPlaySound() {
                            Ranking_Trivia_Latam.playSound("sound_remove")
                        }
                        viewModel.addFlagToList(flag: emptySpace.flag!)
                        viewModel.updateEmptySpace(emptySpaceId: emptySpace.id, flag: nil)
                    }
            } else {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.black.opacity(0.005))
            }*/
        }
    }
}


#Preview {
    CardEmptySpace(
        index: 0,
        emptySpace: EmptySpace(id: 0, flag: nil),
        viewModel: PlayViewModel()
    )
}
