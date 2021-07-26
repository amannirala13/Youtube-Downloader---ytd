import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_explode_dart/src/youtube_explode_base.dart';
import 'dart:io';

String url = '';
var yt = YoutubeExplode();
var video;
var stopwatch;

void main(List<String> arguments){
  if(arguments.isEmpty)
    {print('Enter youtube video URL: ');
     url = stdin.readLineSync()!;
    }
  else{url = arguments[0];}
  loadVideoFromURL();
}void loadVideoFromURL() {
  stopwatch = Stopwatch()..start();
  try {print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n'
      'Loading video... Please wait...\n'
      '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n');
  var videoRes = yt.videos.get(url);
  videoRes.then((value) => gotVideo(value));
  } catch(e){print(e);printEscapedTime();}
}void gotVideo(Video value) {
  video = value;
  print('-------------------Video info--------------------------');
  print('Title: ${video.title}');
  print('Description: ${video.description}');
  print('Duration: ${video.duration}');
  print('Author: ${video.author}');
  print('-------------------------------------------------------');
  try{yt.videos.streamsClient.getManifest(url).then((value) => getStreamManifest(value));} catch(e){print(e);printEscapedTime();}
}void getStreamManifest(StreamManifest value) async {
  try{var manifest = value;
    var list = manifest.muxed.sortByVideoQuality();
    var c = 0;
    print('Choice   |   Quality   |   Size (MB)');
    for(var i in list){
      print(' [$c]  --> ${i.videoResolution} | ${i.videoCodec} | ${i.size.totalMegaBytes.round()}');
      c++;
    }
    print('Enter your quality choice: ');
    var choice = int.parse(stdin.readLineSync()!);
    var streamInfo = manifest.muxed.sortByVideoQuality()[choice];
    var stream = yt.videos.streamsClient.get(streamInfo);
    var file = File('${video.title.toString().replaceAll(RegExp(r"[^\w]"), '_')}.mp4');
    var filestream = file.openWrite();
print('-----------------------------------------------------\n'
    'Downloading... Please wait...'
    '\n-----------------------------------------------------');
await stream.pipe(filestream);
print('-----------------------------------------------------\n'
    'Finished Downloading. File saved as: ${video.title.toString().replaceAll(RegExp(r"[^\w]"), '_')}.mp4\n'
    '-----------------------------------------------------');
await filestream.flush(); await filestream.close();
printEscapedTime();
}catch(e){print(e);printEscapedTime();}}
void printEscapedTime(){
  if(stopwatch.isRunning){print('Total Time escaped: ${stopwatch.elapsed}');
  stopwatch.stop();}}