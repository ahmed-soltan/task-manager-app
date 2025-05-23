import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management App',
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: IntroScreen(onThemeToggle: _toggleTheme),
    );
  }
}

class IntroScreen extends StatelessWidget {
  final VoidCallback onThemeToggle;

  const IntroScreen({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterScreen(onThemeToggle: onThemeToggle),
        ),
      );
    });

    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to Task Manager',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  final VoidCallback onThemeToggle;

  const RegisterScreen({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final Map<String, String> userDatabase = {};

    void _register() {
      final username = usernameController.text;
      final password = passwordController.text;

      if (username.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username and password cannot be empty'),
          ),
        );
        return;
      }

      if (userDatabase.containsKey(username)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username already exists')),
        );
        return;
      }

      userDatabase[username] = password;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration successful!')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => LoginScreen(
                onThemeToggle: onThemeToggle,
                userDatabase: userDatabase,
              ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: onThemeToggle,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text('Register')),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => LoginScreen(
                          onThemeToggle: onThemeToggle,
                          userDatabase: userDatabase,
                        ),
                  ),
                );
              },
              child: const Text('Already have an account? Login here'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final Map<String, String> userDatabase;

  const LoginScreen({
    super.key,
    required this.onThemeToggle,
    required this.userDatabase,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void _login() {
      final username = usernameController.text;
      final password = passwordController.text;

      if (userDatabase.containsKey(username) &&
          userDatabase[username] == password) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(onThemeToggle: onThemeToggle),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: onThemeToggle,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            RegisterScreen(onThemeToggle: onThemeToggle),
                  ),
                );
              },
              child: const Text('Don\'t have an account? register here'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const HomeScreen({super.key, required this.onThemeToggle});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> tasks = [];

  void _addTask(Map<String, String> task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _updateTask(int index, Map<String, String> updatedTask) {
    setState(() {
      tasks[index] = updatedTask;
    });
  }

  // Add this new method for delete confirmation
  Future<void> _showDeleteConfirmation(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  tasks.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task deleted successfully')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onThemeToggle,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => AddTaskScreen(
                        onThemeToggle: widget.onThemeToggle,
                        onTaskAdded: _addTask,
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body:
          tasks.isEmpty
              ? const Center(child: Text('No tasks added yet.'))
              : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    title: Text(task['title'] ?? ''),
                    subtitle: Text(task['description'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(task['status'] ?? ''),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => UpdateTaskScreen(
                                      onThemeToggle: widget.onThemeToggle,
                                      task: task,
                                      onTaskUpdated: _updateTask,
                                      index: index,
                                    ),
                              ),
                            );
                          },
                          color: Colors.blue,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _showDeleteConfirmation(index),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final Function(Map<String, String>) onTaskAdded;

  const AddTaskScreen({
    super.key,
    required this.onThemeToggle,
    required this.onTaskAdded,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String status = 'Pending'; // Default status

    void _addTask() {
      final title = titleController.text;
      final description = descriptionController.text;

      if (title.isEmpty || description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Title and description cannot be empty'),
          ),
        );
        return;
      }

      final task = {
        'title': title,
        'description': description,
        'status': status,
      };

      onTaskAdded(task);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task added successfully!')));

      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: onThemeToggle,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: status,
              items: const [
                DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                DropdownMenuItem(
                  value: 'In Progress',
                  child: Text('In Progress'),
                ),
                DropdownMenuItem(value: 'Completed', child: Text('Completed')),
              ],
              onChanged: (value) {
                if (value != null) {
                  status = value;
                }
              },
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _addTask, child: const Text('Add Task')),
          ],
        ),
      ),
    );
  }
}

// Add UpdateTaskScreen class after AddTaskScreen
class UpdateTaskScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final Map<String, String> task;
  final Function(int, Map<String, String>) onTaskUpdated;
  final int index;

  const UpdateTaskScreen({
    super.key,
    required this.onThemeToggle,
    required this.task,
    required this.onTaskUpdated,
    required this.index,
  });

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late String status;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task['title']);
    descriptionController = TextEditingController(
      text: widget.task['description'],
    );
    status = widget.task['status'] ?? 'Pending';
  }

  @override
  Widget build(BuildContext context) {
    void _updateTask() {
      final title = titleController.text;
      final description = descriptionController.text;

      if (title.isEmpty || description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Title and description cannot be empty'),
          ),
        );
        return;
      }

      final updatedTask = {
        'title': title,
        'description': description,
        'status': status,
      };

      widget.onTaskUpdated(widget.index, updatedTask);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated successfully!')),
      );

      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: status,
              items: const [
                DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                DropdownMenuItem(
                  value: 'In Progress',
                  child: Text('In Progress'),
                ),
                DropdownMenuItem(value: 'Completed', child: Text('Completed')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    status = value;
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTask,
              child: const Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
