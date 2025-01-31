import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/models/category_model.dart';
import 'package:personal_finance/widgets/category_picker.dart';
import 'package:personal_finance/models/plan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance/constants/style.dart';

var formatter = DateFormat.yMd();
var currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
final _firebase = FirebaseAuth.instance;

class WeeklyPlanForm extends StatefulWidget {
  const WeeklyPlanForm({super.key});
  @override
  State<WeeklyPlanForm> createState() {
    return WeeklyPlanFormState();
  }
}

class WeeklyPlanFormState extends State<WeeklyPlanForm> {
  DateTime? _selectedDate;
  Category? _selectedCategory;
  Priority? _selectedPriority;
  final user = FirebaseAuth.instance.currentUser;

  final productNameController = TextEditingController();
  final priceController = TextEditingController();

  void onCategorySelected(Category category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void onShowCategoriesPicker() async {
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
      // Handle the selected category
      setState(() {
        _selectedCategory = selectedCategory;
      });
    }
  }

  void onSubmit() async {
    if (_selectedCategory == null ||
        _selectedPriority == null ||
        _selectedDate == null) {
      _showCustomSnackBar('Please complete all fields', isError: true);
      return;
    }

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final userUid = user!.uid; // Ensure that the user is not null

      await firestore.collection('users').doc(userUid).collection('plans').add({
        'productName': productNameController.text,
        'price': double.tryParse(priceController.text) ??
            0.0, // Default to 0.0 if parsing fails
        'date': _selectedDate, // Convert DateTime to Timestamp
        'category': _selectedCategory!.name,
        'priority': _selectedPriority
            .toString()
            .split('.')
            .last, // Save only the enum value as String
      });

      // Clearing the form
      productNameController.clear();
      priceController.clear();
      setState(() {
        _selectedCategory = null;
        _selectedPriority = null;
        _selectedDate = null;
      });

      _showCustomSnackBar('Plan saved successfully!');
    } catch (e) {
      _showCustomSnackBar('Error saving plan: $e', isError: true);
    }
  }

  void _showCustomSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : primaryPurple,
        content: Text(
          message,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Weekly Plan",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        child: Form(
          child: Column(
            children: [
              _buildTextField(
                  productNameController, "Task Name", Icons.task_alt),
              const SizedBox(
                height: 10,
              ),
              _buildTextField(
                  priceController, "Budget", Icons.price_change_outlined),
              const SizedBox(
                height: 10,
              ),
              _buildDateSelector(
                  context,
                  "Pick a Date",
                  Icons.calendar_month_outlined,),
              const SizedBox(
                height: 10,
              ),
              PrioritySelectionWidget(
                selectedPriority: _selectedPriority,
                onPriorityChanged: (Priority? newValue) {
                  setState(() {
                    _selectedPriority = newValue;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CategorySelectionButton(
                selectedCategory: _selectedCategory,
                onShowCategoriesPicker: onShowCategoriesPicker,
              ),
              const SizedBox(
                height: 20,
              ),
              _buildSaveButton(),
            ],
          ),
        ),
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

  Widget _buildSaveButton() {
    // Added context parameter
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onSubmit,
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

  Widget _buildDateSelector(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    TextEditingController dateController = TextEditingController();

    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (picked != null && picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
            dateController.text =
                DateFormat('yyyy-MM-dd').format(_selectedDate!);
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: dateController
            ..text = _selectedDate != null
                ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                : '',
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
}

class PrioritySelectionWidget extends StatelessWidget {
  final Priority? selectedPriority;
  final ValueChanged<Priority?> onPriorityChanged;

  const PrioritySelectionWidget({
    Key? key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showPriorityOptions(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: black, width: 0.5), // Bottom border
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.flag, // Icon for the button
              color: _getPriorityColor(selectedPriority),
            ),
            const SizedBox(width: 10), // Spacing between icon and text
            Expanded(
              child: Text(
                selectedPriority?.name ?? 'Priority',
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.black), // Dropdown icon
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(Priority? priority) {
    switch (priority) {
      case Priority.High:
        return Colors.red;
      case Priority.Medium:
        return Colors.yellow;
      case Priority.Low:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showPriorityOptions(BuildContext context) async {
    final selectedPriority = await showModalBottomSheet<Priority>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: Priority.values.map((Priority priority) {
              return ListTile(
                leading: Icon(Icons.flag, color: _getPriorityColor(priority)),
                title: Text(priority.name),
                onTap: () => Navigator.pop(context, priority),
              );
            }).toList(),
          ),
        );
      },
    );

    if (selectedPriority != null) {
      onPriorityChanged(selectedPriority);
    }
  }
}

class CategorySelectionButton extends StatelessWidget {
  final Category? selectedCategory;
  final VoidCallback onShowCategoriesPicker;

  const CategorySelectionButton({
    Key? key,
    required this.selectedCategory,
    required this.onShowCategoriesPicker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onShowCategoriesPicker,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: black, // Color for the bottom border
              width: 0.5, // Width of the bottom border
            ),
          ),
        ),
        child: Row(
          children: [
            selectedCategory == null
                ? const Icon(Icons.category)
                : selectedCategory!.getIcon(),
            const SizedBox(width: 6),
            Text(
              selectedCategory == null
                  ? "Category"
                  : selectedCategory!.name.length > 12
                      ? '${selectedCategory!.name.substring(0, 12)}...'
                      : selectedCategory!.name,
              style: const TextStyle(
                fontWeight: FontWeight.w400, // Font weight
                fontSize: 16, // Font size
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
