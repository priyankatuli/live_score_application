import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_score_application/ui/entitles/football.dart';
import 'package:live_score_application/ui/widgets/football_score_card.dart';

class MatchScreenList extends StatefulWidget{
  const MatchScreenList({super.key});

  @override
  State<StatefulWidget> createState() {
     return _MatchScreenListScreen();
  }

}

class _MatchScreenListScreen extends State<MatchScreenList>{

  @override
  void initState(){
    _getFootballMatches();
    super.initState();

  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<Football> matchList =[];

  Future<void> _getFootballMatches() async{

    matchList.clear();
    final QuerySnapshot result = await firebaseFirestore.collection('football').get();

    for(QueryDocumentSnapshot doc in result.docs){
      matchList.add(Football(
          matchName: doc.id,
          team1Score: doc.get('team1')  ,
          team2Score: doc.get('team2') ,
          team1Name: doc.get('team1Name'),
          team2Name: doc.get('team2Name'),
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: const Text('Football'),
         backgroundColor: Colors.blue.shade200,

       ),
       body: StreamBuilder(

         stream: firebaseFirestore.collection('football').snapshots(),
         builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot)  {

           if(snapshot.connectionState == ConnectionState.waiting){
             return const Center(
               child: CircularProgressIndicator(),
             );
           }
           if(snapshot.hasError){
             return Center(
               child: Text(snapshot.error.toString()),
             );
           }
           if(snapshot.hasData == false){
             return const Center(
               child: Text('Empty List')
             );
           }
           matchList.clear();
           for(QueryDocumentSnapshot doc in snapshot.data?.docs ?? []){
             matchList.add(Football(
               matchName: doc.id,
               team1Score: doc.get('team1'),
               team2Score: doc.get('team2'),
               team1Name: doc.get('team1Name'),
               team2Name: doc.get('team2Name'),
             ));
           }

           return ListView.builder(itemBuilder: (context,index){
               return FootballScoreCard(football: matchList[index],);
             },
             itemCount: matchList.length,
             );
         }
       ),

     );
  }

}

