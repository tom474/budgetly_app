import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/models/category_model.dart';
import 'package:personal_finance/widgets/category_picker.dart';
import 'package:personal_finance/constants/style.dart';
import 'package:intl/intl.dart';

final _firebase = FirebaseAuth.instance;

class AddExpensesPage extends StatefulWidget {
  const AddExpensesPage({Key? key}) : super(key: key);

  @override
  State<AddExpensesPage> createState() {
    return _AddExpensesPageState();
  }
}

class _AddExpensesPageState extends State<AddExpensesPage> {
  DateTime? selectedDate = null;
  DateTime? reminderDate = null;
  Category? _selectedCategory;

  // Controllers
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> _saveTransaction() async {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final userUid = _firebase.currentUser!.uid;
      final collectionName = _selectedCategory!.type == Type.Expense
          ? 'expenses'
          : _selectedCategory!.type == Type.Income
              ? 'incomes'
              : 'debts';

      await firestore
          .collection('users')
          .doc(userUid)
          .collection(collectionName)
          .add({
        'category': _selectedCategory!.name,
        'amount': double.tryParse(amountController.text) ?? 0,
        'description': descriptionController.text,
        'selectedDate': selectedDate,
        'reminderDate': reminderDate,
      });

      // Clear the form, reset dates, and clear controllers
      amountController.clear();
      descriptionController.clear();
      setState(() {
        _selectedCategory = null;
        selectedDate = null; // Reset to null or some default value
        reminderDate = null; // Reset to null or some default value
      });
      
      _showCustomSnackBar('Transaction saved successfully');
    } catch (e) {
      _showCustomSnackBar('Error saving transaction: $e', isError: true);
    }
  }

  void _showCustomSnackBar(String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isError ? Colors.red : primaryPurple, // Use red for errors
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  );
}

  void onCategorySelected(Category category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Transactions'),
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
          CategoryButton(
            selectedCategory: _selectedCategory,
            onCategorySelected: onCategorySelected,
          ),
          const SizedBox(height: 10),
          _buildTextField(amountController, "Amount", Icons.monetization_on),
          const SizedBox(height: 10),
          _buildTextField(descriptionController, "Description", Icons.note_add),
          const SizedBox(height: 10),
          _buildDateSelector(
            context,
            "Transaction Date",
            Icons.calendar_today_rounded,
            selectedDate,
            (newDate) => selectedDate = newDate,
          ),
          const SizedBox(height: 10),
          _buildDateSelector(
            context,
            "Reminder Date",
            Icons.access_time_outlined,
            reminderDate,
            (newDate) => reminderDate = newDate,
          ),
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
            fontWeight: FontWeight.w400, fontSize: 16, color: black),
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
      BuildContext context,
      String label,
      IconData icon,
      DateTime? dateValue,
      Function(DateTime) onDateSelected,) {
    var formattedDate =
        dateValue != null ? DateFormat('yyyy-MM-dd').format(dateValue) : '';
    TextEditingController dateController =
        TextEditingController(text: formattedDate);
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
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              ),
            );
          },
        );

        if (picked != null && picked != dateValue) {
          setState(() {
            onDateSelected(picked);
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: dateController,
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
        onPressed: _saveTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple, // Set to primaryPurple
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Set border radius to 12
          ),
        ),
        child: const Text(
          'Add',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final Category? selectedCategory;
  final Function(Category) onCategorySelected;

  CategoryButton({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final selectedCategory = await showModalBottomSheet<Category>(
          useSafeArea: true,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return CategoryPicker(
              onCategorySelected: (category) {
                Navigator.pop(context, category); // Pass selected category back
              },
            );
          },
        );

        if (selectedCategory != null) {
          onCategorySelected(selectedCategory);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black, // Darker color for the bottom border
              width: 0.5, // Increase the width for a thicker line
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.category, // Icon for the button
              color: Colors.black,
            ),
            const SizedBox(width: 10), // Spacing between icon and text
            Expanded(
              child: Text(
                selectedCategory == null
                    ? 'Category'
                    : (selectedCategory!.name.length > 20
                        ? '${selectedCategory!.name.substring(0, 12)}...'
                        : selectedCategory!.name),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
