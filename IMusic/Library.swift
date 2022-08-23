//
//  Library.swift
//  IMusic
//
//  Created by Andrii Malyk on 23.08.2022.
//

import SwiftUI

struct Library: View {
    var body: some View {
        NavigationView {
            VStack {
                //Для того щоб мати розмір екрана.geometry - розмір екрана
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button {
                            print("123")
                        } label: {
                            Image(systemName: "play.fill")
                                .frame(width: abs(geometry.size.width / 2 - 10), height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617023, alpha: 1)))
                                .background(Color.init((#colorLiteral(red: 0.9531342387, green: 0.9490900636, blue: 0.9562709928, alpha: 1))))
                                .cornerRadius(10)
                        }
                        
                        Button {
                            print("54321")
                        } label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: abs(geometry.size.width / 2 - 10), height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617023, alpha: 1)))
                                .background(Color.init((#colorLiteral(red: 0.9531342387, green: 0.9490900636, blue: 0.9562709928, alpha: 1))))
                                .cornerRadius(10)
                        }
                    }
                }.padding().frame(height: 50)
                
                //Зробимо полосу під кнопками
                Divider().padding(.leading).padding(.trailing).padding(.top)
                //Все піднімаємо наверх
                //                Spacer()
                
                //Додамо музику
                List {
                    LibraryCell()
                }
            }
            .navigationBarTitle("Library")
        }
    }
}

//Контейнер
struct LibraryCell: View {
    var body: some View {
        HStack {
            Image("Image").resizable().frame(width: 60, height: 60).cornerRadius(2)
            VStack {
                Text("Track name")
                Text("Artist name")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
