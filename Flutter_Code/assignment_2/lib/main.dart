import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Diary',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ContactDiaryPage(),
    );
  }
}

// Contact model class
class Contact {
  final String name;
  final String mobileNumber;
  final String emailAddress;

  Contact({
    required this.name,
    required this.mobileNumber,
    required this.emailAddress,
  });
}

// Stateful widget for Contact Diary
class ContactDiaryPage extends StatefulWidget {
  const ContactDiaryPage({super.key});

  @override
  State<ContactDiaryPage> createState() => _ContactDiaryPageState();
}

class _ContactDiaryPageState extends State<ContactDiaryPage> {
  final List<Contact> _contacts = [];
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _addContact() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _contacts.add(
          Contact(
            name: _nameController.text,
            mobileNumber: _mobileController.text,
            emailAddress: _emailController.text,
          ),
        );
      });

      // Clear the form
      _nameController.clear();
      _mobileController.clear();
      _emailController.clear();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact added successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contact deleted!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Contact Diary'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Add Contact Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _mobileController,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _addContact,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Contact'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(thickness: 2),
          // Contact List
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              'Contacts (${_contacts.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: _contacts.isEmpty
                ? const Center(
                    child: Text(
                      'No contacts yet!\nAdd your first contact above.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _contacts.length,
                    itemBuilder: (context, index) {
                      final contact = _contacts[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Text(
                              contact.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            contact.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(contact.mobileNumber),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.email,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      contact.emailAddress,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteContact(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
