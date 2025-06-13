import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_constants.dart';
import '../../services/course_service/course_service.dart';
import '../../widgets/custom_text_field.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courseService = CourseService();

  // Form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountedPriceController = TextEditingController();

  // Course content list
  final List<Map<String, dynamic>> _courseContent = [];

  // Tags
  final List<String> _tags = [];
  final _tagController = TextEditingController();

  // Image
  File? _thumbnailImage;
  String _thumbnailUrl = '';
  bool _isUploading = false;
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _discountedPriceController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      setState(() {
        _thumbnailImage = File(image.path);
      });

      // In a real implementation, you would upload the image to your server
      // and get back the URL to store with the course

      // Simulate upload delay
      setState(() {
        _isUploading = true;
      });

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isUploading = false;
        _thumbnailUrl =
            'https://example.com/placeholder-image.jpg'; // Placeholder
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _addContentSection() {
    // Add a new blank content section
    setState(() {
      _courseContent.add({
        'title': '',
        'description': '',
        'videoUrl': '',
        'videoLength': 0,
        'links': [],
        'suggestion': '',
      });
    });
  }

  void _updateContentSection(int index, String field, dynamic value) {
    setState(() {
      _courseContent[index][field] = value;
    });
  }

  void _removeContentSection(int index) {
    setState(() {
      _courseContent.removeAt(index);
    });
  }

  Future<void> _submitCourse() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Store a reference to ScaffoldMessenger before any async gaps
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (_thumbnailUrl.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Please upload a thumbnail image')),
      );
      return;
    }

    if (_tags.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Please add at least one tag')),
      );
      return;
    }

    if (_courseContent.isEmpty) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please add at least one content section'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final discountedPrice =
          _discountedPriceController.text.isEmpty
              ? price
              : double.tryParse(_discountedPriceController.text) ?? price;
      final durationInWeeks = int.tryParse(_durationController.text) ?? 1;

      await _courseService.createCourse(
        name: _nameController.text,
        description: _descriptionController.text,
        thumbnail: _thumbnailUrl,
        tags: _tags,
        price: price,
        discountedPrice: discountedPrice,
        durationInWeeks: durationInWeeks,
        content: _courseContent,
      );

      if (mounted) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Course created successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Course'), elevation: 0),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Course Thumbnail
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Course Thumbnail',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _isUploading ? null : _pickImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child:
                            _isUploading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : _thumbnailImage != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _thumbnailImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 50,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Click to upload thumbnail',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Basic Course Information
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Course Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Course Name',
                      hint: 'Enter course name',
                      controller: _nameController,
                      prefixIcon: Icons.school,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter course name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Description',
                      hint: 'Enter course description',
                      controller: _descriptionController,
                      prefixIcon: Icons.description,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter course description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Duration (in weeks)',
                      hint: 'e.g. 4',
                      controller: _durationController,
                      prefixIcon: Icons.timer,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter duration';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Price (\$)',
                            hint: 'e.g. 49.99',
                            controller: _priceController,
                            prefixIcon: Icons.attach_money,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter price';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid price';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            label: 'Discounted Price (\$)',
                            hint: 'Optional',
                            controller: _discountedPriceController,
                            prefixIcon: Icons.discount,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final price =
                                    double.tryParse(_priceController.text) ?? 0;
                                final discountedPrice =
                                    double.tryParse(value) ?? 0;
                                if (discountedPrice > price) {
                                  return 'Cannot be higher than price';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tags
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tags',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add relevant tags to help students find your course',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Tag',
                            hint: 'Enter a tag',
                            controller: _tagController,
                            prefixIcon: Icons.tag,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addTag,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                          ),
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          _tags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () => _removeTag(tag),
                              backgroundColor: AppColors.primaryLight.withAlpha(
                                51,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Course Content Sections
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Course Content',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton.icon(
                          onPressed: _addContentSection,
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add Section'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_courseContent.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.article_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No content sections yet',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add your first content section to get started',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _courseContent.length,
                        separatorBuilder: (_, _) => const Divider(),
                        itemBuilder: (context, index) {
                          return ContentSectionItem(
                            index: index,
                            content: _courseContent[index],
                            onUpdate: _updateContentSection,
                            onRemove: () => _removeContentSection(index),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitCourse,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:
                  _isSubmitting
                      ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Creating Course...'),
                        ],
                      )
                      : const Text('Create Course'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Widget for individual content sections
class ContentSectionItem extends StatelessWidget {
  final int index;
  final Map<String, dynamic> content;
  final Function(int, String, dynamic) onUpdate;
  final VoidCallback onRemove;

  const ContentSectionItem({
    super.key,
    required this.index,
    required this.content,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Section ${index + 1}',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Remove section',
            ),
          ],
        ),
        const SizedBox(height: 8),
        CustomTextField(
          label: 'Title',
          hint: 'Enter section title',
          initialValue: content['title'],
          prefixIcon: Icons.title,
          onChanged: (value) => onUpdate(index, 'title', value),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          label: 'Description',
          hint: 'Enter section description',
          initialValue: content['description'],
          prefixIcon: Icons.description,
          maxLines: 3,
          onChanged: (value) => onUpdate(index, 'description', value),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          label: 'Video URL',
          hint: 'Enter video URL',
          initialValue: content['videoUrl'],
          prefixIcon: Icons.video_library,
          onChanged: (value) => onUpdate(index, 'videoUrl', value),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          label: 'Video Length (minutes)',
          hint: 'Enter video length',
          initialValue: content['videoLength'].toString(),
          prefixIcon: Icons.timer,
          keyboardType: TextInputType.number,
          onChanged:
              (value) =>
                  onUpdate(index, 'videoLength', int.tryParse(value) ?? 0),
        ),
      ],
    );
  }
}
