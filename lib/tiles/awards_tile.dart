import 'package:flutter/material.dart';

class AwardTile extends StatelessWidget {
  const AwardTile({super.key});

  @override
  Widget build (BuildContext context){
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: ListTile(
          onTap: (){
            modalSheet(context);
          },
          title: const Icon(Icons.star, size: 50),
        ),
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