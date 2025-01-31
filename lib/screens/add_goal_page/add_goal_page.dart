// Third-party package imports (external libraries)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_finance/constants/style.dart';

final _firebase = FirebaseAuth.instance;

class AddSavingGoalScreen extends StatefulWidget {
  @override
  _AddSavingGoalScreenState createState() => _AddSavingGoalScreenState();
}

class _AddSavingGoalScreenState extends State<AddSavingGoalScreen> {
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final timeToBuyController = TextEditingController();
  final urlController = TextEditingController();
  final notesController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add New Goal'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(productNameController, 'Add the product\'s name',
              Icons.shopping_cart),
          const SizedBox(height: 10),
          _buildTextField(priceController, 'Price', Icons.attach_money),
          const SizedBox(height: 10),
          _buildDateSelector(timeToBuyController, 'Estimate time to buy', Icons.calendar_month_outlined),
          const SizedBox(height: 10),
          _buildTextField(urlController, 'URL', Icons.link),
          const SizedBox(height: 10),
          _buildTextField(notesController, 'Write notes', Icons.note),
          const SizedBox(height: 20),
          _buildImageUploadSection(),
          const SizedBox(height: 20),
          _buildSaveButton(),
        ],
      ),
    );
  }

  TextField _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: black,
        ),
        labelStyle: const TextStyle(
            fontWeight: FontWeight.w500, fontSize: 16, color: black),
        // Customize the bottom border
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: black, width: 0.5),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: black, width: 0.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: black, width: 1),
        ),
      ),
    );
  }

  Widget _buildDateSelector(
      TextEditingController controller, String label, IconData icon) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                  primary: primaryPurple, // Primary color for the header
                  onPrimary: white, // Text color for elements on primary color
                  surface: white, // Background color of the calendar
                ),
                dialogBackgroundColor:
                    Colors.white, // Background color of the dialog
                dialogTheme: DialogTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12), // Border radius for the dialog
                  ),
                ),
              ),
              child: DatePickerDialog(
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              ),
            );
          },
        );

        if (picked != null && picked != selectedDate) {
          setState(() {
            selectedDate = picked;
            controller.text = "${selectedDate.toLocal()}".split(' ')[0];
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: black,
            ),
            prefixIcon: Icon(
              icon,
              color: black,
            ),
            // Customize the bottom border
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: black, width: 0.5),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: black, width: 0.5),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: black, width: 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed:
                  _pickImageFromCamera, // Function to handle camera image capture
              icon: const Icon(Icons.camera_alt, color: Colors.black),
              label: const Text(
                'Use Camera',
                style: TextStyle(
                  color: Colors.black, // Corrected to Colors.black
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3, // Elevation for drop shadow
                shadowColor: Colors.grey, // Shadow color
                minimumSize: Size(double.infinity, 60), // Set a fixed height
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed:
                  _pickImageFromGallery, // Function to handle image selection from gallery
              icon: const Icon(Icons.photo_library, color: Colors.black),
              label: const Text(
                'Upload from Library',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black, // Corrected to Colors.black
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3, // Elevation for drop shadow
                shadowColor: Colors.grey, // Shadow color
                minimumSize: Size(double.infinity, 60), // Set a fixed height
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImageFromCamera() async {
    // Implement the functionality to capture image from camera
  }

  Future<void> _pickImageFromGallery() async {
    // Implement the functionality to select image from gallery
  }

  Widget _buildSaveButton() {
    // Added context parameter
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _saveGoal,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple, // Set to primaryPurple
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Set border radius to 12
          ),
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Future<void> _pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     _image = image;
  //   });
  // }

  Future<void> _saveGoal() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a new document in 'saving_goals' collection
    await firestore
        .collection('users')
        .doc(_firebase.currentUser!.uid)
        .collection('goals')
        .add({
      'productName': productNameController.text,
      'price': double.tryParse(priceController.text),
      'saved': 0,
      'timeToBuy': selectedDate,
      'url': urlController.text,
      'notes': notesController.text,
      'imagePath': _image?.path // Optional: handle image storage separately
    });

    // Clear the form after saving
    productNameController.clear();
    priceController.clear();
    timeToBuyController.clear();
    urlController.clear();
    notesController.clear();
    setState(() {
      _image = null;
    });
  }
}
