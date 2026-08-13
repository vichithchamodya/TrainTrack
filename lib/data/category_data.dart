import 'package:flutter/material.dart';

import 'package:traintrack/models/category_model.dart';

class CategoryData {
  final List<CategoryModel> categoryList = [
    CategoryModel(
      categoryIcon: Icons.assignment_ind,
      categoryName: "Onboarding & Orientation",
    ),
    CategoryModel(
      categoryIcon: Icons.supervisor_account,
      categoryName: "Leadership & Management",
    ),
    CategoryModel(
      categoryIcon: Icons.gavel,
      categoryName: "Compliance & Legal",
    ),
    CategoryModel(
      categoryIcon: Icons.security,
      categoryName: "Cybersecurity & Data Privacy",
    ),
    CategoryModel(
      categoryIcon: Icons.health_and_safety,
      categoryName: "Workplace Safety & Health",
    ),
    CategoryModel(
      categoryIcon: Icons.psychology,
      categoryName: "Soft Skills & Communication",
    ),
    CategoryModel(
      categoryIcon: Icons.support_agent,
      categoryName: "Customer Service & Support",
    ),
    CategoryModel(
      categoryIcon: Icons.diversity_3,
      categoryName: "Diversity, Equity & Inclusion",
    ),
    CategoryModel(
      categoryIcon: Icons.handshake,
      categoryName: "Sales & Negotiation",
    ),
    CategoryModel(
      categoryIcon: Icons.account_tree,
      categoryName: "Project Management",
    ),
    CategoryModel(
      categoryIcon: Icons.engineering,
      categoryName: "Technical & Role Skills",
    ),
    CategoryModel(
      categoryIcon: Icons.fact_check,
      categoryName: "Quality Assurance & Standards",
    ),
    CategoryModel(
      categoryIcon: Icons.account_balance_wallet,
      categoryName: "Finance & Budgeting",
    ),
    CategoryModel(
      categoryIcon: Icons.school,
      categoryName: "Professional Development",
    ),
  ];
}
