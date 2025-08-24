import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sphere/model/CreateAlertModel.dart';
import '../providers/CreateAlertProvider.dart';

class CreateAlertScreen extends ConsumerStatefulWidget {
  const CreateAlertScreen({super.key});

  @override
  ConsumerState<CreateAlertScreen> createState() => _CreateAlertScreenState();
}

class _CreateAlertScreenState extends ConsumerState<CreateAlertScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _buildingController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedType = "Fire";
  String _severityLevel = "Low";
  String _selectAmbulance = "Ambulance 1";
  String _selectFireFighter = "Fire Fighter 1";
  String _selectZone= "None";
  String _selectBuildingName = "Al Mousa Tower";


  @override
  Widget build(BuildContext context) {
    final alertState = ref.watch(alertProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Alert",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF0007), Color(0xFFFF0068)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              _buildTextField(_titleController, "Alert Title"),

              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectBuildingName,
                items: const [

                  DropdownMenuItem(value: "Al Mousa Tower", child: Text("Al Mousa Tower")),
                  DropdownMenuItem(value: "Al Qariyah Building", child: Text("Al Qariyah Building")),
                  DropdownMenuItem(value: "Olaya Tower", child: Text("Olaya Tower")),
                  DropdownMenuItem(value: "Centriya Building", child: Text("Centriya Building")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectBuildingName = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Building Name",
                  labelStyle: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50, // background of the text field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
                dropdownColor: Colors.blue.shade50, // background of dropdown list
                style: const TextStyle(
                  color: Colors.black, // text color inside dropdown
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.blueAccent,
                ),
                borderRadius: BorderRadius.circular(16), // dropdown menu corners
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectZone,
                items: const [

                  DropdownMenuItem(value: "None", child: Text("None")),
                  DropdownMenuItem(value: "Zone 1", child: Text("Zone 1")),
                  DropdownMenuItem(value: "Zone 2", child: Text("Zone 2")),
                  DropdownMenuItem(value: "Zone 3", child: Text("Zone 3")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectZone = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Building Zone",
                  labelStyle: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50, // background of the text field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
                dropdownColor: Colors.white, // background of dropdown list
                style: const TextStyle(
                  color: Colors.black, // text color inside dropdown
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.blueAccent,
                ),
                borderRadius: BorderRadius.circular(16), // dropdown menu corners
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _severityLevel,
                items: const [

                  DropdownMenuItem(value: "Low", child: Text(" 🟢 Low")),
                  DropdownMenuItem(value: "Medium", child: Text("🟠 Medium")),
                  DropdownMenuItem(value: "High", child: Text("🔴 High")),
                  DropdownMenuItem(value: "Critical", child: Text(" 🚨 Critical")),
                ],
                onChanged: (value) {
                  setState(() {
                    _severityLevel = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Severity Level",
                  labelStyle: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.red.shade50, // background of the text field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                  ),
                ),
                dropdownColor: Colors.white, // background of dropdown list
                style: const TextStyle(
                  color: Colors.black, // text color inside dropdown
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.redAccent,
                ),
                borderRadius: BorderRadius.circular(16), // dropdown menu corners
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
              value: _selectedType,
              items: const [
                DropdownMenuItem(value: "Fire", child: Text("🔥 Fire")),
                DropdownMenuItem(value: "Smoke", child: Text("💨 Smoke")),
                DropdownMenuItem(value: "Other", child: Text("⚠️ Other")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Alert Type",
                labelStyle: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: Colors.red.shade50, // background of the text field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
                ),
              ),
              dropdownColor: Colors.white, // background of dropdown list
              style: const TextStyle(
                color: Colors.black, // text color inside dropdown
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              icon: const Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.redAccent,
              ),
              borderRadius: BorderRadius.circular(10), // dropdown menu corners
            ),


              const SizedBox(height: 15),
              _buildTextField(_descriptionController, "Description", maxLines: 4),
       /*       const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectAmbulance,
                items: const [
                  DropdownMenuItem(value: "Ambulance 1", child: Text("Ambulance 1")),
                  DropdownMenuItem(value: "Ambulance 2", child: Text("Ambulance 2")),
                  DropdownMenuItem(value: "Ambulance 3", child: Text("Ambulance 1")),
                ],

                onChanged: (value) {
                  setState(() {
                    _selectAmbulance = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Ambulance",
                  labelStyle: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50, // background of the text field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
                dropdownColor: Colors.white, // background of dropdown list
                style: const TextStyle(
                  color: Colors.black, // text color inside dropdown
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.blueAccent,
                ),
                borderRadius: BorderRadius.circular(16), // dropdown menu corners
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectFireFighter,
                items: const [

                  DropdownMenuItem(value: "Fire Fighter 1", child: Text("Fire Fighter 1")),
                  DropdownMenuItem(value: "Fire Fighter 2", child: Text("Fire Fighter 2")),
                  DropdownMenuItem(value: "Fire Fighter 3", child: Text("Fire Fighter 3")),
                  DropdownMenuItem(value: "Fire Fighter 4", child: Text("Fire Fighter 4")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectFireFighter = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Fire Fighter",
                  labelStyle: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50, // background of the text field
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
                dropdownColor: Colors.white, // background of dropdown list
                style: const TextStyle(
                  color: Colors.black, // text color inside dropdown
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.blueAccent,
                ),
                borderRadius: BorderRadius.circular(16), // dropdown menu corners
              ),*/
              const SizedBox(height: 30),

              alertState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () => _submitAlert(),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF0007), Color(0xFFFF0068)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      "Create Alert",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold
          ),
          filled: true,
          fillColor: Colors.blue.shade50, // bac
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.blueAccent , width: 2)
        ),
        focusedBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.blueAccent , width: 2)
        )

      ),
      validator: (value) => value!.isEmpty ? "Please enter $label" : null,
    );
  }

  void _submitAlert() {
    if (_formKey.currentState!.validate()) {
      final alert = CreateAlertModel(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        buildingName: _buildingController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        type: _selectedType,
        createdAt: DateTime.now()
      );

      ref.read(alertProvider.notifier).createAlert(alert).then((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Alert created successfully")),
          );
        }
      });
    }
  }
}
