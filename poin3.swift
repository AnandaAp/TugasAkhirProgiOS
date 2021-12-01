import Foundation
import SQLite3

protocol PlaylistAbility {
    func playMusics()
    func shuffleMusic()
    func addFavourite()
    func addToPlaylist()
}

class Playlist: PlaylistAbility {
    var id: String
    var name: String
    var quantity: Int
    var creator: String
    var listOfSong: [SongDB]

    init(id: String,
        name: String, 
        quantity: Int, 
        creator: String,
        listOfSong: [SongDB]){
            self.id = id
            self.name = name
            self.quantity = quantity
            self.creator = creator
            self.listOfSong = listOfSong

    func playMusics(){
        shuffleMusic()
    }
    func shuffleMusic(){
        println("Play Songs")
        println("Songs have been shuffled")
    }
    func addFavourite(song: Song){
        // song.addFavourite()
        println("Add to your Favourite List")
    }
    func addToPlaylist(song: Song){
        // song.addToPlaylist()
        println("Add to your Playlist")
    }
}

//model for store Artist JSON from internet
struct Artist: Decodable{
  let id: String
  let name: String
  let listOfAlbum: [Album]
}

//model for store Song JSON from internet
struct Song: Decodable{
  let id: String
  let title: String
  let duration: Int
  let artist: String
  let album: String
  let genre: String
}

//model for store Album JSON from internet
struct Album: Decodable{
  var id: String
  var title: String
  var artist: String
  var cover: String
  var listOfSong: [Song]
}

//model for store Artists Data from DB
class ArtistDB {
  let id: String
  let name: String
  let listOfAlbum: [Album]

  init(id : String,name: String, listOfAlbum[ALbum]){
    self.id = id
    self.name = name
    self.listOfAlbum = listOfAlbum
  }
}

//model for store Albums Data from DB
class AlbumDB{
  var id: String
  var title: String
  var artist: String
  var cover: String
  var listOfSong: [Song]

  init(id: String, title: String, artist: String, cover: String, listOfSong: [Song]){
    self.id = idself
    self.title = title
    self.artist = artist
    self.cover = cover
    self.listOfSong = listOfSong
  }
}

//model for store Songs Data from DB
vlass SongDB{
  var id: String
  var title: String
  var duration: Int
  var artist: String
  var album: String
  var genre: String

  init(id : String, title: String, dutarion: Int, artist: String, album : String, gender: String){
    self.id = id
    self.title = title
    self.duration = duration
    self.artist = artist
    self.album = album
    self.genre = genre
  }
}

//class for network layer
class NetworkManager{
  func fetchData(completion: @escaping(_ artist: [Artist]) -> Void){
    guard let url= URL(string: "https://raw.githubusercontent.com/AnandaAp/TugasAkhirProgiOS/main/artis.json"){
      return
    }

    URLSession.shared.dataTask(with: url){ data, response, error in
      println("Data",data)
      println("Response",response)
      // let jsonData = data.data(using: .utf8)!
      if let jsonString = String(data: data!, encoding: .utf8) {
        print(jsonString)
      }
      let artist: [Artist] = try! JSONDecoder().decode([Artist].self, from : data!)
      completion(artist)
    }
    .resume()
  }
}

//class for DB layer
class DBHelper{
  var db : OpaquePointer?
  var path : String
  init(path: String) {
    self.path = path
    self.db = createDB()
    self.createTable()
  }
    
  func createDB() -> OpaquePointer? {
    let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        
    var db : OpaquePointer? = nil
        
    if sqlite3_open(filePath.path, &db) != SQLITE_OK {
      print("There is error in creating DB")
      return nil
    }
    else {
      print("Database has been created with path \(path)")
      return db
    }
  }

  func createTable(query: String)  {
    var statement : OpaquePointer? = nil
    if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
      if sqlite3_step(statement) == SQLITE_DONE {
        print("Table creation success")
      }
      else {
        print("Table creation fail")
      }
    } 
    else {
      print("Prepration fail")
    }
  }
  func insert(query: String) {
    var statement : OpaquePointer? = nil    
    var isEmpty = false 
    if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
      if sqlite3_step(statement) == SQLITE_DONE {
        print("Data inserted success")
      }
      else {
        print("Data is not inserted in table")
      }
    } 
    else {
      print("Query is not as per requirement")
    }      
  }
    
    
  func read(query: String) -> [ArtistDB] {
    var mainArtist = [ArtistDB]
    var mainAlbum = [AlbumDB]
    var mainSong = [SongDB]
    var statement : OpaquePointer? = nil

    if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
      while sqlite3_step(statement) == SQLITE_ROW {
        let artistID = String(describing: String(cString: sqlite3_column_text(statement, 0)))
        let artistName = String(describing: String(cString: sqlite3_column_text(statement, 1)))
        let listOfAlbumID = String(describing: String(cString: sqlite3_column_text(statement, 2)))
        let query2 = "SELECT album_id FROM listOfAlbum where id = \(listOfAlbumID);"
        if sqlite3_prepare_v2(db, 
          query2, 
          -1, 
          &statement, 
          nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
              let album_ID =  String(describing: String(cString: sqlite3_column_text(statement, 0)))
            }
          let query3 = "SELECT * FROM Album where id = \(album_ID);"
          if sqlite3_prepare_v2(db, query3, 
            -1, 
            &statement, 
            nil) == SQLITE_OK{
              while sqlite3_step(statement) == SQLITE_ROW{
                let albumID = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                let albumTitle = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let cover = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                let albumArtist = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                let listOfSongID = String(describing: String(cString: sqlite3_column_text(statement, 4)))
                let query4 = "SELECT song_id FROM listOfSong where id = \(listOfSongID);"
                if sqlite3_prepare_v2(db, query4, 
                  -1, 
                  &statement, 
                  nil) == SQLITE_OK {
                    while sqlite3_step(statement) == SQLITE_ROW{
                      let song_ID = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                      let query5 = "SELECT * FROM song WHERE id = \(song_ID)"
                      if sqlite3_prepare_v2(db, query5, 
                        -1, 
                        &statement, 
                        nil) == SQLITE_OK{
                          while sqlite3_step(statement) == SQLITE_ROW{
                            let songID = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                            let songTitle = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                            let duration = Int(sqlite3_column_int(statement, 2))
                            let singer = String(describing: String(cString: sqlite3_column_text(statement, 4))) 
                            let albumName = String(describing: String(cString: sqlite3_column_text(statement, 5)))
                            let songGenre = String(describing: String(cString: sqlite3_column_text(statement, 6)))
                            let song = SongDB(songID,songTitle,duration,singer,albumName,songGenre)
                            mainSong.append(song)
                            let album = AlbumDB(albumID, albumTitle,  albumArtist,cover,mainSong)
                            mainAlbum.append(album)
                            let artist = ArtistDB(artistID,artistName,mainAlbum)
                            mainArtist.append(artist)
                          }
                        }
                    }
                }
              }
            }
        }
      }
    }
    return mainArtist
  }
  func delete(table: String,id : Int) {
    let query = "DELETE FROM \(table) where id = \(id)"
    var statement : OpaquePointer? = nil
    if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
      if sqlite3_step(statement) == SQLITE_DONE {
        print("Data delete success")
      }
      else {
        print("Data is not deleted in table")
      }
    }
  }
  func update(query: String) {
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data updated success")
            }else {
                print("Data is not updated in table")
            }
        }
    }
}