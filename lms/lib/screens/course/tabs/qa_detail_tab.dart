import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../models/course/course.dart';
import '../../../models/course/course_question.dart';
import '../utils/format_utils.dart';

class QADetailTab extends StatelessWidget {
  final Course course;

  const QADetailTab({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // Collect all questions from all content sections
    final List<CourseQuestion> allQuestions = [];
    for (final content in course.content) {
      allQuestions.addAll(content.questions);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: const Text(
            'Questions & Answers',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child:
              allQuestions.isEmpty
                  ? const Center(
                    child: Text(
                      'No questions yet',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                  : ListView.builder(
                    // Allow scrolling by removing NeverScrollablePhysics
                    padding: const EdgeInsets.all(16),
                    itemCount: allQuestions.length,
                    itemBuilder: (context, index) {
                      final question = allQuestions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User info
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.primary,
                                    backgroundImage:
                                        question.user.avatar.isNotEmpty
                                            ? NetworkImage(question.user.avatar)
                                            : null,
                                    child:
                                        question.user.avatar.isEmpty
                                            ? Text(
                                              question.user.name.isNotEmpty
                                                  ? question.user.name[0]
                                                      .toUpperCase()
                                                  : 'U',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                            : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          question.user.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          FormatUtils.formatDate(
                                            question.createdAt,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Question with clear visual separation
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey[200]!,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  question.question,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Answers
                              if (question.answers.isNotEmpty) ...[
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.question_answer,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${question.answers.length} Answer${question.answers.length > 1 ? 's' : ''}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                for (final answer in question.answers)
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 16,
                                      bottom: 12,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.blue[100]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor:
                                                  AppColors.primaryLight,
                                              backgroundImage:
                                                  answer.user.avatar.isNotEmpty
                                                      ? NetworkImage(
                                                        answer.user.avatar,
                                                      )
                                                      : null,
                                              child:
                                                  answer.user.avatar.isEmpty
                                                      ? Text(
                                                        answer
                                                                .user
                                                                .name
                                                                .isNotEmpty
                                                            ? answer
                                                                .user
                                                                .name[0]
                                                                .toUpperCase()
                                                            : 'U',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      )
                                                      : null,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    answer.user.name,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    FormatUtils.formatDate(
                                                      answer.createdAt,
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          AppColors
                                                              .textSecondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          answer.answer,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                              ] else
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: AppColors.textSecondary,
                                        size: 16,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'No answers yet',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
