import 'package:flutter/material.dart';

/// Reusable Dashboard Menu Card (List style)
class MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const MenuCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: height * 0.001, horizontal: width * 0.001),
        padding: EdgeInsets.symmetric(vertical: height * 0.02, horizontal: width * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(width * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: width * 0.04,
              offset: Offset(0, height * 0.006),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: height * 0.03,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, size: height * 0.035, color: color),
            ),
            SizedBox(width: width * 0.05),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: height * 0.022,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: height * 0.022, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
