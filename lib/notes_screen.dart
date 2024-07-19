// import 'package:flutter/material.dart';
// import 'add_notes_screen.dart';
// import 'db_helper.dart'; // Import DBHelper
// import 'note_model.dart'; // Import NoteModel
//
// class NotesScreen extends StatefulWidget {
//   const NotesScreen({super.key});
//
//   @override
//   State<NotesScreen> createState() => _NotesScreenState();
// }
//
// class _NotesScreenState extends State<NotesScreen> {
//   late Future<List<NoteModel>> _notesFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _notesFuture = DBHelper.getNotes();
//   }
//
//   // Function to delete a note and refresh the list
//   void _deleteNote(int id) async {
//     await DBHelper.deleteNote(id);
//     setState(() {
//       _notesFuture = DBHelper.getNotes(); // Refresh the list
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Notes App"),
//         titleTextStyle: const TextStyle(fontSize:20 , color: Colors.black, fontWeight: FontWeight.w500),
//         actions: [
//           IconButton(onPressed: (){}, icon: const Icon(Icons.search,size: 30,))
//         ],
//       ),
//       body: FutureBuilder<List<NoteModel>>(
//         future: _notesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No notes available"));
//           }
//
//           final notes = snapshot.data!;
//
//           return Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 1.5/1
//               ),
//               itemCount: notes.length,
//               itemBuilder: (context, index) {
//                 final note = notes[index];
//                 return Card(
//                   child: Stack(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => UpdateNoteScreen(note: note),
//                             ),
//                           ).then((_) {
//                             // Refresh notes after updating
//                             setState(() {
//                               _notesFuture = DBHelper.getNotes();
//                             });
//                           });
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(note.title, style: const TextStyle(fontWeight: FontWeight.w500),),
//                               Text(note.subtitle),
//                               const SizedBox(height: 5),
//                               Align(
//                                   alignment: Alignment.bottomRight,
//                                   child: Text(note.date, style: TextStyle(color: Colors.grey),)),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       // Delete button
//                       Positioned(
//                         right: 0,
//                         top: 0,
//                         child: IconButton(
//                           icon: const Icon(Icons.delete),
//                           onPressed: () {
//                             _deleteNote(note.id!); // Delete the note
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const AddNotesScreen(),
//             ),
//           ).then((_) {
//             // Refresh notes after adding a new one
//             setState(() {
//               _notesFuture = DBHelper.getNotes();
//             });
//           });
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
//
// class UpdateNoteScreen extends StatelessWidget {
//   final NoteModel note;
//
//   const UpdateNoteScreen({required this.note, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AddNotesScreen(note: note);
//   }
// }

import 'package:flutter/material.dart';
import 'add_notes_screen.dart';
import 'db_helper.dart'; // Import DBHelper
import 'note_model.dart'; // Import NoteModel

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late Future<List<NoteModel>> _notesFuture;
  final TextEditingController _searchController = TextEditingController();
  List<NoteModel> _filteredNotes = [];
  List<NoteModel> _allNotes = [];

  @override
  void initState() {
    super.initState();
    _notesFuture = DBHelper.getNotes();
    _searchController.addListener(_filterNotes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterNotes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNotes = _allNotes.where((note) {
        return note.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Function to delete a note and refresh the list
  void _deleteNote(int id) async {
    await DBHelper.deleteNote(id);
    setState(() {
      _notesFuture = DBHelper.getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Card(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search notes...',
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),


            const SizedBox(height: 10,),
            Expanded(
              child: FutureBuilder<List<NoteModel>>(
                future: _notesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No notes available"));
                  }

                  _allNotes = snapshot.data!;
                  _filteredNotes = _allNotes.where((note) {
                    final query = _searchController.text.toLowerCase();
                    return note.title.toLowerCase().contains(query);
                  }).toList();

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5 / 1,
                    ),
                    itemCount: _filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = _filteredNotes[index];
                      return Card(
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateNoteScreen(note: note),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    _notesFuture = DBHelper.getNotes();
                                  });
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(note.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                                    Text(note.subtitle),
                                    const SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(note.date, style: const TextStyle(color: Colors.grey)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Delete button
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteNote(note.id!); // Delete the note
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNotesScreen(),
            ),
          ).then((_) {
            setState(() {
              _notesFuture = DBHelper.getNotes();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UpdateNoteScreen extends StatelessWidget {
  final NoteModel note;

  const UpdateNoteScreen({required this.note, super.key});

  @override
  Widget build(BuildContext context) {
    return AddNotesScreen(note: note);
  }
}
