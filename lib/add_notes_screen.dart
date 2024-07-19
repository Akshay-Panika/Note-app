import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'note_model.dart';

class AddNotesScreen extends StatefulWidget {
  final NoteModel? note;
  const AddNotesScreen({super.key, this.note,});

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}
class _AddNotesScreenState extends State<AddNotesScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();


  // Update function
  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      subtitleController.text = widget.note!.subtitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "Add Note" : "Update Note",),
        titleTextStyle: const TextStyle(fontSize:16 , color: Colors.black, fontWeight: FontWeight.w500),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
        
                // Title text
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "Title",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
        
                // Subtitle text
                TextFormField(
                  maxLines: 6,
                  controller: subtitleController,
                  decoration: const InputDecoration(
                    hintText: "Subtitle",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a subtitle';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
        
        
                // Add & Update button
                Align(alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      DateTime now = DateTime.now();
                      int year = now.year;
                      int month = now.month;
                      int day = now.day;
                      if (_formKey.currentState?.validate() ?? false) {
                        final note = NoteModel(
                          id: widget.note?.id, // Use existing ID for updates
                          title: titleController.text,
                          subtitle: subtitleController.text,
                          //date: widget.note?.date ?? DateTime.now().toIso8601String(), // Use existing date or current date
                          date: widget.note?.date ?? "$day/$month/$year", // Use existing date or current date
                        );
        
                        if (widget.note == null) {
                          DBHelper.insertNote(note).then((_) {
                            Navigator.pop(context); // Return to the previous screen
                          }).catchError((error) {
                            // Handle error
                            print("Error: $error");
                          });
                        } else {
                          DBHelper.updateNote(note).then((_) {
                            Navigator.pop(context); // Return to the previous screen
                          }).catchError((error) {
                            // Handle error
                            print("Error: $error");
                          });
                        }
                      }
                    },
                    child: Text(widget.note == null ? "Save Note" : "Update Note", style: const TextStyle(color: Colors.black),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
