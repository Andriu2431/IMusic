//
//  Library.swift
//  IMusic
//
//  Created by Andrii Malyk on 23.08.2022.
//

import SwiftUI
import URLImage

struct Library: View {
    
    //Отримуємо масив збережених треків - @State тому що ми хочемо щоб контейнер по індексу пропав з екрану
    @State var tracks = UserDefaults.standard.savedTracks()
    //Властивіть за яким буде слідкувати aлерт контроллер
    @State private var showingAlert = false
    //Інформація по конкретному треку
    @State private var track: SearchViewModel.Cell!
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    
    var body: some View {
        NavigationView {
            VStack {
                //Для того щоб мати розмір екрана.geometry - розмір екрана
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button {
                            //Передаємо перший трек з бази данних
                            self.track = self.tracks[0]
                            self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                        } label: {
                            Image(systemName: "play.fill")
                                .frame(width: abs(geometry.size.width / 2 - 10), height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617023, alpha: 1)))
                                .background(Color.init((#colorLiteral(red: 0.9531342387, green: 0.9490900636, blue: 0.9562709928, alpha: 1))))
                                .cornerRadius(10)
                        }
                        
                        Button {
                            //Оновляємо данні з бази данних
                            self.tracks = UserDefaults.standard.savedTracks()
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
                
                //Додамо музику - List це як список
                List {
                    
                    //Тут зробимо вже в списку ще один як список для того щоб можна було видалити пісню свайпом
                    ForEach(tracks) { track in
                        LibraryCell(cell: track)
                        //Жест довгого нажимання для видалення треку
                            .gesture(LongPressGesture()
                                .onEnded { _ in
                                    //Передаємо трек на який нажали
                                    self.track = track
                                    //Міняємо значення, тоді вилізе алерт
                                    self.showingAlert = true
                                }
                                     //Жест тапу по контейнеру
                                .simultaneously(with: TapGesture()
                                    .onEnded { _ in
                                        self.track = track
                                        self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                                    }))
                    }.onDelete(perform: delete) //цей метод і відповідає за видалення свайпом - не передаємо значення так як SwiftUI сам його передасть коли ми зробимо свайп
                }
            }.actionSheet(isPresented: $showingAlert, content: { // це як алерт контроллер в UIKit
                //це все появиться тоді коли $showingAlert зміниться на true
                ActionSheet(title: Text("Are you sure you want to delete this track?"),
                            buttons: [.destructive(Text("Delete"), action: { self.delete(track: self.track) }),
                                      .cancel() ])
            })
            
            .navigationBarTitle("Library")
        }
    }
    
    //Метод буде видаляти пісню
    func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        
        //але ще потрібно видалити з памяті телефону цей трек
        //Отримуємо данні треків
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            
            //Зберігаємо нові данні в UserDefaults
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    
    //Метод буде видаляти пісню
    func delete(track: SearchViewModel.Cell) {
        //Отримаємо індекст треку який отримали
        let index = tracks.firstIndex(of: track)
        
        guard let myIndex = index else {  return }
        //Видаляємо трек по індексу
        tracks.remove(at: myIndex)
        
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
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
