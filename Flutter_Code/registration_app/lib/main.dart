import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const RegistrationApp());
}

class RegistrationApp extends StatelessWidget {
  const RegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: PersonalInfoScreen(registrationData: {}),
    );
  }
}

// ==================== PERSONAL INFO SCREEN ====================
class PersonalInfoScreen extends StatefulWidget {
  final Map<String, dynamic> registrationData;

  const PersonalInfoScreen({super.key, required this.registrationData});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  String? _nameError;
  String? _emailError;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.registrationData['name'] ?? '',
    );
    _emailController = TextEditingController(
      text: widget.registrationData['email'] ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.registrationData['phone'] ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    setState(() {
      _nameError = null;
      _emailError = null;
      _phoneError = null;
    });

    bool isValid = true;

    // Validate name
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _nameError = 'Name is required';
      });
      isValid = false;
    } else if (_nameController.text.trim().length < 2) {
      setState(() {
        _nameError = 'Name must be at least 2 characters';
      });
      isValid = false;
    }

    // Validate email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
      isValid = false;
    } else if (!emailRegex.hasMatch(_emailController.text.trim())) {
      setState(() {
        _emailError = 'Enter a valid email address';
      });
      isValid = false;
    }

    // Validate phone
    final phoneRegex = RegExp(r'^\d{10}$');
    if (_phoneController.text.trim().isEmpty) {
      setState(() {
        _phoneError = 'Phone number is required';
      });
      isValid = false;
    } else if (!phoneRegex.hasMatch(_phoneController.text.trim())) {
      setState(() {
        _phoneError = 'Enter a valid 10-digit phone number';
      });
      isValid = false;
    }

    return isValid;
  }

  void _proceedToNext() {
    if (_validateFields()) {
      final updatedData = Map<String, dynamic>.from(widget.registrationData);
      updatedData['name'] = _nameController.text.trim();
      updatedData['email'] = _emailController.text.trim();
      updatedData['phone'] = _phoneController.text.trim();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddressScreen(registrationData: updatedData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Step 1 of 3',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tell us about yourself',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              
              // Name Field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                  errorText: _nameError,
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),

              // Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                  errorText: _emailError,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Phone Field
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.phone),
                  errorText: _phoneError,
                  hintText: '1234567890',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _proceedToNext,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Next: Address',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== ADDRESS SCREEN ====================
class AddressScreen extends StatefulWidget {
  final Map<String, dynamic> registrationData;

  const AddressScreen({super.key, required this.registrationData});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;

  String? _streetError;
  String? _cityError;
  String? _stateError;
  String? _zipError;

  @override
  void initState() {
    super.initState();
    _streetController = TextEditingController(
      text: widget.registrationData['street'] ?? '',
    );
    _cityController = TextEditingController(
      text: widget.registrationData['city'] ?? '',
    );
    _stateController = TextEditingController(
      text: widget.registrationData['state'] ?? '',
    );
    _zipController = TextEditingController(
      text: widget.registrationData['zip'] ?? '',
    );
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    setState(() {
      _streetError = null;
      _cityError = null;
      _stateError = null;
      _zipError = null;
    });

    bool isValid = true;

    // Validate street
    if (_streetController.text.trim().isEmpty) {
      setState(() {
        _streetError = 'Street address is required';
      });
      isValid = false;
    }

    // Validate city
    if (_cityController.text.trim().isEmpty) {
      setState(() {
        _cityError = 'City is required';
      });
      isValid = false;
    }

    // Validate state
    if (_stateController.text.trim().isEmpty) {
      setState(() {
        _stateError = 'State is required';
      });
      isValid = false;
    }

    // Validate zip
    final zipRegex = RegExp(r'^\d{5}$');
    if (_zipController.text.trim().isEmpty) {
      setState(() {
        _zipError = 'ZIP code is required';
      });
      isValid = false;
    } else if (!zipRegex.hasMatch(_zipController.text.trim())) {
      setState(() {
        _zipError = 'Enter a valid 5-digit ZIP code';
      });
      isValid = false;
    }

    return isValid;
  }

  void _proceedToNext() {
    if (_validateFields()) {
      final updatedData = Map<String, dynamic>.from(widget.registrationData);
      updatedData['street'] = _streetController.text.trim();
      updatedData['city'] = _cityController.text.trim();
      updatedData['state'] = _stateController.text.trim();
      updatedData['zip'] = _zipController.text.trim();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreferencesScreen(registrationData: updatedData),
        ),
      );
    }
  }

  void _goBack() {
    final updatedData = Map<String, dynamic>.from(widget.registrationData);
    updatedData['street'] = _streetController.text.trim();
    updatedData['city'] = _cityController.text.trim();
    updatedData['state'] = _stateController.text.trim();
    updatedData['zip'] = _zipController.text.trim();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoScreen(registrationData: updatedData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Step 2 of 3',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Text(
                'Where do you live?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              
              // Street Field
              TextField(
                controller: _streetController,
                decoration: InputDecoration(
                  labelText: 'Street Address',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.home),
                  errorText: _streetError,
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),

              // City Field
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_city),
                  errorText: _cityError,
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),

              // State Field
              TextField(
                controller: _stateController,
                decoration: InputDecoration(
                  labelText: 'State',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.map),
                  errorText: _stateError,
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),

              // ZIP Field
              TextField(
                controller: _zipController,
                decoration: InputDecoration(
                  labelText: 'ZIP Code',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.pin_drop),
                  errorText: _zipError,
                  hintText: '12345',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ],
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _proceedToNext,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Next: Preferences',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== PREFERENCES SCREEN ====================
class PreferencesScreen extends StatefulWidget {
  final Map<String, dynamic> registrationData;

