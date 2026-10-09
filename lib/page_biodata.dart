import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BioDataPage extends StatefulWidget {
  const BioDataPage({super.key});

  @override
  State<BioDataPage> createState() => _BioDataPageState();
}

class _BioDataPageState extends State<BioDataPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final birthController = TextEditingController();
  final placeBirthController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final currentAddressController = TextEditingController();
  final permanentAddressController = TextEditingController();
  final citizenshipController = TextEditingController();
  final nationalityController = TextEditingController();
  final civilStatusController = TextEditingController();
  final elementaryController = TextEditingController();
  final elementaryYearController = TextEditingController();
  final highController = TextEditingController();
  final highYearController = TextEditingController();
  final collegeController = TextEditingController();
  final collegeYearController = TextEditingController();

  bool isLoading = false;

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('biodata').add({
        'name': nameController.text.trim(),
        'mobileNumber': mobileController.text.trim(),
        'emailAddress': emailController.text.trim(),
        'dateOfBirth': birthController.text.trim(),
        'placeOfBirth': placeBirthController.text.trim(),
        'age': ageController.text.trim(),
        'gender': genderController.text.trim(),
        'currentAddress': currentAddressController.text.trim(),
        'permanentAddress': permanentAddressController.text.trim(),
        'citizenship': citizenshipController.text.trim(),
        'nationality': nationalityController.text.trim(),
        'civilStatus': civilStatusController.text.trim(),
        'elementarySchool': elementaryController.text.trim(),
        'elementaryGraduateDate': elementaryYearController.text.trim(),
        'highSchool': highController.text.trim(),
        'highSchoolGraduateDate': highYearController.text.trim(),
        'collegeSchool': collegeController.text.trim(),
        'collegeGraduateDate': collegeYearController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biodata successfully saved to Firebase!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the form after successful saving.
      for (final controller in _controllers) {
        controller.clear();
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save biodata: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<TextEditingController> get _controllers => [
    nameController,
    mobileController,
    emailController,
    birthController,
    placeBirthController,
    ageController,
    genderController,
    currentAddressController,
    permanentAddressController,
    citizenshipController,
    nationalityController,
    civilStatusController,
    elementaryController,
    elementaryYearController,
    highController,
    highYearController,
    collegeController,
    collegeYearController,
  ];

  Widget paperField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool requiredField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 155,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Text(
            ':',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(fontFamily: 'serif', fontSize: 14),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                border: UnderlineInputBorder(),
              ),
              validator: requiredField
                  ? (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 26, bottom: 16),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'serif',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      appBar: AppBar(
        title: const Text('Biodata Form'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'BIODATA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 26),

                    paperField(
                      label: 'Name',
                      controller: nameController,
                      requiredField: true,
                    ),
                    paperField(
                      label: 'Mobile Number',
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                    ),
                    paperField(
                      label: 'Email Address',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      requiredField: true,
                    ),
                    paperField(
                      label: 'Date of Birth',
                      controller: birthController,
                    ),
                    paperField(
                      label: 'Place of Birth',
                      controller: placeBirthController,
                    ),
                    paperField(
                      label: 'Age',
                      controller: ageController,
                      keyboardType: TextInputType.number,
                    ),
                    paperField(label: 'Gender', controller: genderController),
                    paperField(
                      label: 'Current Address',
                      controller: currentAddressController,
                    ),
                    paperField(
                      label: 'Permanent Address',
                      controller: permanentAddressController,
                    ),
                    paperField(
                      label: 'Citizenship',
                      controller: citizenshipController,
                    ),
                    paperField(
                      label: 'Nationality',
                      controller: nationalityController,
                    ),
                    paperField(
                      label: 'Civil Status',
                      controller: civilStatusController,
                    ),

                    sectionHeading('EDUCATIONAL QUALIFICATION'),

                    paperField(
                      label: 'Elementary School',
                      controller: elementaryController,
                    ),
                    paperField(
                      label: 'Elementary Graduate Date',
                      controller: elementaryYearController,
                    ),
                    paperField(
                      label: 'High School',
                      controller: highController,
                    ),
                    paperField(
                      label: 'High School Graduate Date',
                      controller: highYearController,
                    ),
                    paperField(
                      label: 'College School',
                      controller: collegeController,
                    ),
                    paperField(
                      label: 'College Graduate Date',
                      controller: collegeYearController,
                    ),

                    const SizedBox(height: 28),

                    ElevatedButton(
                      onPressed: isLoading ? null : submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Submit Biodata'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
