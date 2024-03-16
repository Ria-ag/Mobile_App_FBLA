import 'package:flutter/material.dart';

class ClubTile extends StatelessWidget {
  const ClubTile({super.key});

  @override
  Widget build (BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: (){
          modalSheet(context);
        },
        title: const Text("Club name"),
      ),
    );
  }
}

void modalSheet(context){
  showModalBottomSheet(context: context, builder: (BuildContext bc) {  
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
                  child:const Icon(Icons.cancel, color: Colors.red, size: 20,), 
                  onPressed: (){
                    Navigator.of(context).pop();
                  }
                ),
              ],
            ),
          ],
        ),
      )
    );
  });
}