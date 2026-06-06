import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.employeeCode,
    super.fingerspotPin,
    required super.nik,
    required super.name,
    required super.gender,
    required super.birthPlace,
    required super.birthDate,
    required super.maritalStatus,
    required super.agama,
    required super.bangsa,
    required super.statusKependudukan,
    required super.tanggunganAnak,
    required super.namaIbuKandung,
    required super.ktp,
    required super.kartuKeluarga,
    required super.departmentId,
    required super.subDepartmentId,
    super.subDepartmentOld,
    required super.positionId,
    required super.joinDate,
    required super.employmentStatus,
    required super.serikat,
    required super.lulusanSekolah,
    required super.workScheduleId,
    super.supervisorId,
    super.salaryBase,
    required super.bank,
    required super.nomorRekening,
    required super.taxNpwp,
    required super.bpjsKesehatan,
    required super.bpjsKetenagakerjaan,
    required super.address,
    required super.city,
    required super.province,
    required super.desa,
    required super.kecamatan,
    required super.kabupaten,
    required super.postalCode,
    required super.phone,
    required super.email,
    required super.emergencyContactName,
    required super.emergencyContactPhone,
    required super.userId,
    required super.status,
    super.tanggalResign,
    super.tanggalMangkir,
    super.tanggalGagalProbation,
    super.tanggalPending,
    required super.profilePhoto,
    required super.createdAt,
    required super.updatedAt,
    required super.shiftType,
    required super.profilePhotoUrl,
    required super.department,
    required super.position,
    required super.workSchedule,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return ProfileModel(
      id: data['id'],
      employeeCode: data['employee_code'],
      fingerspotPin: data['fingerspot_pin'],
      nik: data['nik'],
      name: data['name'],
      gender: data['gender'],
      birthPlace: data['birth_place'],
      birthDate: data['birth_date'],
      maritalStatus: data['marital_status'],
      agama: data['agama'],
      bangsa: data['bangsa'],
      statusKependudukan: data['status_kependudukan'],
      tanggunganAnak: data['tanggungan_anak'],
      namaIbuKandung: data['nama_ibu_kandung'],
      ktp: data['ktp'],
      kartuKeluarga: data['kartu_keluarga'],
      departmentId: data['department_id'],
      subDepartmentId: data['sub_department_id'],
      subDepartmentOld: data['sub_department_old'],
      positionId: data['position_id'],
      joinDate: data['join_date'],
      employmentStatus: data['employment_status'],
      serikat: data['serikat'],
      lulusanSekolah: data['lulusan_sekolah'],
      workScheduleId: data['work_schedule_id'],
      supervisorId: data['supervisor_id'],
      salaryBase: data['salary_base'] != null
          ? (data['salary_base'] as num).toDouble()
          : null,
      bank: data['bank'],
      nomorRekening: data['nomor_rekening'],
      taxNpwp: data['tax_npwp'],
      bpjsKesehatan: data['bpjs_kesehatan'],
      bpjsKetenagakerjaan: data['bpjs_ketenagakerjaan'],
      address: data['address'],
      city: data['city'],
      province: data['province'],
      desa: data['desa'],
      kecamatan: data['kecamatan'],
      kabupaten: data['kabupaten'],
      postalCode: data['postal_code'],
      phone: data['phone'],
      email: data['email'],
      emergencyContactName: data['emergency_contact_name'],
      emergencyContactPhone: data['emergency_contact_phone'],
      userId: data['user_id'],
      status: data['status'],
      tanggalResign: data['tanggal_resign'],
      tanggalMangkir: data['tanggal_mangkir'],
      tanggalGagalProbation: data['tanggal_gagal_probation'],
      tanggalPending: data['tanggal_pending'],
      profilePhoto: data['profile_photo'],
      createdAt: data['created_at'],
      updatedAt: data['updated_at'],
      shiftType: data['shift_type'],
      profilePhotoUrl: data['profile_photo_url'],
      department: DepartmentModel.fromJson(data['department']),
      position: PositionModel.fromJson(data['position']),
      workSchedule: WorkScheduleModel.fromJson(data['work_schedule']),
    );
  }
}

class DepartmentModel extends DepartmentEntity {
  const DepartmentModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class PositionModel extends PositionEntity {
  const PositionModel({
    required super.id,
    required super.code,
    required super.name,
    super.level,
    required super.description,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required super.displayName,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      level: json['level'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      displayName: json['display_name'],
    );
  }
}

class WorkScheduleModel extends WorkScheduleEntity {
  const WorkScheduleModel({
    required super.id,
    required super.name,
    required super.startTime,
    required super.endTime,
    required super.lateTolerance,
    required super.overtimeThreshold,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory WorkScheduleModel.fromJson(Map<String, dynamic> json) {
    return WorkScheduleModel(
      id: json['id'],
      name: json['name'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      lateTolerance: json['late_tolerance'],
      overtimeThreshold: json['overtime_threshold'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
