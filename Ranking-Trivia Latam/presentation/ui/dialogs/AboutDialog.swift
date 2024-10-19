//
//  AboutDialog.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import SwiftUI

struct AboutDialog: View {
    
    var onExitClicked: () -> Void
    
    var body: some View {
        BaseDialog(
            titleWidth: 150,
            title: "Acerca de",
            content: {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Image("ic_info")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.bottom, 5)
                        
                        Spacer(minLength: 10)
                        
                        ExpandableText(text: NSLocalizedString("about_disclaimer", comment: ""))
                        Spacer(minLength: 12)
                        ExpandableText(text: NSLocalizedString("about_ads", comment: ""))
                        Spacer(minLength: 12)
                        ExpandableText(text: NSLocalizedString("about_ui_and_sounds", comment: ""))
                        Spacer(minLength: 35)
                        
                        ButtonExitOrRetry(
                            onClick: onExitClicked,
                            content: {
                                Text("Salir")
                                    .font(.custom("FredokaCondensed-Semibold", size: 22))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 16)
                            }
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 10)
                }
                .frame(height: 300)
            }
        )
    }
}

struct ExpandableText: View {
    let text: String
    let maxLines: Int = 1
    let readMore: String = "Leer más"
    let readLess: String = "Leer menos"
    
    @State private var expandedState: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.custom("FredokaCondensed-Semibold", size: 16))
                .foregroundColor(.black)
                .lineLimit(expandedState ? nil : maxLines)
                .onTapGesture {
                    expandedState.toggle()
                }
            
            // Mostrar el texto "Leer más" o "Leer menos" si el texto es más largo que 44 caracteres
            if text.count > 44 {
                Text(expandedState ? readLess : readMore)
                    .font(.custom("FredokaCondensed-Semibold", size: 15))
                    .foregroundColor(Color.appCustomBlue)
                    .onTapGesture {
                        expandedState.toggle()
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/*struct ExpandableText_Previews: PreviewProvider {
    static var previews: some View {
        ExpandableText(text: "Este es un texto largo que puede ser expandido para mostrar más contenido.")
            .padding()
    }
}*/

#Preview {
    AboutDialog(onExitClicked: {})
}
