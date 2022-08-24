//
//  Library.swift
//  IMusic
//
//  Created by Andrii Malyk on 23.08.2022.
//

import SwiftUI
import URLImage

struct Library: View {
    
    //Отримуємо масив збережених треків
    var tracks = UserDefaults.standard.savedTracks()
    
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
                List(tracks) { track in
                    LibraryCell(cell: track)
                }
            }
            .navigationBarTitle("Library")
        }
    }
}

//Контейнер
struct LibraryCell: View {
    
    //Один трек 
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {
            URLImage(URL(string: cell.iconUrlString ?? "")!) { image in
                image
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(2)
            }
            VStack(alignment: .leading) {
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
