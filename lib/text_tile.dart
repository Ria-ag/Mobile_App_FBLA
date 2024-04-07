import 'package:flutter/material.dart';

class TextTile extends StatefulWidget {
  const TextTile(
      {super.key, required this.name, required this.title, this.trailing = ""});

  final String name;
  final String trailing;
  final String title;

  @override
  State<TextTile> createState() => _TextTileState();
}

class _TextTileState extends State<TextTile> {
  String name = "name";
  String date = "4/6/24";
  String description = "In this I...";
  bool editable = false;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext bc) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text("More Information"),
                                const Spacer(),
                                TextButton(
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                }),
                                TextButton(
                                  child: Icon( 
                                    (!editable) ? Icons.edit : Icons.check,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    !editable ? 
                                    setState(() {editable = true;}) :
                                    setState(() {editable = false;});
                                }),           
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: !editable ? Text(name) : TextFormField(
                                    initialValue: name,
                                    onFieldSubmitted: (value) {
                                      setState(() {editable = false; name = value;});
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "ex. FBLA",
                                      labelText: "Name",
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: !editable ? Text(date) : InputDatePickerFormField(
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2025),
                                errorInvalidText: "invalid date",
                                fieldLabelText: "start date",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: !editable ? Text(date) : InputDatePickerFormField(
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2025),
                                errorInvalidText: "invalid date",
                                fieldLabelText: "end date",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: !editable ? Text(description, style: const TextStyle(fontSize: 15,)) : TextFormField(
                                    initialValue: description,
                                    onFieldSubmitted: (value) {
                                      setState(() {editable = false; description = value;});
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "ex. In this I...",
                                      labelText: "Description",
                                    ),
                              ),
                            ),
                          ],
                        ),
                     ));
                });
              },
              title: Text(widget.name),
            ),
          ),
        ],
      ),
    );
  }
}
