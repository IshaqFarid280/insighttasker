import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<String> _notes = [];
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = _prefs.getStringList('notes') ?? [];
    });
  }

  void _addNote(String note) {
    setState(() {
      _notes.add(note);
      _prefs.setStringList('notes', _notes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Notes'),
        backgroundColor: Colors.black, // Set app bar background color to black
      ),
      backgroundColor: Colors.grey[900], // Set scaffold background color to dark grey
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_notes[index]),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _notes.removeAt(index);
                      _prefs.setStringList('notes', _notes);
                    });
                  },
                  child: ListTile(
                    title: Text(
                      _notes[index],
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter note',
                      labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                    ),
                    style: TextStyle(color: Colors.white), // Set text color to white
                    onSubmitted: (value) {
                      _addNote(value);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white), // Set icon color to white
                  onPressed: () {
                    // Add the note
                    if (_notes.isNotEmpty && _notes.last.isEmpty) return; // Don't add empty notes
                    _addNote('');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
