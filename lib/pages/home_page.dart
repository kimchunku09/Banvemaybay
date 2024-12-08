import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    var homePageState = _HomePageState();
    return homePageState;
  }
}

class _HomePageState extends State<HomePage> {
  //fire firestore
  final FirestoreServices firestoreService = FirestoreServices();


  //text controller
  final TextEditingController textController = TextEditingController();

 // open a dialog vox to add note
  void openNoteBox([String? docID]) {
    showDialog(context: context, builder: (context ) =>AlertDialog(
      content: TextField(
        controller: textController,
       ),
       actions: [
        //button to save
        ElevatedButton(
          onPressed: () {
            // add a new note
            //firestoreService.addNote(textController.text);
            if(docID == null) {
              firestoreService.addNote(textController.text);
            }

            // update an existing note
            else {
              firestoreService.updateNote(docID, textController.text);
            }

            // clear the text
            textController.clear();
            // close the box
            Navigator.pop(context);
          },
          child: Text("Add"),
        )
       ],
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text ("Notes")),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getNotesStream(),
      builder: (context, snapshots) {
        // if we have data, get all the docs
        if (snapshots.hasData) {
          List notesList = snapshots.data!.docs;

          //display as a list 
          return ListView.builder(
            itemCount: notesList.length,
            itemBuilder: (context, index) {
                // get each individual doc
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                // get note from list tile
                Map<String, dynamic> data = 
                document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                // display as a list tile
                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    //update button
                    IconButton(
                      onPressed: () => openNoteBox(docID,),
                      icon: const Icon(Icons.edit),// icon chỉnh sửa
                    ),

                    //delete button
                    IconButton(
                    onPressed: () => firestoreService.deleteNote(docID),
                    icon: const Icon(Icons.delete),// icon xóa
                    )

                  ],),

                  /*trailing: IconButton(
                    onPressed: () => openNoteBox(docID,),
                    icon: const Icon(Icons.settings),// icon cài đặt
                  ),*/
                );
              }, 
            );
        }

        // if there is no data return nothing
        else {
            return const Text("No note..");
          }

        },
      ),
    );
    
    
  }
}