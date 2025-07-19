import 'package:flutter/material.dart';
import 'form_field_config.dart';
import 'editable_model.dart';
import '../services/service_provider.dart';

typedef ModelBuilder<T> = T Function(Map<String, dynamic> formData);
typedef SaveFunction<T> = Future<void> Function(T model);

class EditFormPage<T extends EditableModel> extends StatefulWidget {
  final List<FormFieldConfig> fieldConfigs;
  final T? existingModel;
  final ModelBuilder<T> modelBuilder;
  final SaveFunction<T> onSave;
  final FormMode mode;
  final String? customTitle;
  final bool shouldPopAfterSave;

  const EditFormPage({
    super.key,
    required this.fieldConfigs,
    this.existingModel,
    required this.modelBuilder,
    required this.onSave,
    this.customTitle,
    this.shouldPopAfterSave = true,
  }) : mode = existingModel == null ? FormMode.add : FormMode.edit;

  @override
  State<EditFormPage<T>> createState() => _EditFormPageState<T>();
}

class _EditFormPageState<T extends EditableModel> extends State<EditFormPage<T>> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _formData = {};
  bool _isLoading = false;

  final _inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: Colors.redAccent,
        width: 2,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _populateExistingData();
  }

  void _initializeControllers() {
    for (final config in widget.fieldConfigs) {
      if (config.customWidget == null) {
        _controllers[config.name] = TextEditingController(
          text: config.initialValue,
        );
        // Also set initial form data
        if (config.initialValue != null) {
          _formData[config.name] = config.initialValue;
        }
      }
    }
  }

  void _populateExistingData() {
    if (widget.existingModel != null) {
      final formData = widget.existingModel!.toFormData();
      for (final entry in formData.entries) {
        if (_controllers.containsKey(entry.key)) {
          _controllers[entry.key]!.text = entry.value?.toString() ?? '';
        }
        _formData[entry.key] = entry.value;
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String get _title {
    if (widget.customTitle != null) return widget.customTitle!;
    
    // Get model name from existing model if available
    if (widget.existingModel != null) {
      final modelName = widget.existingModel!.modelTypeName;
      return widget.mode == FormMode.add 
          ? 'Add $modelName' 
          : 'Edit $modelName';
    }
    
    // For new models, try to infer the type from T
    final typeName = T.toString();
    return 'Add $typeName';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: FormDataUpdater(
        updateFormData: updateFormData,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._buildFormFields(),
                  const SizedBox(height: 16.0),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return widget.fieldConfigs.map((config) {
      final controller = _controllers[config.name];
      
      // Handle custom widgets
      if (config.customWidget != null) {
        return config.buildFormField(
          context,
          TextEditingController(), // Dummy controller for custom widgets
          _inputDecoration,
        );
      }
      
      // Handle standard text fields
      return config.buildFormField(
        context,
        controller!,
        _inputDecoration,
      );
    }).toList();
  }

  Widget _buildSubmitButton() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: _handleSubmit,
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Collect form data from controllers
        for (final entry in _controllers.entries) {
          _formData[entry.key] = entry.value.text;
        }

        // Build the model
        final model = widget.modelBuilder(_formData);

        // Save the model
        await widget.onSave(model);

        setState(() {
          _isLoading = false;
        });

        if (!mounted) return;
        if (widget.shouldPopAfterSave) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Public method to update form data (for custom widgets)
  void updateFormData(String key, dynamic value) {
    setState(() {
      _formData[key] = value;
    });
  }
}

// Helper widget to provide form data update functionality
class FormDataUpdater extends InheritedWidget {
  final void Function(String, dynamic) updateFormData;

  const FormDataUpdater({
    super.key,
    required super.child,
    required this.updateFormData,
  });

  static FormDataUpdater? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FormDataUpdater>();
  }

  @override
  bool updateShouldNotify(covariant FormDataUpdater oldWidget) => false;
}