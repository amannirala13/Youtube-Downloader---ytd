import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_explode_dart/src/youtube_explode_base.dart';
import 'dart:io';

String url;
var yt = YoutubeExplode();
Video video;

void main(List<String> arguments){
  if(arguments.isEmpty){print('Enter youtube video URL: ');
    url = stdin.readLineSync();}else{url = arguments[0];}loadVideoFromURL();
}
void loadVideoFromURL() {
  try {print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n'
        'Loading video... Please wait...\n'
        '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n');
    var videoRes = yt.videos.get(url);
    videoRes.then((value) => gotVideo(value));
  } catch(e){print(e);}
}
void gotVideo(Video value) {
  video = value;
  print('-------------------Video info--------------------------');
  print('Title: ${video.title}');
  print('Description: ${video.description}');
  print('Duration: ${video.duration}');
  print('Author: ${video.author}');
  print('-------------------Video info--------------------------');
  try{yt.videos.streamsClient.getManifest(url).then((value) => getStreamManifest(value));} catch(e){print(e);}
}
void getStreamManifest(StreamManifest value) async {
  try{var manifest = value;
  var streamInfo = manifest.muxed.sortByVideoQuality().last;
  if(streamInfo != null){var stream = yt.videos.streamsClient.get(streamInfo);
    var file = File('${video.title}.mp4');
    var filestream = file.openWrite();
    print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n'
        'Downloading... Please wait...'
        '\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    await stream.pipe(filestream);
    print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n'
        'Finished Downloading. File saved as: ${video.title}.mp4\n'
        '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');}}catch(e){print(e);}}