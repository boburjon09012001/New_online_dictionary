import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:online_data_dictionary/services/services.dart';
import '../model/model.dart';

class MyDictionaryScreen extends StatefulWidget {
  const MyDictionaryScreen({Key? key}) : super(key: key);

  @override
  State<MyDictionaryScreen> createState() => _MyDictionaryScreenState();
}

class _MyDictionaryScreenState extends State<MyDictionaryScreen> {
  TextEditingController controller = TextEditingController();
  String? data;
  AudioPlayer? audioPlayer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      audioPlayer = AudioPlayer();
    });
  }

  void playAudio(String music){
    audioPlayer!.stop();
    audioPlayer!.play(music);
  }
  @override
  void dispose() {
    super.dispose();
    audioPlayer!.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Dictionary", style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w700),),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding:const EdgeInsets.all(10.0),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    padding:const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(),
                    ),
                    child: Row(
                      children: [Expanded(child: TextFormField(
                        controller: controller,
                        decoration:const InputDecoration(
                          label: Text( "Search word",),
                          border: InputBorder.none,
                        ),
                      )),
                        IconButton(onPressed: (){
                          if(controller.text.isEmpty){
                            setState(() {

                            });
                          }
                        }, icon:const Icon(Icons.search)),
                      ],


                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                 controller.text.isEmpty
                     ?  const SizedBox(child: Text("Search for something"))
                     : FutureBuilder(
                      future: DictionaryService()
                          .getMeaning(word: controller.text),
                      builder: (context, AsyncSnapshot<List<DictionaryModel>> snapshot ){
                        print("Data $snapshot");
                        if(snapshot.hasData){
                         return Expanded(
                           child: ListView(
                             scrollDirection: Axis.vertical,
                            children: List.generate(snapshot.data!.length,
                                   (index)  {
                                 final data = snapshot.data![index];
                                 return Container(
                                   child: Column(
                                     children: [
                                       Container(
                                         height : MediaQuery.of(context).size.height * 0.1,
                                         child:
                                           ListTile(
                                             title: Text(data.word!),
                                              subtitle: Text(data.phonetics![index].text!),

                                             trailing: IconButton(
                                               onPressed:(){
                                                 final path = data.phonetics![index].audio;
                                                 playAudio(path!);
                                                 final path2 = path.substring(2, path.length);
                                                 print(path2);
                                                 playAudio("https://$path2");
                                               },
                                               icon:const Icon(Icons.volume_up),
                                             ),

                                           ),
                                       ),
                                       Container(
                                         height : MediaQuery.of(context).size.height * 0.05,
                                         child:
                                         ListTile(
                                            title: Text( data.meanings![index].definitions![index].definition! ),
                                            subtitle: Text(data.meanings![0].partOfSpeech!),
                                         ),
                                       ),
                                     ],
                                   ),
                                 );
                               }),
                           ),
                         );
                        }
                        else if(snapshot.hasError){
                          return Text(snapshot.error.toString());
                        }
                        else {
                          return const CircularProgressIndicator();
                        }
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  // List<Container> listCategory(index, snapshot){
  //  
  // }
}
