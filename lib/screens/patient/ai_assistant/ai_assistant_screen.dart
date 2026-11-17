import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/mock_data.dart';
import '../../../models/doctor.dart';
import '../booking/appointment_booking_screen.dart';

class ReportParameter {
  final String name;
  final String value;
  final String refRange;
  final String status;
  final bool isAbnormal;

  const ReportParameter({
    required this.name,
    required this.value,
    required this.refRange,
    required this.status,
    this.isAbnormal = false,
  });
}

class ReportAnalysisData {
  final String reportName;
  final String source;
  final String date;
  final String overallStatus;
  final Color statusColor;
  final List<ReportParameter> parameters;
  final String interpretation;
  final String advice;

  const ReportAnalysisData({
    required this.reportName,
    required this.source,
    required this.date,
    required this.overallStatus,
    required this.statusColor,
    required this.parameters,
    required this.interpretation,
    required this.advice,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final String timestamp;
  final Doctor? recommendedDoctor;
  final List<String>? actionChips;
  final bool isEmergency;
  final String? attachmentName;
  final ReportAnalysisData? reportAnalysis;
  final bool isWelcomeCard;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.recommendedDoctor,
    this.actionChips,
    this.isEmergency = false,
    this.attachmentName,
    this.reportAnalysis,
    this.isWelcomeCard = false,
  });
}

class AiAssistantScreen extends StatefulWidget {
  final String? initialPrompt;

  const AiAssistantScreen({
    super.key,
    this.initialPrompt,
  });

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  String _typingStatus = 'AI is analyzing clinical triage...';
  String? _pendingAttachment;

