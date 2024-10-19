//
//  BaseDialog.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import SwiftUI

struct BaseDialog<Content: View>: View {
    
    var titleWidth: CGFloat
    var title: String
    var content: () -> Content

    var body: some View {
        ZStack(alignment: .top) {
            ZStack {
                VStack {
                    VStack {
                        content()
                            .padding(.vertical, 15)
                    }
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal, 12)
                    .padding(.top, 38)
                    .padding(.bottom, 15)
                }
                .background(Color.appCustomBlue.opacity(0.9))
                .cornerRadius(10)
                .padding(.horizontal, 12)
                .padding(.bottom, 10)
                .padding(.top, 30)
            }
            .padding(.top, 17)
            
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.AppYellow)
                    .frame(width: titleWidth, height: 50)
                    .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.black, lineWidth: 2)
                    )
                
                Text(title)
                    .font(.custom("FredokaCondensed-Bold", size: 24))
            }
            .padding(.top, 25)
        }
        .frame(maxWidth: UIScreen.screenWidth)

    }
}

struct CustomDialog<DialogContent: View>: ViewModifier {
  @Binding var isShowing: Bool
    let padding: CGFloat
  let dialogContent: DialogContent

  init(
    isShowing: Binding<Bool>,
    padding: CGFloat,
    @ViewBuilder dialogContent: () -> DialogContent
  ) {
    _isShowing = isShowing
      self.padding = padding
     self.dialogContent = dialogContent()
  }

  func body(content: Content) -> some View {
   // wrap the view being modified in a ZStack and render dialog on top of it
    ZStack {
      content
      if isShowing {
        // the semi-transparent overlay
          Rectangle().foregroundColor(Color.black.opacity(0.6)).edgesIgnoringSafeArea(.all)
        // the dialog content is in a ZStack to pad it from the edges
        // of the screen
        ZStack {
          dialogContent
            
        }.padding(padding)
      }
    }
  }
}

extension View {
    func popUpDialog<DialogContent: View>(
        isShowing: Binding<Bool>,
        padding: CGFloat = 15,
        @ViewBuilder dialogContent: @escaping () -> DialogContent
    ) -> some View {
        self.modifier(
            CustomDialog(
                isShowing: isShowing,
                padding: padding,
                dialogContent: { AnyView(dialogContent()) }
            )
        )
    }
}
