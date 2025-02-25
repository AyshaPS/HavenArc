import 'package:flutter/material.dart';
import '../models/facility_model.dart';

class FacilityCard extends StatelessWidget {
  final Facility facility;
  final VoidCallback onTap;

  const FacilityCard({Key? key, required this.facility, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Facility Image with Placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  facility.imageUrl.isNotEmpty
                      ? facility.imageUrl
                      : 'https://via.placeholder.com/80', // Default Image
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image,
                          size: 40, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Facility Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facility.name.isNotEmpty
                          ? facility.name
                          : 'Unknown Facility',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      facility.description.isNotEmpty
                          ? facility.description
                          : 'No description available',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