  final List<String> _quickPrompts = const [
    '🩺 Check My Symptoms',
    '📸 Scan Medical Report',
    '🏥 Pre-Surgery Fasting',
    '💊 Medication Dosage',
    '🩹 Post-Op Wound Care',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
    if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleSubmitted(widget.initialPrompt!);
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialMessages() {
    _messages.add(
      const ChatMessage(
        id: 'msg_welcome',
        text:
            'Hello Ali! I am your CareSpectrum AI Health & Surgical Assistant.\n\nI can analyze your symptoms, provide pre-op and post-op protocols, review medication guidelines, or scan and analyze physical lab test reports via your Camera or Gallery.',
        isUser: false,
        timestamp: 'Just now',
        isWelcomeCard: true,
        actionChips: [
          '📸 Scan Lab Report',
          '🩺 Check Symptoms',
          '🏥 Surgical Fasting',
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSubmitted(String text) {
    final query = text.trim();
    if (query.isEmpty && _pendingAttachment == null) return;

    if (query == '📸 Scan Medical Report' || query == '📸 Scan Lab Report') {
      _showReportUploadSheet();
      return;
    }

    final userMsg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: query.isEmpty ? 'Attached document for AI clinical analysis' : query,
      isUser: true,
      timestamp: _formatCurrentTime(),
      attachmentName: _pendingAttachment,
    );

    setState(() {
      _messages.add(userMsg);
      _isTyping = true;
      _typingStatus = 'CareSpectrum AI is evaluating clinical triage...';
      _pendingAttachment = null;
    });
    _textController.clear();
    _scrollToBottom();

    // Simulate smart medical triage response with realistic delay
    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final aiResponse = _generateAiResponse(query);
      setState(() {
        _isTyping = false;
        _messages.add(aiResponse);
      });
      _scrollToBottom();
    });
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final min = now.minute.toString().padLeft(2, '0');
    return '$hour:$min $period';
  }

  void _showReportUploadSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      backgroundColor: AppColors.surface,
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(
                    Icons.document_scanner_outlined,
                    color: AppColors.primary,
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Upload Medical Report',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'AI extracts clinical parameters and reference ranges instantly',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),

              // Source Options: Camera & Gallery
              Row(
                children: [
                  Expanded(
                    child: _buildUploadOptionTile(
                      icon: Icons.camera_alt_outlined,
                      label: 'Take Photo',
                      sublabel: 'Camera scan',
                      color: const Color(0xFF0284C7),
                      bgColor: const Color(0xFFEFF6FF),
                      onTap: () {
                        Navigator.pop(sheetCtx);
                        _processReportAnalysis(
                          source: 'Camera Scan',
                          preset: 'CBC',
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildUploadOptionTile(
                      icon: Icons.photo_library_outlined,
                      label: 'Choose Photo',
                      sublabel: 'From Gallery',
                      color: const Color(0xFF059669),
                      bgColor: const Color(0xFFECFDF5),
                      onTap: () {
                        Navigator.pop(sheetCtx);
                        _processReportAnalysis(
                          source: 'Gallery Photo',
                          preset: 'LIPID',
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                'OR TEST WITH A SAMPLE REPORT',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),

              _buildSampleReportTile(
                title: 'Blood Complete Picture (CBC)',
                subtitle: 'Hemoglobin, Platelets, TLC (Normal Profile)',
                icon: Icons.science_outlined,
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _processReportAnalysis(
                    source: 'Chughtai Lab Scan',
                    preset: 'CBC',
                  );
                },
              ),
              const SizedBox(height: 8),
              _buildSampleReportTile(
                title: 'Fasting Lipid & Cholesterol Profile',
                subtitle: 'Total Cholesterol, LDL, HDL (Borderline High)',
                icon: Icons.water_drop_outlined,
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _processReportAnalysis(
                    source: 'Shifa Lab Scan',
                    preset: 'LIPID',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadOptionTile({
    required IconData icon,
    required String label,
    required String sublabel,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 11,
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleReportTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  void _processReportAnalysis({
    required String source,
    required String preset,
  }) {
    final fileName = preset == 'LIPID'
        ? 'Lipid_Profile_Report_Scan.jpg'
        : 'Blood_CBC_Report_Scan.jpg';

    // 1. Add user message with attachment pill
    final userMsg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: 'Uploaded medical test report for AI clinical breakdown.',
      isUser: true,
      timestamp: _formatCurrentTime(),
      attachmentName: '$source ($fileName)',
    );

    setState(() {
      _messages.add(userMsg);
      _isTyping = true;
      _typingStatus = 'Vision AI is scanning OCR text & parameters...';
    });
    _scrollToBottom();

    // 2. Simulate AI Vision Scan & extraction
    Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;

      ReportAnalysisData reportData;
      Doctor? doc;

      if (preset == 'LIPID') {
        reportData = const ReportAnalysisData(
          reportName: 'Fasting Lipid & Cholesterol Profile',
          source: 'Gallery Scan • Shifa Lab',
          date: '16 Nov, 2026',
          overallStatus: 'Borderline Elevation Detected',
          statusColor: Color(0xFFD97706),
          parameters: [
            ReportParameter(
              name: 'Total Cholesterol',
              value: '215 mg/dL',
              refRange: '< 200 mg/dL',
              status: 'High',
              isAbnormal: true,
            ),
            ReportParameter(
              name: 'LDL (Bad Cholesterol)',
              value: '138 mg/dL',
              refRange: '< 100 mg/dL',
              status: 'Borderline',
              isAbnormal: true,
            ),
            ReportParameter(
              name: 'HDL (Good Cholesterol)',
              value: '48 mg/dL',
              refRange: '> 40 mg/dL',
              status: 'Optimal',
            ),
            ReportParameter(
              name: 'Triglycerides',
              value: '142 mg/dL',
              refRange: '< 150 mg/dL',
              status: 'Normal',
            ),
          ],
          interpretation:
              'Total cholesterol and LDL are mildly elevated above ideal cardiovascular thresholds. HDL and triglycerides remain healthy.',
          advice:
              'Adopt low-cholesterol dietary measures, engage in 30 mins brisk walking, and consult a cardiothoracic specialist.',
        );
        doc = MockData.doctors.first; // Dr. Tariq Mahmood
      } else {
        reportData = const ReportAnalysisData(
          reportName: 'Complete Blood Count (CBC) Report',
          source: 'Camera Scan • Chughtai Diagnostic',
          date: '16 Nov, 2026',
          overallStatus: 'All Tested Values Normal',
          statusColor: Color(0xFF059669),
          parameters: [
            ReportParameter(
              name: 'Hemoglobin (Hb)',
              value: '14.2 g/dL',
              refRange: '13.0 - 17.0 g/dL',
              status: 'Normal',
            ),
            ReportParameter(
              name: 'WBC (Total Leukocyte)',
              value: '6,800 /uL',
              refRange: '4,000 - 11,000',
              status: 'Normal',
            ),
            ReportParameter(
              name: 'Platelet Count',
              value: '245,000 /uL',
              refRange: '150k - 450k',
              status: 'Normal',
            ),
            ReportParameter(
              name: 'ESR (1st Hour)',
              value: '12 mm/hr',
              refRange: '0 - 20 mm/hr',
              status: 'Normal',
            ),
          ],
          interpretation:
              'Hematological indices show healthy red cell density and no evidence of active infection, anemia, or systemic inflammation.',
          advice:
              'Maintain balanced hydration and nutrition. No immediate clinical intervention required.',
        );
      }

      final aiMsg = ChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        text:
            'I have scanned and extracted the clinical parameters from your report. Here is the structured AI analysis:',
        isUser: false,
        timestamp: _formatCurrentTime(),
        reportAnalysis: reportData,
        recommendedDoctor: doc,
        actionChips: ['Save to Health Vault', 'Ask Follow-up Question'],
      );

      setState(() {
        _isTyping = false;
        _messages.add(aiMsg);
      });
      _scrollToBottom();
    });
  }

  ChatMessage _generateAiResponse(String input) {
    final lower = input.toLowerCase();

    // 1. Emergency Red-flag triggers
    if (lower.contains('chest pain') ||
        lower.contains('heart attack') ||
        lower.contains('unconscious') ||
        lower.contains('severe breathing')) {
      return ChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        text:
            '⚠️ CLINICAL RED FLAG DETECTED:\n\nSudden acute chest tightness or severe shortness of breath requires immediate clinical evaluation.\n\n• Please visit the nearest hospital or emergency clinic immediately.\n• Rest in a seated 45° angle position.\n• Do not exert physical energy.',
        isUser: false,
        timestamp: _formatCurrentTime(),
        isEmergency: true,
        recommendedDoctor: MockData.doctors.firstWhere(
          (d) => d.specialty.contains('Cardio'),
          orElse: () => MockData.doctors.first,
        ),
        actionChips: ['Book Emergency Consult', 'Notify Family'],
      );
    }

    // 2. Pre-surgery fasting and protocols
    if (lower.contains('fasting') ||
        lower.contains('surgery') ||
        lower.contains('pre-op') ||
        lower.contains('laparoscop') ||
        lower.contains('operation')) {
      return ChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        text:
            '📋 PRE-OPERATIVE SURGICAL FASTING PROTOCOL:\n\n• Solid Foods: Nil per os (NPO) 8 hours prior to anesthesia.\n• Clear Fluids: Water or plain black tea permitted up to 2 hours pre-procedure.\n• Medications: Continue daily morning beta-blockers with a sip of water unless instructed otherwise by anesthesia.\n• Bring your physical Health Vault records folder.',
        isUser: false,
        timestamp: _formatCurrentTime(),
        recommendedDoctor: MockData.doctors.firstWhere(
          (d) => d.specialty.contains('Laparoscopic') || d.specialty.contains('General'),
          orElse: () => MockData.doctors[2],
        ),
        actionChips: ['View Surgical Checklist', 'Consult Anesthetist'],
      );
    }

    // 3. Medication & Prescription Dosage
    if (lower.contains('medicine') ||
        lower.contains('concor') ||
        lower.contains('panadol') ||
        lower.contains('dose') ||
        lower.contains('pill') ||
        lower.contains('prescription')) {
      return ChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        text:
            '💊 MEDICATION SAFETY GUIDANCE:\n\n• Tab. Concor (Bisoprolol): Best taken once daily in the morning after food. Do not skip or double dose.\n• Analgesics (e.g. Panadol Extra): Use strictly after meals to prevent gastric mucosal irritation.\n• Any dizziness or palpitations should be reported immediately.',
        isUser: false,
        timestamp: _formatCurrentTime(),
        actionChips: ['Check My Prescriptions', 'Set Pill Reminder'],
      );
    }

    // 4. Post-Op Recovery & Wound Care
    if (lower.contains('wound') ||
        lower.contains('post-op') ||
        lower.contains('dressing') ||
        lower.contains('recovery') ||
        lower.contains('pain')) {
      return ChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        text:
            '🩹 POST-OPERATIVE RECOVERY & WOUND CARE:\n\n• Keep surgical dressing clean, dry, and undisturbed for 48 hours.\n• Mild incisional tenderness is expected; severe redness, hot swelling, or purulent discharge requires inspection.\n• Avoid strenuous lifting exceeding 5 kg for 3 weeks.',
        isUser: false,
        timestamp: _formatCurrentTime(),
        recommendedDoctor: MockData.doctors[2], // Dr. Salman Haider
        actionChips: ['Upload Wound Photo', 'Book Post-Op Follow-up'],
      );
    }

    // 5. General Symptom Checker & Specialty Matching
    Doctor suggestedDoc = MockData.doctors.first;
    String docSpecialty = 'Specialist';
    if (lower.contains('head') || lower.contains('migraine') || lower.contains('neuro')) {
      suggestedDoc = MockData.doctors[1]; // Dr. Ayesha Siddiqa (Neuro)
      docSpecialty = 'Neurosurgeon';
    } else if (lower.contains('bone') || lower.contains('knee') || lower.contains('joint')) {
      suggestedDoc = MockData.doctors[4]; // Dr. Usman Farooq (Ortho)
      docSpecialty = 'Orthopedic Surgeon';
    } else if (lower.contains('child') || lower.contains('baby') || lower.contains('fever')) {
      suggestedDoc = MockData.doctors[3]; // Dr. Fatima Noor (Pediatric)
      docSpecialty = 'Pediatrician';
    } else {
      suggestedDoc = MockData.doctors[0]; // Dr. Tariq Mahmood (Cardio)
      docSpecialty = 'Consultant Physician';
    }

    return ChatMessage(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      text:
          '🩺 CLINICAL TRIAGE ASSESSMENT:\n\nBased on your reported query, your symptoms appear consistent with mild to moderate clinical strain.\n\n• Immediate Step: Hydrate adequately, rest, and log your current temperature & blood pressure.\n• Recommended Specialist: A teleconsultation with a $docSpecialty is recommended for clinical review.',
      isUser: false,
      timestamp: _formatCurrentTime(),
      recommendedDoctor: suggestedDoc,
      actionChips: ['Book Consultation', 'Log Current Vitals'],
    );
  }

  void _clearChatDialog() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Reset Conversation?',
          style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'This will clear your current AI triage chat history for this session.',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              setState(() {
                _messages.clear();
                _loadInitialMessages();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Clear Chat'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'CareSpectrum AI',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.document_scanner_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    onPressed: _showReportUploadSheet,
                    tooltip: 'Scan Medical Report',
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.refresh_rounded,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: _clearChatDialog,
                    tooltip: 'Reset Conversation',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. Messages List (Clean, Full Screen Height)
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // 2. Quick Suggestion Pills (Minimalist Horizontal Bar)
          Container(
            height: 34,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _quickPrompts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => _handleSubmitted(_quickPrompts[index]),
                  borderRadius: BorderRadius.circular(17),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: AppColors.border),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _quickPrompts[index],
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 3. Pending Attachment Pill (if selected)
          if (_pendingAttachment != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: const Color(0xFFEFF6FF),
              child: Row(
                children: [
                  const Icon(Icons.attach_file_rounded,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ready to send: $_pendingAttachment',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        size: 16, color: AppColors.textSecondary),
                    onPressed: () => setState(() => _pendingAttachment = null),
                  ),
                ],
              ),
            ),

          // 4. Bottom Input Bar (Clean, Unified Full-Width Box)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _textController,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Type your message',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    prefixIcon: IconButton(
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: _showReportUploadSheet,
                      tooltip: 'Scan or Attach Report',
                    ),
                    prefixIconConstraints:
                        const BoxConstraints(minWidth: 42, minHeight: 42),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.send_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      onPressed: () => _handleSubmitted(_textController.text),
                      tooltip: 'Send',
                    ),
                    suffixIconConstraints:
                        const BoxConstraints(minWidth: 44, minHeight: 42),
                  ),
                  onSubmitted: _handleSubmitted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    if (msg.isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              msg.timestamp,
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (msg.attachmentName != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.camera_alt_outlined,
                                size: 13, color: Colors.white),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                msg.attachmentName!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    Text(
                      msg.text,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // AI Response Bubble (Clean Card Layout)
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: msg.isEmergency
                ? const Color(0xFFFECACA)
                : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Header Tag Strip
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: msg.isEmergency
                        ? const Color(0xFFFEF2F2)
                        : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    msg.isEmergency
                        ? Icons.warning_amber_rounded
                        : Icons.smart_toy_outlined,
                    size: 13,
                    color: msg.isEmergency
                        ? const Color(0xFFEF4444)
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'CareSpectrum AI',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: msg.isEmergency
                        ? const Color(0xFFEF4444)
                        : AppColors.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  msg.timestamp,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Message Body Text
            Text(
              msg.text,
              style: TextStyle(
                fontSize: 13,
                color: msg.isEmergency
                    ? const Color(0xFF991B1B)
                    : AppColors.textPrimary,
                height: 1.45,
              ),
            ),

            // Welcome Card Action: Quick Report Scan Banner
            if (msg.isWelcomeCard) ...[
              const SizedBox(height: 14),
              InkWell(
                onTap: _showReportUploadSheet,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.25),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          size: 20, color: Color(0xFF0284C7)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Scan Medical Lab Report',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                            Text(
                              'Instant Camera or Gallery Photo Analysis',
                              style: TextStyle(
                                fontSize: 10.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 12, color: Color(0xFF0284C7)),
                    ],
                  ),
                ),
              ),
            ],

            // Structured Medical Report Analysis Card (if present)
            if (msg.reportAnalysis != null) ...[
              const SizedBox(height: 12),
              _buildReportAnalysisCard(msg.reportAnalysis!),
            ],

            // Embedded Doctor Recommendation Card (if present)
            if (msg.recommendedDoctor != null) ...[
              const SizedBox(height: 12),
              _buildDoctorRecommendationCard(msg.recommendedDoctor!),
            ],

            // Action Chips inside AI message
            if (msg.actionChips != null && msg.actionChips!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: msg.actionChips!.map((chip) {
                  return InkWell(
                    onTap: () {
                      if (chip == 'Save to Health Vault') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    color: Colors.white, size: 18),
                                SizedBox(width: 8),
                                Text('Report saved to your Health Vault!'),
                              ],
                            ),
                            backgroundColor: Color(0xFF059669),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } else {
                        _handleSubmitted(chip);
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        chip,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Clinical Report Analysis Card (Clean Minimal Layout)
  Widget _buildReportAnalysisCard(ReportAnalysisData report) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Report Name & Status Pill
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: report.statusColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        report.reportName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: report.statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        report.overallStatus,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: report.statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${report.source} • ${report.date}',
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Parameters Table
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Table Header
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          'PARAMETER',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'RESULT',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'REF RANGE',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                // Parameter Rows
                ...report.parameters.map((param) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            param.name,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            param.value,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: param.isAbnormal
                                  ? const Color(0xFFD97706)
                                  : const Color(0xFF059669),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            param.refRange,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          // Clinical Summary Note
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 15,
                  color: report.statusColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.interpretation,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textPrimary,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Recommendation: ${report.advice}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action: Save to Vault Button
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SizedBox(
              width: double.infinity,
              height: 34,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text('"${report.reportName}" saved to Health Vault'),
                        ],
                      ),
                      backgroundColor: const Color(0xFF059669),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.folder_shared_outlined, size: 14),
                label: const Text('Save Report to Health Vault'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorRecommendationCard(Doctor doc) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(doc.imageUrl),
            backgroundColor: AppColors.primaryLight,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.name,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  doc.specialty,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AppointmentBookingScreen(doctor: doc),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: const Size(0, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Book Slot',
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _typingStatus,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