  const PreferencesScreen({super.key, required this.registrationData});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  late bool _newsletter;
  late String _language;
  late double _age;

  String? _ageError;

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
    'Arabic',
    'Portuguese',
  ];

  @override
  void initState() {
    super.initState();
    _newsletter = widget.registrationData['newsletter'] ?? false;
    _language = widget.registrationData['language'] ?? 'English';
    _age = widget.registrationData['age'] ?? 18.0;
  }

  bool _validateFields() {
    setState(() {
      _ageError = null;
    });

    bool isValid = true;

    // Validate age (must be 18 or older)
    if (_age < 18) {
      setState(() {
        _ageError = 'You must be at least 18 years old';
      });
      isValid = false;
    }

    return isValid;
  }

  void _proceedToSummary() {
    if (_validateFields()) {
      final updatedData = Map<String, dynamic>.from(widget.registrationData);
      updatedData['newsletter'] = _newsletter;
      updatedData['language'] = _language;
      updatedData['age'] = _age;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SummaryScreen(registrationData: updatedData),
        ),
      );
    }
  }

  void _goBack() {
    final updatedData = Map<String, dynamic>.from(widget.registrationData);
    updatedData['newsletter'] = _newsletter;
    updatedData['language'] = _language;
    updatedData['age'] = _age;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AddressScreen(registrationData: updatedData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Step 3 of 3',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your preferences',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            
            // Newsletter Checkbox
            Card(
              child: CheckboxListTile(
                title: const Text('Subscribe to Newsletter'),
                subtitle: const Text('Receive updates and promotions via email'),
                value: _newsletter,
                onChanged: (bool? value) {
                  setState(() {
                    _newsletter = value ?? false;
                  });
                },
                secondary: const Icon(Icons.mail_outline),
              ),
            ),
            const SizedBox(height: 20),

            // Language Dropdown
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.language, color: Colors.grey),
                          SizedBox(width: 16),
                          Text(
                            'Preferred Language',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButtonFormField<String>(
                        value: _language,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _languages.map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _language = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Age Slider
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.cake, color: Colors.grey),
                        const SizedBox(width: 16),
                        Text(
                          'Age: ${_age.toInt()} years',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Slider(
                      value: _age,
                      min: 13,
                      max: 100,
                      divisions: 87,
                      label: _age.toInt().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _age = value;
                          _ageError = null;
                        });
                      },
                    ),
                    if (_ageError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _ageError!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const Text(
                      'Slide to select your age',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _proceedToSummary,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Review & Submit',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== SUMMARY SCREEN ====================
class SummaryScreen extends StatelessWidget {
  final Map<String, dynamic> registrationData;

  const SummaryScreen({super.key, required this.registrationData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Summary'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PreferencesScreen(registrationData: registrationData),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            const Text(
              'Registration Complete!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Please review your information below',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Personal Information Card
            _buildSectionCard(
              context,
              'Personal Information',
              Icons.person,
              [
                _buildInfoRow('Name', registrationData['name'] ?? ''),
                _buildInfoRow('Email', registrationData['email'] ?? ''),
                _buildInfoRow('Phone', registrationData['phone'] ?? ''),
              ],
            ),
            const SizedBox(height: 16),

            // Address Card
            _buildSectionCard(
              context,
              'Address',
              Icons.location_on,
              [
                _buildInfoRow('Street', registrationData['street'] ?? ''),
                _buildInfoRow('City', registrationData['city'] ?? ''),
                _buildInfoRow('State', registrationData['state'] ?? ''),
                _buildInfoRow('ZIP Code', registrationData['zip'] ?? ''),
              ],
            ),
            const SizedBox(height: 16),

            // Preferences Card
            _buildSectionCard(
              context,
              'Preferences',
              Icons.settings,
              [
                _buildInfoRow(
                  'Newsletter',
                  registrationData['newsletter'] == true ? 'Subscribed' : 'Not Subscribed',
                ),
                _buildInfoRow('Language', registrationData['language'] ?? ''),
                _buildInfoRow('Age', '${(registrationData['age'] ?? 0).toInt()} years'),
              ],
            ),
            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: () {
                // Navigate back to start for a new registration
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalInfoScreen(registrationData: {}),
                  ),
                  (route) => false,
                );
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registration submitted successfully!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              icon: const Icon(Icons.check),
              label: const Text(
                'Submit Registration',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreferencesScreen(registrationData: registrationData),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Information'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}