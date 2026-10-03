import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/dashboard/presentation/blocs/dashboard_bloc.dart';

/// Halaman Ubah Informasi Karyawan
///
/// Mengikuti standar Mingda UI Design Pattern & Clean Solid Surface:
/// - Clean Solid Surface with Crisp White Border & AppShadows.shadow094
/// - Mingda Corporate Teal unified palette (Soft Mint squircle #F0FDFA, border #CCFBF1, icon #0D9488)
/// - Ergonomic form input (contentPadding 16.w horizontal, 14.w vertical, rounded icons)
/// - Integrated contextual HRD notice & locked kepegawaian cards
class EditInformationPage extends StatefulWidget {
  final ProfileEntity profile;

  const EditInformationPage({super.key, required this.profile});

  @override
  State<EditInformationPage> createState() => _EditInformationPageState();
}

class _EditInformationPageState extends State<EditInformationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for editable fields (tersedia di docs & profile)
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  late String _profilePhoto;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameController = TextEditingController(text: p.name);
    _phoneController = TextEditingController(text: p.phone);
    _emailController = TextEditingController(text: p.email);
    _profilePhoto = p.profilePhoto;
    _nameController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    final clean = name.trim();
    if (clean.isEmpty) return 'MI';
    final parts = clean.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  void _showChangePhotoModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 14.w, 20.w, 28.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                  ),
                ),
                SizedBox(height: 16.w),
                Text(
                  context.tr.changePhotoModalTitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.w,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.w),
                Text(
                  context.tr.photoFormatHint,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.w,
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 14.w),
                _PhotoOptionTile(
                  icon: Icons.camera_alt_rounded,
                  title: context.tr.takePhotoCamera,
                  subtitle: context.tr.takePhotoCameraSub,
                  onTap: () {
                    Navigator.pop(ctx);
                    _simulatePhotoSelection(
                      'assets/img/SXjGsFTmyKziA5U3bkxY85nZ53l4ld.jpg',
                    );
                  },
                ),
                _PhotoOptionTile(
                  icon: Icons.photo_library_rounded,
                  title: context.tr.chooseFromGallery,
                  subtitle: context.tr.chooseFromGallerySub,
                  onTap: () {
                    Navigator.pop(ctx);
                    _simulatePhotoSelection(
                      'assets/img/SXjGsFTmyKziA5U3bkxY85nZ53l4ld.jpg',
                    );
                  },
                ),
                _PhotoOptionTile(
                  icon: Icons.account_circle_rounded,
                  title: context.tr.useMonogramAvatar,
                  subtitle: context.tr.useMonogramAvatarSub,
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _profilePhoto = '';
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _simulatePhotoSelection(String path) {
    setState(() {
      _profilePhoto = path;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18.w),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                context.tr.profilePhotoSelectedSuccess,
                style: TextStyle(fontFamily: 'Inter', fontSize: 12.5.w),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0D9488),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // Update profile entity with available editable fields
    final updated = widget.profile.copyWith(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      profilePhoto: _profilePhoto,
      profilePhotoUrl: _profilePhoto,
    );

    context.read<DashboardBloc>().add(
      DashboardUpdateProfile(
        profile: updated,
        onSuccess: (newProfile) {
          if (!mounted) return;
          setState(() => _isSaving = false);
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 18.w,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      context.tr.profileUpdateSuccessMessage,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.5.w,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF0D9488),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        },
        onError: (errorMessage) {
          if (!mounted) return;
          setState(() => _isSaving = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessage,
                style: TextStyle(fontFamily: 'Inter', fontSize: 12.5.w),
              ),
              backgroundColor: const Color(0xFFDC2626),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        shadowColor: AppColors.shadowAppBar,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr.editInformation,
          style: AppTextStyles.inter16MediumPrimary,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= SECTION 0: AVATAR CARD =================
                      _buildAvatarCard(),

                      SizedBox(height: 18.w),

                      // ================= CARD 1: INFORMASI KARYAWAN (EDITABLE) =================
                      _buildSectionHeader(
                        icon: Icons.person_rounded,
                        title: context.tr.personalDataSection,
                        subtitle: context.tr.editablePersonalSubtitle,
                        badgeText: context.tr.canEditBadge,
                        badgeColor: const Color(0xFFF0FDFA),
                        badgeBorderColor: const Color(0xFFCCFBF1),
                        badgeTextColor: const Color(0xFF0D9488),
                        badgeIcon: Icons.edit_rounded,
                      ),
                      SizedBox(height: 10.w),
                      _buildCardContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputLabel(
                              label: context.tr.fullNameLabel,
                              isRequired: true,
                            ),
                            SizedBox(height: 6.w),
                            TextFormField(
                              controller: _nameController,
                              style: _inputTextStyle,
                              decoration: _inputDecoration(
                                hint: context.tr.fullNameHint,
                                prefixIcon: Icons.badge_rounded,
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return context.tr.fullNameRequired;
                                }
                                if (val.trim().length < 2) {
                                  return context.tr.fullNameTooShort;
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 16.w),

                            _buildInputLabel(
                              label: context.tr.phoneNumberLabel,
                              isRequired: true,
                            ),
                            SizedBox(height: 6.w),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: _inputTextStyle,
                              decoration: _inputDecoration(
                                hint: '08xxxxxxxxxx',
                                prefixIcon: Icons.phone_rounded,
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return context.tr.phoneRequired;
                                }
                                if (val.trim().length < 9) {
                                  return context.tr.phoneInvalid;
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 16.w),

                            _buildInputLabel(
                              label: context.tr.emailLabel,
                              isRequired: true,
                            ),
                            SizedBox(height: 6.w),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: _inputTextStyle,
                              decoration: _inputDecoration(
                                hint: context.tr.emailHint,
                                prefixIcon: Icons.mail_rounded,
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return context.tr.emailRequired;
                                }
                                if (!val.contains('@') || !val.contains('.')) {
                                  return context.tr.emailInvalid;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.w),

                      // ================= CARD 2: DATA KEPEGAWAIAN (TERKUNCI) =================
                      _buildSectionHeader(
                        icon: Icons.shield_rounded,
                        title: context.tr.lockedByHrdNotice,
                        subtitle:
                            'Data resmi perusahaan dari sistem kehadiran',
                        badgeText: context.tr.locked,
                        badgeColor: const Color(0xFFF1F5F9),
                        badgeBorderColor: const Color(0xFFE2E8F0),
                        badgeTextColor: const Color(0xFF64748B),
                        badgeIcon: Icons.lock_rounded,
                        isLocked: true,
                      ),
                      SizedBox(height: 10.w),
                      _buildCardContainer(
                        child: Column(
                          children: [
                            _buildReadOnlyTile(
                              icon: Icons.qr_code_2_rounded,
                              label: context.tr.employeeCodeLabel,
                              value: widget.profile.employeeCode,
                              trailing: Icon(
                                Icons.lock_rounded,
                                size: 13.w,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                            _buildDivider(),
                            _buildReadOnlyTile(
                              icon: Icons.business_rounded,
                              label: context.tr.departmentLabel,
                              value: widget.profile.department.name,
                              trailing: Icon(
                                Icons.lock_rounded,
                                size: 13.w,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                            _buildDivider(),
                            _buildReadOnlyTile(
                              icon: Icons.work_rounded,
                              label: context.tr.positionLabel,
                              value: widget.profile.position.displayName,
                              trailing: Icon(
                                Icons.lock_rounded,
                                size: 13.w,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                            _buildDivider(),
                            _buildReadOnlyTile(
                              icon: Icons.schedule_rounded,
                              label: context.tr.workSchedule,
                              value: widget.profile.shiftType,
                              trailing: Icon(
                                Icons.lock_rounded,
                                size: 13.w,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),

                            SizedBox(height: 14.w),

                            // Integrated HRD Notice inside Kepegawaian Card
                            _buildHrdNoticeCard(),
                          ],
                        ),
                      ),

                      SizedBox(height: 16.w),

                      // ================= CARD 3: PETUNJUK UBAH PASSWORD =================
                      _buildPasswordHintCard(),

                      SizedBox(height: 24.w),
                    ],
                  ),
                ),
              ),
            ),

            // ================= STICKY BOTTOM ACTION BAR (GRADIENT TANPA IKON) =================
            _buildStickyActionBar(),
          ],
        ),
      ),
    );
  }

  // ================= HELPER WIDGETS =================

  Widget _buildAvatarCard() {
    final displayName = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : widget.profile.name;
    final initials = _getInitials(displayName);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(color: Colors.white, width: 1.5.w),
        boxShadow: const [AppShadows.shadow094],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 66.w,
                height: 66.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.w),
                  border: Border.all(
                    color: const Color(0xFFCCFBF1),
                    width: 2.w,
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D9488).withValues(alpha: 0.20),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: _buildInitialsText(initials),
              ),
              Positioned(
                bottom: -2.w,
                right: -2.w,
                child: GestureDetector(
                  onTap: _showChangePhotoModal,
                  child: Container(
                    width: 26.w,
                    height: 26.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D9488),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 13.w,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.5.w,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(6.w),
                        border: Border.all(
                          color: const Color(0xFFBBF7D0),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00AA13),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            context.tr.activeEmployeeBadge,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10.5.w,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF15803D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 3.5.w,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(6.w),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 0.8.w,
                          ),
                        ),
                        child: Text(
                          widget.profile.employeeCode,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.5.w,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.w),
                Text(
                  displayName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.w,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.w),
                Text(
                  context.tr.tapToChangePhoto,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5.w,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialsText(String initials) {
    return Text(
      initials,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 22.w,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildHrdNoticeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16.w,
            color: const Color(0xFF0D9488),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              context.tr.hrdNoticeCard,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.w,
                color: const Color(0xFF475569),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordHintCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: Colors.white, width: 1.5.w),
        boxShadow: const [AppShadows.shadow094],
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDFA),
              borderRadius: BorderRadius.circular(8.w),
              border: Border.all(color: const Color(0xFFCCFBF1), width: 1.w),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.lock_reset_rounded,
              size: 18.w,
              color: const Color(0xFF0D9488),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.wantToChangePassword,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.5.w,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.w),
                Text(
                  context.tr.wantToChangePasswordSub,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.w,
                    color: const Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required Color badgeBorderColor,
    required Color badgeTextColor,
    required IconData badgeIcon,
    bool isLocked = false,
  }) {
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: isLocked ? const Color(0xFFF1F5F9) : const Color(0xFFF0FDFA),
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(
              color: isLocked
                  ? const Color(0xFFE2E8F0)
                  : const Color(0xFFCCFBF1),
              width: 1.w,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 18.w,
            color: isLocked ? const Color(0xFF475569) : const Color(0xFF0D9488),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.w,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 1.w),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.5.w,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.5.w),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(20.w),
            border: Border.all(color: badgeBorderColor, width: 0.8.w),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(badgeIcon, size: 10.w, color: badgeTextColor),
              SizedBox(width: 4.w),
              Text(
                badgeText,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.w,
                  fontWeight: FontWeight.w600,
                  color: badgeTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(color: Colors.white, width: 1.5.w),
        boxShadow: const [AppShadows.shadow094],
      ),
      child: child,
    );
  }

  Widget _buildInputLabel({required String label, bool isRequired = false}) {
    return Text.rich(
      TextSpan(
        text: label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13.w,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF334155),
        ),
        children: [
          if (isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.w,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFEF4444),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyTile({
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
  }) {
    final displayValue = value.trim().isNotEmpty ? value : '-';
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.w),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDFA),
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: const Color(0xFFCCFBF1), width: 1.w),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 19.w, color: const Color(0xFF0D9488)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5.w,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 2.w),
                Text(
                  displayValue,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.w,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[SizedBox(width: 8.w), trailing],
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.w),
      height: 1.w,
      color: const Color(0xFFF1F5F9),
    );
  }

  Widget _buildStickyActionBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Container(
        height: 50.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.w),
          gradient: _isSaving
              ? LinearGradient(
                  colors: [
                    AppColors.filterGradientStart.withValues(alpha: 0.7),
                    AppColors.filterGradientEnd.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [
                    AppColors.filterGradientStart,
                    AppColors.filterGradientEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D9488).withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isSaving ? null : _submitForm,
            borderRadius: BorderRadius.circular(12.w),
            splashColor: Colors.white.withValues(alpha: 0.2),
            highlightColor: Colors.white.withValues(alpha: 0.1),
            child: Center(
              child: _isSaving
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          context.tr.saving,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.w,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      context.tr.saveChanges,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.5.w,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle get _inputTextStyle => TextStyle(
    fontFamily: 'Inter',
    fontSize: 13.5.w,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  InputDecoration _inputDecoration({
    required String hint,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.w),
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13.w,
        color: const Color(0xFF94A3B8),
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, size: 19.w, color: const Color(0xFF64748B))
          : null,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.w),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.w),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.w),
        borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.w),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.w),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
    );
  }
}

class _PhotoOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PhotoOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.w),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 8.w),
          child: Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDFA),
                  borderRadius: BorderRadius.circular(10.w),
                  border: Border.all(
                    color: const Color(0xFFCCFBF1),
                    width: 1.w,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 20.w, color: const Color(0xFF0D9488)),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.5.w,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.w,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.w,
                color: const Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
