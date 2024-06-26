import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobileapp/goals_analytics/goals_analytics_widgets.dart';
import '../my_app_state.dart';
import '../theme.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// This class builds the modal sheet for each goal and requires a title
class GoalModalSheet extends StatefulWidget {
  const GoalModalSheet({
    super.key,
    required this.title,
  });
  final String title;

  @override
  GoalModalSheetState createState() => GoalModalSheetState();
}

class GoalModalSheetState extends State<GoalModalSheet> {
  bool editable = true;
  TextEditingController taskController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // This method takes a value and context and adds a task to the goal
  void _addTaskAndUpdateList(String value, BuildContext context) {
    context.read<MyAppState>().addTotalTasks(widget.title, value);
    taskController.clear();
    FocusScope.of(context).unfocus();
  }

  Future<String> fetchLinkedInUserID(String accessToken) async {
    var url = Uri.parse('https://api.linkedin.com/v2/userinfo');
    var headers = {'Authorization': 'Bearer $accessToken'};

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var linkedinUserID = jsonResponse['sub'];
      return linkedinUserID;
    } else {
      throw Exception(
          'Failed to fetch LinkedIn user ID: ${response.statusCode} - ${response.body}');
    }
  }

  String createLinkedInPost({
    required String goalTitle,
    required String goalCategory,
    required String goalDescription,
    required List<Task> goalTasks,
  }) {
    return '''
Goal Achieved!

I'm thrilled to share that I've successfully completed my goal: $goalTitle.

Description: $goalDescription

Key Tasks Completed:
${goalTasks.map((task) => '- $task').join('\n')}

This journey has been incredibly rewarding, and I'm excited to continue pushing forward with new goals in $goalCategory.

#GoalAchieved #LinkedInGoals #PersonalGrowth #Achievement
''';
  }

  Future<void> shareOnLinkedIn(
    BuildContext context, {
    required String goalTitle,
    required String goalCategory,
    required String goalDescription,
    required List<Task> goalTasks,
  }) async {
    String? token = context.read<MyAppState>().token;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be signed in with LinkedIn to share a post.'),
        ),
      );
      return;
    }
    try {
      var userId = await fetchLinkedInUserID(token);

      const apiUrl = 'https://api.linkedin.com/v2/ugcPosts';
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Restli-Protocol-Version': '2.0.0'
      };

      final postData = {
        "author": "urn:li:person:$userId",
        "lifecycleState": "PUBLISHED",
        "specificContent": {
          "com.linkedin.ugc.ShareContent": {
            "shareCommentary": {
              "text": createLinkedInPost(
                goalTitle: goalTitle,
                goalCategory: goalCategory,
                goalDescription: goalDescription,
                goalTasks: goalTasks,
              )
            },
            "shareMediaCategory": "NONE"
          }
        },
        "visibility": {"com.linkedin.ugc.MemberNetworkVisibility": "PUBLIC"}
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(postData),
      );

      if (response.statusCode == 201) {
        showTextDialog('Success', 'Post shared successfully on LinkedIn.');
      } else {
        showTextDialog('Error',
            'Failed to share post on LinkedIn. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle generic errors
      showTextDialog(
          'Error', 'Failed to share post on LinkedIn. Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    GoalTile currentGoal = context.read<MyAppState>().goals.firstWhere(
          (goal) => goal.title == widget.title,
        );

    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 50,
        width: MediaQuery.of(context).size.width - 15,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(widget.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Theme.of(context).primaryColor)),
                    const Spacer(),
                    // This button makes the data editable
                    IconButton(
                      onPressed: () {
                        !editable
                            ? setState(() {
                                editable = true;
                              })
                            : setState(() {
                                if (_formKey.currentState!.validate()) {
                                  editable = false;
                                }
                              });
                      },
                      icon: Icon(
                        (!editable) ? Icons.edit : Icons.check,
                        size: 20,
                      ),
                    ),
                    // This button closes the modal sheet
                    IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
                // Users can pick a category using a dropdown menu
                !editable
                    ? buildRichText(context, "Category: ", currentGoal.category,
                        Theme.of(context).textTheme.bodyMedium)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text("Category",
                              style: Theme.of(context).textTheme.bodySmall),
                          DropdownButton<String>(
                            style: Theme.of(context).textTheme.labelMedium,
                            value: currentGoal.category,
                            items: items.keys
                                .toList()
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                      value: item, child: Text(item)),
                                )
                                .toList(),
                            onChanged: (item) => setState(() {
                              currentGoal.changeCategory(item ?? "");
                              context.read<MyAppState>().updatePieChart();
                            }),
                          ),
                        ],
                      ),
                // Deadline of goal
                (!editable)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: buildRichText(
                            context,
                            "Deadline: ",
                            currentGoal.date,
                            Theme.of(context).textTheme.bodyMedium),
                      )
                    : (!editable)
                        ? buildRichText(context, "Deadline", currentGoal.date,
                            Theme.of(context).textTheme.bodySmall)
                        : TextFormField(
                            // Has to have a value to continue
                            validator: (value) => noEmptyField(value),
                            controller: TextEditingController(
                              text: currentGoal.date,
                            ),
                            readOnly: true, // Prevents manual editing
                            decoration: underlineInputDecoration(
                                context, "ex. 4/24/2024", "Deadline"),
                            // Date picker
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 365 * 25)),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  String date = formatDate(pickedDate);
                                  currentGoal.changeDate(date);
                                });
                              }
                            }),
                // The description of goal
                (!editable)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: (currentGoal.description.isEmpty)
                            ? Text("No description",
                                style: Theme.of(context).textTheme.bodyMedium)
                            : buildRichText(
                                context,
                                "Description:\n",
                                currentGoal.description,
                                Theme.of(context).textTheme.bodyMedium,
                              ),
                      )
                    : TextFormField(
                        minLines: 1,
                        maxLines: 4,
                        initialValue: currentGoal.description,
                        onChanged: (value) {
                          setState(
                            () => currentGoal.changeDescription(value),
                          );
                        },
                        decoration: underlineInputDecoration(
                            context, "ex. In this I...", "Description"),
                      ),
                const SizedBox(height: 100),
                Text("Tasks",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Theme.of(context).primaryColor)),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 150,
                      // Input field to add tasks
                      child: TextField(
                        controller: taskController,
                        decoration: underlineInputDecoration(
                          alwaysFloat: false,
                          context,
                          'ex. Complete draft of business report',
                          'Enter Task',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                      child: CircleAvatar(
                        maxRadius: 17.5,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: IconButton(
                          onPressed: () {
                            _addTaskAndUpdateList(taskController.text, context);
                          },
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.background,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // This displays list of all the tasks with a checkbox
                Expanded(
                  child: Consumer<MyAppState>(
                    builder: (context, myAppState, _) {
                      final goal = myAppState.goals
                          .firstWhere((goal) => goal.title == widget.title);
                      final tasks = goal.tasks;

                      return ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return CheckboxListTile(
                              title: Text(task.task),
                              value: task.isChecked,
                              onChanged: (value) {
                                setState(() {
                                  task.isChecked = value!;
                                  if (value) {
                                    myAppState.addCompletedTasks(widget.title);
                                  } else {
                                    myAppState.uncheck(widget.title);
                                  }
                                });
                              },
                              secondary: IconButton(
                                  icon: const Icon(Icons.cancel,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      myAppState.deleteTask(
                                          widget.title, index);
                                    });
                                  }));
                        },
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Column(
                    children: [
                      const Text('Goal Complete?'),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                                onPressed: () => (editable ||
                                        currentGoal.category == 'Other')
                                    ? Future.delayed(
                                        Duration.zero,
                                        () => showTextDialog(
                                          'Error',
                                          'Please save the goal and select a valid category before continuing.',
                                        ),
                                      )
                                    : addXpDialog(context),
                                child: Text(
                                  'Add to Profile as Experience',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                )),
                          ),
                          const SizedBox(width: 20),
                          CustomImageButton(
                            image: const AssetImage('assets/share.png'),
                            onTap: () {
                              shareOnLinkedIn(
                                context,
                                goalTitle: widget.title,
                                goalCategory: currentGoal.category,
                                goalDescription: currentGoal.description,
                                goalTasks: currentGoal.tasks,
                              );
                            },
                            height: 35,
                            width: 150,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRichText(
      BuildContext context, String label, String value, TextStyle? style) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: style?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value,
            style: style,
          ),
        ],
      ),
    );
  }

  void addXpDialog(BuildContext context) {
    GoalTile currentGoal = context.read<MyAppState>().goals.firstWhere(
          (goal) => goal.title == widget.title,
        );
    final dialogFormKey = GlobalKey<FormState>();
    String title = widget.title;
    String startDate = currentGoal.createdDate;
    String endDate = currentGoal.date;
    String description = currentGoal.description;
    String other = "";
    String? otherField = items[currentGoal.category];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        setState(() {});
        return AlertDialog(
          title: const Text('Add New Experience'),
          content: SingleChildScrollView(
            child: Form(
              key: dialogFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: title,
                    decoration: underlineInputDecoration(context, '', 'Title'),
                    validator: (value) => noEmptyField(value),
                    onChanged: (value) {
                      setState(() {
                        title = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration:
                        underlineInputDecoration(context, '', 'Start Date'),
                    readOnly: true,
                    controller: TextEditingController(text: startDate),
                    validator: (value) => validateStartDate(value, endDate),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 25)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          startDate = formatDate(pickedDate);
                        });
                      }
                    },
                  ),
                  TextFormField(
                    decoration:
                        underlineInputDecoration(context, '', 'End Date'),
                    readOnly: true,
                    controller: TextEditingController(text: endDate),
                    validator: (value) => noEmptyField(value),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 25)),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365 * 25)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          endDate = formatDate(pickedDate);
                        });
                      }
                    },
                  ),
                  TextFormField(
                    initialValue: description,
                    decoration:
                        underlineInputDecoration(context, '', 'Description'),
                    minLines: 1,
                    maxLines: 4,
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                  ),
                  (otherField == null)
                      ? Container()
                      : TextFormField(
                          decoration:
                              underlineInputDecoration(context, '', otherField),
                          validator: (value) =>
                              (otherField == 'Score' || otherField == 'Hours')
                                  ? nonNegativeValue(value)
                                  : (otherField == "Issuer")
                                      ? null
                                      : noEmptyField(value),
                          onChanged: (value) {
                            setState(() {
                              other = value;
                            });
                          },
                        ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (dialogFormKey.currentState!.validate()) {
                  context.read<MyAppState>().addXpFromGoal(
                        title,
                        currentGoal.category,
                        startDate,
                        endDate,
                        other,
                        description,
                      );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      }),
    );
  }
}

// This class defines a task that requires a task name and if it is checked yet
class Task {
  Task({required this.task, required this.isChecked});
  final String task;
  bool isChecked = false;
}
