import '../models/doctor.dart';
import '../models/appointment.dart';

class MockData {
  static const List<Doctor> doctors = [
    Doctor(
      id: 'doc_1',
      name: 'Dr. Tariq Mahmood',
      specialty: 'Cardiothoracic Surgeon',
      hospital: 'National Institute of Cardiovascular Diseases',
      rating: 4.9,
      reviews: 142,
      experience: '16 Years',
      fee: 'PKR 3,000',
      imageUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&auto=format&fit=crop&q=80',
    ),
    Doctor(
      id: 'doc_2',
      name: 'Dr. Ayesha Siddiqa',
      specialty: 'Consultant Neurosurgeon',
      hospital: 'Aga Khan University Hospital',
      rating: 4.8,
      reviews: 98,
      experience: '12 Years',
      fee: 'PKR 3,500',
      imageUrl: 'https://images.unsplash.com/photo-1594824813627-c10fa8892ec5?w=400&auto=format&fit=crop&q=80',
    ),
    Doctor(
      id: 'doc_3',
      name: 'Dr. Salman Haider',
      specialty: 'General & Laparoscopic Surgeon',
      hospital: 'Shifa International Hospital',
      rating: 4.9,
      reviews: 215,
      experience: '14 Years',
      fee: 'PKR 2,500',
      imageUrl: 'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=400&auto=format&fit=crop&q=80',
    ),
    Doctor(
      id: 'doc_4',
      name: 'Dr. Fatima Noor',
      specialty: 'Pediatric Specialist',
      hospital: 'Children\'s Hospital',
      rating: 4.7,
      reviews: 87,
      experience: '9 Years',
      fee: 'PKR 2,000',
      imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&auto=format&fit=crop&q=80',
    ),
    Doctor(
      id: 'doc_5',
      name: 'Dr. Usman Farooq',
      specialty: 'Orthopedic & Spine Surgeon',
      hospital: 'Doctors Hospital & Medical Center',
      rating: 4.8,
      reviews: 130,
      experience: '15 Years',
      fee: 'PKR 2,800',
      imageUrl: 'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=400&auto=format&fit=crop&q=80',
    ),
  ];

  static const List<Appointment> appointments = [
    Appointment(
      id: 'apt_1',
      doctorName: 'Dr. Tariq Mahmood',
      specialty: 'Cardiothoracic Surgeon',
      hospital: 'NICVD - Teleconsultation Room 4',
      date: 'Today, 14 Nov',
      time: '04:30 PM',
      status: 'Upcoming',
      type: 'Teleconsult',
      fee: 'PKR 3,000',
    ),
    Appointment(
      id: 'apt_2',
      doctorName: 'Dr. Ayesha Siddiqa',
      specialty: 'Consultant Neurosurgeon',
      hospital: 'Aga Khan Hospital - Clinic Suite 3B',
      date: 'Mon, 17 Nov',
      time: '11:00 AM',
      status: 'Upcoming',
      type: 'In-Person',
      fee: 'PKR 3,500',
    ),
    Appointment(
      id: 'apt_3',
      doctorName: 'Dr. Salman Haider',
      specialty: 'Laparoscopic Surgeon',
      hospital: 'Shifa International Hospital',
      date: '02 Nov, 2026',
      time: '02:00 PM',
      status: 'Completed',
      type: 'Surgical',
      fee: 'PKR 2,500',
    ),
    Appointment(
      id: 'apt_4',
      doctorName: 'Dr. Fatima Noor',
      specialty: 'Pediatric Specialist',
      hospital: 'Children\'s Hospital',
      date: '25 Oct, 2026',
      time: '10:30 AM',
      status: 'Cancelled',
      type: 'Teleconsult',
      fee: 'PKR 2,000',
    ),
  ];

  static const List<Map<String, dynamic>> healthTips = [
    {
      'title': 'Pre-Surgery Fasting Guidelines',
      'desc': 'Remember not to consume solid foods for at least 8 hours prior to surgical procedures.',
      'category': 'Surgical Care',
    },
    {
      'title': 'Teleconsult Audio & Video Prep',
      'desc': 'Ensure your internet connection is stable and keep previous ECG or lab reports ready.',
      'category': 'Telemedicine',
    },
    {
      'title': 'Post-Op Vital Monitoring',
      'desc': 'Track temperature and oxygen saturation twice daily after discharge.',
      'category': 'Recovery',
    },
  ];
}
