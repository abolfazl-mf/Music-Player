abstract class PlayListRepository{
  Future<List<Map<String,String>>> fetchMyPlayList();
}
class MyPlayList extends PlayListRepository{
  @override
  Future<List<Map<String, String>>> fetchMyPlayList() async{

    const song1 = 'https://dl.musicdel.ir/Music/1400/05/ckay_love_nwantiti%20128.mp3';
    const song2 = 'https://irsv.upmusics.com/99/Behnam%20Bani%20-%20Khoshhalam%20(320).mp3';
    const song3 = 'https://irsv.upmusics.com/99/Mohsen%20Ebrahimzadeh%20-%20Doone%20Doone%202(320).mp3';
    const song4 = 'https://dl.naslemusic.com/music/1395/04/Sina%20Hejazi%20-%20Zaar%20Nazan%20(128).mp3';
    return [
      {
        'id':'0',
        'title':'Love nwantiti',
        'artist':'Ckay',
        'artUri':'https://muziran.ir/wp-content/uploads/2021/10/artworks-ytMRt5RDcSPIuzvV-SGASRQ-t500x500.jpg',
        'url':song1,

      },
      {
        'id':'1',
        'title':'Koshhalam',
        'artist':'Behnam Bani',
        'artUri':'http://tabamusic.com/wp-content/uploads/2020/10/Behnam-Bani-Khoshhalam.jpg',
        'url':song2,
      },
      {
        'id':'2',
        'title':'Donne Donne 2',
        'artist':'Mohsen Ebrahimzadeh',
        'artUri':'http://tabamusic.com/wp-content/uploads/2020/06/Mohsen-Ebrahimzadeh-Doneh-Doneh-2.jpg',
        'url':song3,

      },
      {
        'id':'3',
        'title':'Zaar Nazan',
        'artist':'Sina Hejazi',
        'artUri':'https://naslemusic.com/file/2016/07/%D8%AF%D8%A7%D9%86%D9%84%D9%88%D8%AF-%D8%A2%D9%87%D9%86%DA%AF-%D8%B3%DB%8C%D9%86%D8%A7-%D8%AD%D8%AC%D8%A7%D8%B2%DB%8C-%D8%B2%D8%A7%D8%B1-%D9%86%D8%B2%D9%86.jpg',
        'url':song4,
      }
    ];
  }

}